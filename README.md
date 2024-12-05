# Insurance Claims Processing System
# PPT Link: https://www.canva.com/design/DAGYYFScxOU/koFEoQrg5rt8TtGsst-A5w/edit
## Team Members:
1. Kashyab Murali (002751324)
2. Mansi Gondil (002304645)
3. Payal Jadhav (002790996)
4. Sushma Mangalampati (002259895)

## Project Overview:
This project focuses on developing an Insurance Claims Processing System aimed at improving the efficiency and accuracy of claims management in the insurance industry. The system automates claim submission, processing, and tracking, reducing manual intervention and associated errors.

## Project_4 Deliverables

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
  - PROVIDER
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

### 6. Triggers:
Claim Triggers
  AfterClaimApprovalTrigger.sql
    Logs changes and updates statuses after a claim is approved.

BeforeClaimInsertTrigger.sql
  Validates policies before allowing claims to be inserted.

PreventClaimDeletionTrigger.sql
  Prevents deletion of claims to ensure data integrity.

Notification Triggers
  NotifyAgentOnHighRiskTrigger.sql
    Alerts agents about high-risk claims.

NotifyCustomerOnClaimUpdateTrigger.sql
Notifies customers about changes in claim status.

Payment Triggers
CloseClaimAfterSettlementTrigger.sql
Closes claims automatically after payments are completed.

PaymentStatusUpdateTrigger.sql
Updates the payment status after processing.

ReimbursementCalculationTrigger.sql
Calculates reimbursement amounts based on claims and policies.

Policy Triggers
BeforePolicyInsertTrigger.sql
Ensures policy data integrity before insertion.

PolicyExpirationCheckTrigger.sql
Automatically updates policy status when expired.

### 7. Packages:
Application Management
Claim Management
Payment Management
PolicyHolder Management


## How to Run the Scripts

SQL Script Execution Sequence:
1. Run the AdminCreation.sql script by connecting to your database admin.
2. Run the UserCreation.sql by script connecting to ICPS_ADMIN that was created in Step1.
3. Run the TableCreation.sql script by connecting to ICPS_CORE that was created in Step2.
4. Run the SequenceCreation.sql script by connecting to ICPS_CORE.
5. Run the InsertRecords.sql script by connecting to ICPS_CORE.
6. Run the TablesGrants.sql by script connecting to ICPS_CORE.
7. Run all the Triggers and Packages by connecting to ICPS_CORE
8. Run the Views.sql script by connecting to ICPS_CORE to create views.
9. Run the ViewsGrants.sql  script by connecting to ICPS_CORE.
10. Run the Reports.sql as specific users

