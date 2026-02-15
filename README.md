# Automated Project Bootstrapping & Process Management

## Overview

This project demonstrates **Infrastructure as Code (IaC)** by automating the setup of a **Student Attendance Tracker** workspace using a shell script.  
The script creates the directory structure, generates necessary files, configures attendance thresholds, and handles interruptions safely.

---

## Repo Contents

- `setup_project.sh` – Master shell script that bootstraps the project  
- `attendance_checker.py` – Main Python logic (empty template)  
- `assets.csv` – Helper data file (empty template)  
- `config.json` – Configuration file with attendance thresholds (default values)  
- `reports.log` – Log file for attendance reports (empty template)  
- `README.md` – This file  

---

## How to Run

1. Make the script executable (first time only):

```bash
chmod +x setup_project.sh
