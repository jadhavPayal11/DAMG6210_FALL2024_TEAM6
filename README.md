# Insurance Claims Processing System

## Team Members:
1. Kashyab Murali (002751324)
2. Mansi Gondil (002304645)
3. Payal Jadhav (002790996)
4. Sushma Mangalampati (002259895)

## Project Overview:
This project focuses on developing an Insurance Claims Processing System aimed at improving the efficiency and accuracy of claims management in the insurance industry. The system automates claim submission, processing, and tracking, reducing manual intervention and associated errors.

## Project_3 Deliverables

### 1. Data Definition Language (DDL) Scripts
The DDL scripts are used to define and manage the database schema, including the creation of tables, constraints, indexes, and relationships.

- **Tables Created:**
  - INSURANCE_APPLICATION
  - POLICYHOLDER
  - AGENT
  - PROVIDER
  - ADDRESS
  - INSURANCE_TYPE
  - POLICY
  - CLAIM
  - PAYMENT

- **Constraints:**
  - Primary Keys (PK)
  - Foreign Keys (FK)
  - Unique Constraints
  - Check Constraints

### 2. Data Manipulation Language (DML) Scripts
The DML scripts are used for managing data within the database by inserting, updating, and deleting records.

- **Operations Performed:**
  - Insert data into tables
  - Update existing records
  - Delete unwanted records

### 3. Views
Views are created to provide specific data insights without exposing full table structures or data.

- **Created Views:**
  - Insurance_Application_Overview
  - Active_Policies_Summary
  - Pending_Claims_Overview
  - Monthly_Claims_Statistics
  - Policyholder_Claim_History
  - Policy_Expiration_Alert
  - Adjuster_Performance_Metrics
  - Payment_Processing_Queue

### 4. User Creation Scripts
User creation scripts manage database user accounts, providing secure and controlled access to the database.

- **Users Created:**
  - ICPS_ADMIN
  - ICPS_CORE
  - PROVIDEE
  - POLICY_HOLDER
  - MANAGER
  - ADJUSTER
  - SALESMAN

### 5. Grants
Grants control user permissions, ensuring each user has the appropriate level of access based on their role.

- **Permissions Granted:**
  - SELECT, INSERT, UPDATE for agents
  - SELECT for policyholders and providers
  - ALL privileges for the admin

## How to Run the Scripts

1. Open your SQL client and connect to the target database 
     1. AdminCreation.sql
     2. UserCreation.sql
     3. TableCreation.sql
     4. InsertRecords.sql
     5. Views.sql
     6. TableGrants.sql
