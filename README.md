#SkyLine — Airline Reservation & Management System

> **Module:** CC5054NP — Advanced Programming and Technology  
> **Group:** Java Hut

SkyLine is a full-stack web application for managing airline reservations. It supports two roles — **Admin** and **Passenger** — with secure authentication, flight management, booking workflows, and reporting features, all built with pure Java EE and no external UI frameworks.

---

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Database Setup](#database-setup)
- [Running the App](#running-the-app)
- [User Roles](#user-roles)
- [Team](#team)

---

## Features

### Passenger
- Register and log in securely
- Search and browse available flights
- Book and cancel flights
- Save flights to a wishlist (via HttpSession)

### Admin
- Approve or reject passenger registrations
- Full CRUD for Flights and Aircraft
- View reports: most booked flights, revenue, seat availability
- Manage all bookings

### General
- Role-based access control with session management
- BCrypt password hashing
- Auth filter protecting all secured routes
- Input validation and custom error pages
- Fully responsive UI — Flexbox + Media Queries, no Bootstrap

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 17 |
| Backend | Jakarta Servlet 6.0, JSP 3.1 |
| Templating | JSTL 3.0 |
| Database | MySQL 8+ |
| JDBC Driver | MySQL Connector/J 9.1.0 |
| Security | jBCrypt 0.4 |
| Server | Apache Tomcat 10.1.34 |
| Build Tool | Maven 3 (WAR packaging) |
| Frontend | Pure CSS — Flexbox, Media Queries |
| Architecture | MVC + DAO + Service + Filter |

---

## Project Structure

```
SkyLine-Airline-System/
├── src/main/java/com/aeromanage/
│   ├── controller/          # Servlets (LoginServlet, RegisterServlet, HomeServlet, ...)
│   ├── dao/                 # Data Access Objects (JDBC)
│   ├── entity/              # POJOs / Beans (User, Flight, Booking, ...)
│   ├── service/             # Business logic layer
│   ├── filter/              # AuthFilter — protects secured routes
│   └── utils/               # DBConnection, PasswordUtil, SessionUtil
│
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── views/
│   │   │   ├── admin/       # Admin JSP pages
│   │   │   ├── passenger/   # Passenger JSP pages
│   │   │   ├── home.jsp
│   │   │   ├── login.jsp
│   │   │   ├── register.jsp
│   │   │   └── error.jsp
│   │   └── web.xml
│   └── static/
│       ├── css/             # main.css, auth.css, home.css
│       └── images/          # logo.png, Air.jpg
│
├── database/
│   ├── schema.sql           # Table definitions
│   └── sample-data.sql      # Seed data
│
├── pom.xml
├── .gitignore
└── README.md
```

---

## Getting Started

### Prerequisites

| Tool | Version |
|---|---|
| JDK | 17+ |
| Maven | 3.8+ |
| MySQL | 8.0+ |
| Git | Any recent version |

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/SkyLine-Airline-System.git
cd SkyLine-Airline-System
```

### 2. Configure the Database Connection

Open `src/main/java/com/aeromanage/utils/DBConnection.java` and update the credentials:

```java
private static final String DB_URL      = "jdbc:mysql://localhost:3306/aeromanage_db?useSSL=false&serverTimezone=UTC";
private static final String DB_USER     = "root";
private static final String DB_PASSWORD = "your_password_here";
```

---

## Database Setup

Run the scripts in order inside MySQL:

```sql
-- 1. Create and select the database
CREATE DATABASE aeromanage_db;
USE aeromanage_db;

-- 2. Run schema
SOURCE database/schema.sql;

-- 3. (Optional) Load sample data
SOURCE database/sample-data.sql;
```

The `users` table structure expected by the application:

```sql
CREATE TABLE users (
    user_id    INT AUTO_INCREMENT PRIMARY KEY,
    full_name  VARCHAR(100)  NOT NULL,
    email      VARCHAR(150)  NOT NULL UNIQUE,
    password   VARCHAR(255)  NOT NULL,          -- BCrypt hash
    phone      VARCHAR(20),
    role       ENUM('ADMIN', 'PASSENGER')        DEFAULT 'PASSENGER',
    status     ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    created_at TIMESTAMP                         DEFAULT CURRENT_TIMESTAMP
);
```

> **First Admin:** Insert one admin user manually with a pre-hashed password, then use the admin dashboard to approve all subsequent registrations.

---

## Running the App

The project uses the **Cargo Maven plugin** to download and start Tomcat automatically — no manual server setup needed.

```bash
# Build and start the embedded Tomcat server
mvn cargo:run
```

Then open your browser at:

```
http://localhost:9090/SkyLine
```

To stop the server, press `Ctrl + C`.

### Other useful Maven commands

```bash
mvn clean package          # Build the WAR file only
mvn cargo:run              # Build + deploy + start Tomcat
```

The compiled WAR is output to `target/SkyLine-Airline-System-1.0-SNAPSHOT.war`.

---

## User Roles

| Role | Access |
|---|---|
| **PASSENGER** | Register, search flights, book, cancel, wishlist |
| **ADMIN** | All passenger features + manage flights, aircraft, users, and reports |

### Registration Flow

1. Passenger submits the registration form.
2. Account is created with status `PENDING`.
3. Admin approves or rejects the account from the dashboard.
4. Only `APPROVED` accounts can log in.

### Default Route After Login

| Role | Redirects To |
|---|---|
| ADMIN | `/admin/dashboard` |
| PASSENGER | `/home` |

---

## Team

| # | Name |
|---|---|
| 1 | Kritagya Kumar Manandhar |
| 2 | Sujal Kumar Pariyar |
| 3 | Sujal Tiwari |
| 4 | Binod Tamang |
| 5 | Prajesh Thapa |
| 6 | Aditya Ale Magar |
