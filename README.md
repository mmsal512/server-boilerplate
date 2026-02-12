# 🚀 Server Boilerplate

A production-ready Node.js server boilerplate built with **Express.js** and **MongoDB**, featuring authentication, file uploads, email services, and a clean modular architecture.

## 📋 Table of Contents

- [Features](#-features)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Environment Variables](#-environment-variables)
- [API Endpoints](#-api-endpoints)
- [Technologies Used](#-technologies-used)
- [Architecture](#-architecture)
- [Quick Start: Extend the Boilerplate](#-quick-start-extend-the-boilerplate)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

- 🔐 **Authentication & Authorization** — JWT-based auth with access & refresh tokens
- 👤 **User Management** — Registration, login, profile management
- 📧 **Email Service** — OTP verification & email notifications via Nodemailer
- 📁 **File Uploads** — Image/file upload support with Multer & Cloudinary
- 🛡️ **Security** — Password hashing with bcrypt, input validation with Joi
- 🍪 **Cookie Management** — Secure HTTP-only cookie handling
- 📊 **Database** — MongoDB with Mongoose ODM
- 🏗️ **Clean Architecture** — MVC pattern with modular folder structure
- ⚡ **Error Handling** — Centralized error handling middleware
- 🔄 **CORS** — Cross-Origin Resource Sharing configured

## 📂 Project Structure

server-boilerplate/
├── src/
│ ├── config/
│ │ └── db.js # MongoDB connection configuration
│ ├── controllers/
│ │ └── auth.controller.js # Authentication controller
│ ├── middlewares/
│ │ ├── auth.middleware.js # JWT authentication middleware
│ │ ├── multer.middleware.js # File upload middleware
│ │ └── validate.middleware.js # Request validation middleware
│ ├── models/
│ │ └── user.model.js # User Mongoose model
│ ├── routes/
│ │ └── auth.route.js # Authentication routes
│ ├── services/
│ │ ├── cloudinary.service.js # Cloudinary upload service
│ │ └── email.service.js # Email/OTP service
│ ├── utils/
│ │ ├── ApiError.js # Custom API error class
│ │ ├── ApiResponse.js # Standardized API response
│ │ ├── asyncHandler.js # Async error wrapper
│ │ ├── generateTokens.js # JWT token generation
│ │ └── helper.js # Helper/utility functions
│ ├── validations/
│ │ └── auth.validation.js # Auth input validation schemas
│ └── app.js # Express app setup
├── .env.example # Environment variables template
├── .gitignore
├── index.js # Server entry point
├── package.json
└── package-lock.json
