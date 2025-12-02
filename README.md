# RoboShop Microservices Application (IBM Based)

This project is a full microservices-based **RoboShop Application**, the  
The platform allows users to browse products, view robot details, add items to cart, and complete the purchase through a fully decoupled microservices ecosystem.

---

## 🚀 Project Overview

The RoboShop Application simulates an e-commerce platform for buying robots and electronic components.  
It contains **11+ microservices**, each responsible for a specific part of the workflow, making it a perfect project for learning:

- Cloud Computing  
- Microservices  
- Containerization  
- Docker & Kubernetes  
- Databases & Caching  
- API communication  
- Distributed systems  

---

## 🧩 Microservices Included

### **1. Frontend Service**
- React/HTML/CSS frontend
- Serves the main UI for the robot store

### **2. User Service**
- User registration, login, sessions  
- MongoDB backend

### **3. Catalog Service**
- Stores categories of robots  
- Fetches and displays catalog data

### **4. Product Service**
- Stores product details, descriptions, pricing  
- Connected to MongoDB

### **5. Cart Service**
- Manages user’s shopping cart  
- Uses Redis for fast session management  

### **6. Shipping Service**
- Calculates shipping cost  
- Handles delivery pipeline

### **7. Payment Service**
- Handles payment processing  
- Simulates success/failure flows  

### **8. MongoDB**
- Stores product, user, and catalog data  

### **9. Redis**
- Fast caching  
- Session storage for Cart & User service  

### **10. MySQL/Postgres**
- Orders or transactional data  

### **11.  RabbitMQ**
- Event-driven communication between services  

---

