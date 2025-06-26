# Azure Billing Cost Optimizer 🚀

A serverless Azure solution to reduce storage costs for billing records by archiving records older than 3 months from Cosmos DB to Blob Storage using Azure Functions (Node.js).

---

## ✅ Problem Statement

We store billing records in Azure Cosmos DB. The system is read-heavy, but records older than 3 months are rarely accessed. This increases storage cost over time.

---

## ✅ Solution Overview

We built a solution using Azure’s **serverless** services:

- **Azure Cosmos DB**: Stores current billing records.
- **Azure Function (Node.js)**: Scheduled trigger to move old records.
- **Azure Blob Storage**: Cost-effective cold storage for archived records.
- **Azure Storage Account**: Manages access to blob containers.

The function automatically:

1. Reads records older than 3 months from Cosmos DB.
2. Archives them to Blob Storage as `.json` files.
3. Deletes them from Cosmos DB to reduce cost.

---

## 📦 Technologies Used

| Azure Service             | Purpose                        |
| ------------------------- | ------------------------------ |
| Cosmos DB                 | Active billing record storage  |
| Azure Functions (Node.js) | Logic to archive old records   |
| Blob Storage (StorageV2)  | Store archived records as JSON |
| Azure Timer Trigger       | Triggers function on schedule  |

---

## 🧾 Architecture Diagram

![Architecture Diagram](architecture.png)

---

## 📁 Project Structure

```
azure-billing-cost-optimizer/
│
├── function/
│   ├── index.js              # Core logic for archiving
│   └── function.json         # Timer trigger configuration
│
├── local.settings.json       # Dev environment variables
├── host.json                 # Azure Functions runtime settings
├── README.md                 # You're here!
```

---

## 🔐 Environment Configuration

Create a `local.settings.json` file:

```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "node",
    "COSMOS_CONNECTION": "<your_cosmos_db_connection_string>",
    "BLOB_CONNECTION": "<your_blob_storage_connection_string>"
  }
}
```

Get your keys from:

- **Cosmos DB** ➝ Keys ➝ Primary Connection String
- **Storage Account** ➝ Access keys ➝ Connection string

---

## 🚀 Running Locally

1. Clone the repo:

   ```bash
   git clone https://github.com/NabeelCraftsCode/azure-billing-cost-optimizer.git
   cd azure-billing-cost-optimizer
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Add your credentials to `local.settings.json`.

4. Run the function:
   ```bash
   func start
   ```

---

## ✅ What Happens

- Cosmos DB (Database: `BillingDB`, Container: `Records`) holds original records.
- Azure Function finds old records (`> 3 months`).
- It moves them to Blob Storage:
  - Storage Account: `billingcoldstorage`
  - Container: `archived-records`
  - Format: `sample1.json`, `sample2.json`, etc.
- Then deletes those records from Cosmos DB.

---

## 📌 Constraints Handled

- ✔️ **No downtime**: Cosmos DB and Function run independently.
- ✔️ **No data loss**: Records moved before deletion.
- ✔️ **No API change**: Read/write APIs to Cosmos DB remain unchanged.
- ✔️ **Scalable**: Runs with autoscale (max 400 RU/s or more).
- ✔️ **Secure**: Blob Storage is private by default.

---

## 🧪 Testing

- Upload test records to Cosmos DB via Data Explorer.
- Run function and verify:
  - Files appear in Blob container.
  - Data is removed from Cosmos DB.

---

## 📸 Screenshots

| Cosmos DB (Before)                        | Blob Storage (After)                                 |
| ----------------------------------------- | ---------------------------------------------------- |
| `sample1`, `sample2` in Records container | `sample1.json`, `sample2.json` in `archived-records` |

---

## 👨‍💻 Author

**Ahmad Nabeel**  
🔗 GitHub: [NabeelCraftsCode](https://github.com/NabeelCraftsCode)

---

## 💬 Questions?

Feel free to reach out for help or improvement suggestions.

---
