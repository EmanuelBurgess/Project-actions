# Project-actions

# AWS EC2 Apache Deployment Pipeline via Terraform & Ansible

This repository automates the provisioning of AWS infrastructure using Terraform and seamlessly configures an Ubuntu EC2 host to run an Apache web server inside Docker utilizing Ansible. 

The architecture is built with continuous deployment workflows in mind, featuring a fully decoupled, secure remote S3 state backend.

---

## Architecture Overview

1. **Infrastructure as Code (Terraform):**
   * Dynamically generates a secure cryptographic TLS private key (`.pem`).
   * Configures an AWS EC2 instance using the latest official Ubuntu 22.04 AMI.
   * Restricts network access via an AWS Security Group targeting only **Port 22** (SSH Management) and **Port 80** (Public HTTP Web Traffic).
   * Automatically formats and outputs an Ansible-compliant local `hosts.ini` inventory configuration upon infrastructure completion.

2. **Configuration Management (Ansible & Docker):**
   * Establishes a secure SSH connection to the live EC2 node via the dynamically created private key.
   * Orchestrates system library preparation, updates packages, and installs the Docker runtime (`docker.io`).
   * Fetches the official **`httpd:2.4`** image from Docker Hub and launches a container mapping local host port 80 directly into the container stack.

---

## Prerequisites

Before executing the pipeline on your machine, ensure the following tools are installed:

* **macOS Terminal** with [Homebrew](https://brew.sh/)
* **Terraform** (`>= 1.0`)
* **Ansible** Core Engine
* **AWS CLI** (Configured locally with valid execution credentials via `aws configure`)

---

## Step-by-Step Deployment Guide

### 1. Initialize the Secure Remote Backend
To protect infrastructure blueprints and maintain repository secrecy, the S3 state bucket configuration is separated using a partial backend pattern. 

Create a local, non-tracked file named `backend.hcl` in the root directory:
```hcl
bucket         = "your-secret-unique-s3-bucket-name"
dynamodb_table = "your-secret-dynamodb-table-name" # Remove if not utilizing state-locking