# SyncRide: Premium Lahore Ride-Sharing Platform
## Full Project Documentation

---

### 1. Executive Summary
**SyncRide** is a premium SaaS-based ride-sharing platform specifically engineered for the urban landscape of Lahore, Pakistan. The platform bridges the gap between individual commuters (university students and professionals) and popular ride-hailing services (Yango, Careem, Uber) by allowing users to form "SyncGroups." This synchronization enables cost-splitting, increased safety via verified profiles, and optimized route planning across key areas like DHA, Gulberg, and Bahria Town.

---

### 2. Core Features
#### 2.1 Rider Features
*   **Intelligent Auto-Matching**: Matches riders based on source, destination, and a flexible ±15 minute departure window.
*   **Cost-Splitting Algorithm**: Automatically calculates fare shares among group members.
*   **Favorite Routes**: Save frequent commutes (e.g., Home to FAST-NUCES) for one-click booking.
*   **Emergency Contacts & SOS**: Link trusted contacts who receive real-time location alerts during emergencies.
*   **Same-Gender Preferences**: Optional filters to ensure comfort and safety.

#### 2.2 Admin Features
*   **System Analytics Dashboard**: Real-time monitoring of active rides, revenue growth, and platform usage.
*   **User Management**: Full control over user accounts, including manual verification and account deletion.
*   **Driver Approvals**: Specialized interface for vetting driver credentials and vehicle inspections.
*   **Live Ride Monitor**: Visual overview of all ongoing rides across the city.

---

### 3. Technology Stack
*   **Frontend**: 
    *   HTML5 (Semantic Structure)
    *   Vanilla CSS3 (Premium Glassmorphism & Animated UI)
    *   JavaScript (ES6+, Fetch API for Real-time Data)
    *   Font Awesome 6 (Professional Vector Icons)
*   **Backend**:
    *   Node.js (Runtime Environment)
    *   Express.js (RESTful API Framework)
    *   Bcrypt (Secure Password Hashing)
    *   CORS & Cookie-Parser (Security & Session Management)
*   **Database**:
    *   MySQL 8.0+ (Relational Database)
    *   3rd Normal Form (3NF) Architecture

---

### 4. Database Architecture (3NF)
The database is designed with 12 interconnected tables to ensure zero data redundancy and maximum integrity.

#### 4.1 Key Tables:
1.  **Users**: Stores profiles, roles (Rider/Driver/Admin), and encrypted credentials.
2.  **Ride_Groups**: Central table for synchronized ride sessions.
3.  **Ride_Requests**: Tracks individual booking attempts before matching.
4.  **Group_Members**: Intersection table for many-to-many relationship between Users and Groups.
5.  **Locations**: Master table for geographic coordinates in Lahore.
6.  **Ride_Platforms**: Registry of supported external services (Uber, Yango, etc.).
7.  **Drivers & Vehicles**: Specialized data for verified service providers.
8.  **Payments & Reviews**: Financial tracking and quality assurance logs.
9.  **Emergency_Contacts**: Safety metadata for user protection.

---

### 5. API Reference (Core Endpoints)
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| POST | `/api/auth/register` | User onboarding with role assignment |
| POST | `/api/auth/login` | Secure session initiation |
| GET | `/api/rides/nearby` | Fetch active groups based on location |
| POST | `/api/rides/request` | Create a new ride request and auto-match |
| GET | `/api/rides/history` | Retrieve user-specific ride logs |
| GET | `/api/admin/stats` | Aggregated platform analytics (Admin only) |
| POST | `/api/utils/sos` | Trigger emergency alerts |

---

### 6. Installation & Execution
#### 6.1 Prerequisites
*   Node.js installed
*   MySQL Server running
*   Active Internet connection (for CDNs)

#### 6.2 Setup Steps
1.  **Database**: Run `database/syncRide.sql` in your MySQL Workbench.
2.  **Dependencies**: Run `npm install` in the root directory.
3.  **Environment**: Configure `.env` with DB credentials.
4.  **Launch**: Execute `RESTART_SERVER.bat` or run `node backend/server.js`.

---

### 7. Recent Enhancements (Phase 2)
*   **Premium Branding**: Integrated the SyncRide logo as a subtle background watermark in dashboards.
*   **Vector Iconography**: Replaced all basic emojis with professional Font Awesome 6 icons.
*   **Light Blue Theme**: Shifted the UI to a modern Sky Blue and Teal palette for better readability.
*   **Admin "Mahad"**: Added a secondary administrative account for specialized oversight.
*   **Security Patching**: Enforced Bcrypt hashing across all existing test accounts.

---

### 8. Project Credits
*   **Developed by**: SyncRide Engineering Team
*   **Version**: 1.0.0 (Stabilized)
*   **Deployment Status**: Local Dev (Ready for Staging)
