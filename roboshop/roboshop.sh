#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0b8550f464d4056aa"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z02627869X7KG52VMCNF"
DOMAIN_NAME="monnish.com"

for instance in ${INSTANCES[@]}
do
    echo "Launching instance: $instance"

    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id $AMI_ID \
        --instance-type t3.micro \
        --security-group-ids $SG_ID \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" \
        --query "Instances[0].InstanceId" \
        --output text)

    echo "Instance ID: $INSTANCE_ID"
    echo "Waiting for instance to be running..."

    # Wait until AWS marks it 'running'
    aws ec2 wait instance-running --instance-ids $INSTANCE_ID

    echo "Instance is running. Fetching IP..."

    IP=""
    
    # Retry until IP is available
    while [ -z "$IP" ] || [ "$IP" == "None" ]; do
        if [ "$instance" != "frontend" ]; then
            IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
                --query "Reservations[0].Instances[0].PrivateIpAddress" \
                --output text)
        else
            IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
                --query "Reservations[0].Instances[0].PublicIpAddress" \
                --output text)
        fi

        if [ "$IP" == "None" ]; then
            IP=""
        fi

        echo "Waiting for IP..."
        sleep 5
    done

    echo "$instance IP address: $IP"

    RECORD_NAME="$instance.$DOMAIN_NAME"
    if [ "$instance" == "frontend" ]; then
        RECORD_NAME="$DOMAIN_NAME"
    fi

    echo "Creating Route53 record: $RECORD_NAME → $IP"

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch "
    {
        \"Comment\": \"Creating or Updating record for $instance\",
        \"Changes\": [{
            \"Action\": \"UPSERT\",
            \"ResourceRecordSet\": {
                \"Name\": \"$RECORD_NAME\",
                \"Type\": \"A\",
                \"TTL\": 10,
                \"ResourceRecords\": [{ \"Value\": \"$IP\" }]
            }
        }]
    }"

    echo "Record created successfully!"
    echo "------------------------------------"

done