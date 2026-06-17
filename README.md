# SyncRide — Smart Time-Coordinated Multi-Platform Ride Sharing System

**SyncRide** is a professional, production-level full-stack ride-sharing coordination platform. It matches users having similar routes and overlapping time windows to form ride groups, simulating integration with external platforms (Yango, Careem, InDrive, Bykea).

---

## 🚀 1. Features & Architecture

- **Smart Ride Matching Logic**: Grouping based on time overlap (±15 mins) and source/destination similarity.
- **Full-Stack Application**: Vanilla HTML/CSS/JS frontend (Glassmorphism UI) with a Node.js/Express backend.
- **Robust Database Design**: 3NF Normalized MySQL database demonstrating advanced concepts (Joins, Subqueries, Constraints).
- **Oracle PL/SQL Implementation**: Comprehensive PL/SQL suite including explicit cursors, triggers, exceptions, functions, and stored procedures.
- **Security**: Bcrypt password hashing, express-session authentication, and SQL injection protection via parameterized queries.
- **Dynamic Dashboards**: Real-time analytics, user management, and live notifications.

---

## 🛠 2. Setup & Installation Instructions

### Step 1: Database Setup (MySQL)
1. Ensure your local **MySQL server** (e.g., via XAMPP) is installed and running.
2. Open your terminal or MySQL Workbench and run the provided SQL script to construct the schema and inject dynamic dummy data:
   ```bash
   mysql -u root -p < database/syncRide.sql
   ```
*(Note: If you are using XAMPP, you can also import `syncRide.sql` directly through phpMyAdmin).*

### Step 2: Application Setup
1. Ensure **Node.js** (v14+) is installed on your machine.
2. Navigate to the project root directory (`SyncRide`) in your terminal.
3. Install all required backend dependencies:
   ```bash
   npm install
   ```

### Step 3: Environment Configuration
1. Open the `backend/config/db.js` file.
2. Ensure your MySQL credentials match your local setup:
   - `user`: Typically `'root'`
   - `password`: Leave empty `''` if you have no password on localhost.

### Step 4: Running the Server
Start the production backend server by running:
```bash
npm start
```
You should see: `Server is running on http://localhost:3000` and `Successfully connected to MySQL Database.`

### Step 5: Access the Application
Open your web browser and navigate to:
```
http://localhost:3000
```

---

## 📂 3. Project Structure & Deliverables

This repository strictly adheres to a clean MVC architecture and contains all deliverables required for evaluation:

- `/frontend`: All HTML, CSS (Vanilla), and client-side JS. Features dark-mode glassmorphism and fully responsive UI.
  - `index.html`, `dashboard.html`, `admin.html`, `login.html`, `register.html`
- `/backend`: Node.js Express server.
  - `/controllers`: `authController.js`, `rideController.js` (Business logic & SQL queries)
  - `/routes`: RESTful API endpoints.
  - `/middleware`: Route protection (`isAuthenticated`, `isAdmin`).
- `/database`: 
  - `syncRide.sql`: Complete Database Schema & Seed Data.
  - `procedures.sql`: Oracle PL/SQL Stored Procedures, Functions, and Explicit Cursors.
  - `triggers.sql`: Oracle PL/SQL Triggers for data validation and automation.

---

## 🧪 4. Final Testing & Verification

Before deployment, the following systems have been stress-tested and verified:
✅ **Frontend**: Responsive UI, form validation, broken link checks, and DOM rendering.
✅ **Backend**: API routing, try/catch error handling, Node.js stability, and session persistence.
✅ **Database**: MySQL connectivity, connection pooling, foreign keys, and referential integrity.
✅ **Ride Matching**: The ±15 minute overlap algorithm correctly assigns users to existing groups or spawns new ones.
✅ **PL/SQL**: All functions compute correctly, explicit cursors iterate successfully, and triggers prevent invalid operations (like exceeding vehicle capacity).

**Admin Testing Credentials:**
- Email: `admin@syncride.com`
- Password: `admin`
