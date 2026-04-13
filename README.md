# AeroManage - Airline Reservation and Management System
**Module:** CC5054NP - Advanced Programming and Technology
**Group:** Java Hut

##Key Features
- Role-based authentication (Admin / Passenger)
- Full CRUD operations for Flights & Aircraft (Admin)
- Flight search, booking, and cancellation (Passenger)
- Wishlist using HttpSession
- Responsive UI using pure CSS + Flexbox + Media Queries
- Secure password encryption
- Validation, Exception Handling & Custom Error Pages
- Reports (most booked flights, revenue, seat availability, etc.)

## Technologies Used
- **Backend**: Java Servlet, JSP, Java EE
- **Database**: MySQL (3NF Normalized)
- **Frontend**: JSP + CSS (Flexbox + Media Queries) – No Bootstrap
- **Server**: Apache Tomcat
- **Architecture**: MVC + Service + Util packages
- **Security**: Session Management, Auth Filter, Password Hashing

## Team Members
| No | Name                    | 
|----|-------------------------|
| 1  | Kritagya Kumar Manandhar| 
| 2  | Sujal Kumar Pariyar     | 
| 3  | Sujal Tiwari            | 
| 4  | Binod Tamang            | 
| 5  | Prajesh Thapa           | 
| 6  | Aditya Ale Magar        |

## Project Structure
AeroManage-Airline-System/
AeroManage-Airline-System/
├── src/                                      # All Java code (MVC)
│   └── com/aeromanage/
│       ├── model/                            # POJOs (Beans)
│       ├── dao/                              # Data Access Object (JDBC)
│       ├── service/                          # Business Logic
│       ├── controller/                       # Servlets (Controllers)
│       ├── util/                             # Helpers (DBConnection, Validation, PasswordUtil)
│       └── filter/                           # AuthFilter.java
├── WebContent/                               # Web resources
│   ├── css/                                  # style.css (Flexbox + Media Queries)
│   ├── jsp/                                  # All JSP pages
│   │   ├── admin/
│   │   ├── passenger/
│   │   ├── login.jsp
│   │   ├── register.jsp
│   │   ├── error.jsp
│   │   └── about.jsp
│   ├── WEB-INF/
│   │   └── web.xml                           # (optional for servlet mappings)
│   └── images/                               # (if needed)
├── database/
│   ├── schema.sql
│   └── sample-data.sql
├── README.md
└── .gitignore
