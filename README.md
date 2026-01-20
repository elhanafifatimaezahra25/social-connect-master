# 🌐 Social Connect

<div align="center">

![JavaFX](https://img.shields.io/badge/JavaFX-17-blue?style=for-the-badge&logo=java)
![MySQL](https://img.shields.io/badge/MySQL-MariaDB-orange?style=for-the-badge&logo=mariadb)
![Maven](https://img.shields.io/badge/Maven-Build-red?style=for-the-badge&logo=apache-maven)
![Nix](https://img.shields.io/badge/Nix-Reproducible-7ab?style=for-the-badge&logo=nixos)

**A modern, feature-rich social media platform built with JavaFX and MySQL**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Architecture](#-architecture) • [Contributing](#-contributing)

</div>

---

## ✨ Features

### 🔐 **Authentication & Security**
- Secure user registration and login system
- Password hashing with **BCrypt** (salt rounds 12)
- Session management across the application
- SQL injection prevention with prepared statements

### 📝 **Social Posting**
- Create and share posts (up to 500 characters)
- Chronological feed displaying all user posts
- Real-time engagement metrics
- Post timestamps with formatted display

### ❤️ **Engagement System**
- **Like/Unlike** posts with instant visual feedback
- **Comment** on posts with threaded discussions
- View comment history with usernames
- Real-time like and comment counts

### 👥 **Social Networking**
- **Follow/Unfollow** other users
- Track followers and following counts
- View follower and following lists
- Dynamic relationship status updates

### 👤 **User Profiles**
- Customizable user bios
- Profile statistics (posts, followers, following)
- View all posts from any user
- Edit your own profile information

### 🔍 **Discovery**
- Search users by username (partial matching)
- Quick profile access from search results
- Clickable usernames throughout the app

### 🎨 **Modern UI/UX**
- Beautiful gradient design (purple-blue theme)
- Card-based layouts for clean content separation
- Smooth hover effects and transitions
- Responsive design adapting to window sizes
- Glassmorphism and modern typography

---

## 📸 Screenshots

> *Screenshots coming soon! The application features:*
> - Clean login/registration screens with gradient backgrounds
> - Modern feed interface with post creation
> - Interactive user profiles with stats
> - Elegant comment dialogs
> - Smooth navigation and transitions

---

## 🚀 Installation

### Prerequisites

- **Nix Package Manager** ([Install Nix](https://nixos.org/download.html))
  - Provides Java 17, Maven, MariaDB, and all dependencies
  - Ensures reproducible builds across systems

### Quick Start

```bash
# Clone the repository
git clone https://github.com/NacreousDawn596/social-connect.git
cd social-connect

# Enter the development environment
# This automatically starts MariaDB and builds the project
nix-shell

# Inside nix-shell, launch the application
run
# or
mvn javafx:run
```

That's it! The database will initialize automatically on first run.

### Manual Setup (Without Nix)

<details>
<summary>Click to expand manual installation steps</summary>

**Requirements:**
- Java 17 or higher
- Maven 3.6+
- MySQL/MariaDB server

**Steps:**

1. **Install Java 17 and Maven**
   ```bash
   # Ubuntu/Debian
   sudo apt install openjdk-17-jdk maven
   
   # macOS (with Homebrew)
   brew install openjdk@17 maven
   ```

2. **Install and configure MariaDB**
   ```bash
   # Ubuntu/Debian
   sudo apt install mariadb-server
   sudo systemctl start mariadb
   
   # macOS
   brew install mariadb
   brew services start mariadb
   ```

3. **Create database and user**
   ```sql
   mysql -u root -p
   CREATE DATABASE testdb;
   CREATE USER 'kamal'@'localhost' IDENTIFIED BY 'password';
   GRANT ALL PRIVILEGES ON testdb.* TO 'kamal'@'localhost';
   FLUSH PRIVILEGES;
   ```

4. **Update database configuration**
   - Edit `src/app/DBConnection.java`
   - Set PORT to `3306` (default MySQL port)

5. **Build and run**
   ```bash
   mvn clean package
   mvn javafx:run
   ```

</details>

---

## 🏗️ Architecture

### Technology Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | JavaFX 17 (with FXML) |
| **Backend** | Java 17 |
| **Database** | MySQL/MariaDB 10.11 |
| **Build Tool** | Maven 3.6+ |
| **Security** | BCrypt Password Hashing |
| **Development** | Nix (reproducible builds) |

### Project Structure

```
social-connect/
├── pom.xml                          # Maven configuration
├── shell.nix                        # Nix development environment
└── src/
    ├── app/
    │   ├── Main.java                # Application entry point
    │   ├── DBConnection.java        # Database connection singleton
    │   │
    │   ├── models/                  # Data models (POJOs)
    │   │   ├── User.java
    │   │   ├── Post.java
    │   │   ├── Comment.java
    │   │   ├── Like.java
    │   │   └── Follow.java
    │   │
    │   ├── dao/                     # Data Access Objects
    │   │   ├── UserDAO.java
    │   │   ├── PostDAO.java
    │   │   ├── CommentDAO.java
    │   │   ├── LikeDAO.java
    │   │   └── FollowDAO.java
    │   │
    │   ├── controllers/             # JavaFX Controllers
    │   │   ├── LoginController.java
    │   │   ├── RegisterController.java
    │   │   ├── FeedController.java
    │   │   └── ProfileController.java
    │   │
    │   ├── utils/                   # Utility classes
    │   │   ├── SessionManager.java  # User session management
    │   │   └── PasswordUtil.java    # BCrypt utilities
    │   │
    │   └── database/
    │       └── DatabaseInitializer.java  # Auto-create tables
    │
    └── resources/                   # FXML views and styles
        ├── login.fxml
        ├── register.fxml
        ├── feed.fxml
        ├── profile.fxml
        └── styles.css
```

### Database Schema

```sql
users
├── id (PK, AUTO_INCREMENT)
├── username (UNIQUE, INDEXED)
├── email (UNIQUE, INDEXED)
├── password_hash
├── bio
├── profile_picture
└── created_at

posts
├── id (PK, AUTO_INCREMENT)
├── user_id (FK → users.id, INDEXED)
├── content
├── image_url
├── like_count
├── comment_count
└── created_at (INDEXED)

comments
├── id (PK, AUTO_INCREMENT)
├── post_id (FK → posts.id, INDEXED)
├── user_id (FK → users.id)
├── content
└── created_at

likes
├── id (PK, AUTO_INCREMENT)
├── post_id (FK → posts.id, INDEXED)
├── user_id (FK → users.id, INDEXED)
├── created_at
└── UNIQUE(post_id, user_id)

follows
├── id (PK, AUTO_INCREMENT)
├── follower_id (FK → users.id, INDEXED)
├── following_id (FK → users.id, INDEXED)
├── created_at
└── UNIQUE(follower_id, following_id)
```

### Design Patterns

- **MVC (Model-View-Controller)**: Separation of concerns
- **DAO (Data Access Object)**: Database abstraction layer
- **Singleton**: Database connection and session management
- **Observer**: JavaFX event handling

---

## 🎯 Usage Guide

### Getting Started

1. **Create an Account**
   - Click "Sign Up" on the login screen
   - Enter username, email, and password
   - Automatically logged in after registration

2. **Explore the Feed**
   - View posts from all users
   - Create your own posts (up to 500 characters)
   - Like and comment on posts

3. **Build Your Network**
   - Search for users in the navigation bar
   - View user profiles
   - Follow users to build connections

4. **Customize Your Profile**
   - Click "Profile" button
   - Edit your bio
   - View your statistics and posts

### Navigation

- **Feed**: Main timeline showing all posts
- **Profile**: Your profile or other users' profiles
- **Search**: Find users by username
- **Logout**: Sign out of your account

---

## 🛠️ Development

### Available Commands

```bash
# Inside nix-shell
run                   # Quick launch (convenience command)
mvn javafx:run        # Launch application
mvn clean package     # Rebuild project
mvn test              # Run tests (if available)

# Database access
mysql -h 127.0.0.1 -P 3307 -u kamal -p  # Password: password

# Exit environment (stops MariaDB)
exit
```

### Configuration

Database settings are in `src/app/DBConnection.java`:

```java
private static final String HOST = "127.0.0.1";
private static final int PORT = 3307;  // 3306 for standard MySQL
private static final String DB_NAME = "testdb";
private static final String USER = "kamal";
private static final String PASSWORD = "password";
```

---

## 🤝 Contributing

Contributions are welcome! Here are some ideas for enhancements:

### Proposed Features

- [ ] **Direct Messaging**: Private messages between users
- [ ] **Notifications**: Alert system for new followers/likes/comments
- [ ] **Image Uploads**: Attach images to posts
- [ ] **Profile Pictures**: Custom user avatars
- [ ] **Feed Filters**: Show only posts from followed users
- [ ] **Post Editing/Deletion**: Manage your own posts
- [ ] **Hashtags**: Tag and discover posts by topics
- [ ] **User Mentions**: Tag users with @username
- [ ] **Dark Mode**: Theme toggle
- [ ] **Infinite Scroll**: Pagination for large feeds
- [ ] **Email Verification**: Secure account creation
- [ ] **Password Reset**: Forgot password functionality

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **JavaFX** for the powerful UI framework
- **MariaDB** for the reliable database system
- **Nix** for reproducible development environments
- **BCrypt** for secure password hashing
- **Maven** for dependency management

---

## 📧 Contact

**Project Link**: [https://github.com/NacreousDawn596/social-connect](https://github.com/NacreousDawn596/social-connect)

---

<div align="center">

**Made with ❤️ using JavaFX**

⭐ Star this repo if you found it helpful!

</div>
