const { app } = require('@azure/functions');
const { BlobServiceClient } = require("@azure/storage-blob");
const { CosmosClient } = require("@azure/cosmos");

const COSMOS_CONNECTION = process.env.COSMOS_CONNECTION;
const COSMOS_DB = "BillingDB";
const COSMOS_CONTAINER = "Records";

const BLOB_CONNECTION = process.env.BLOB_CONNECTION;
const CONTAINER_NAME = "archived-records";

app.timer('ArchiveOldRecords', {
    schedule: '0 */2 * * * *', // runs every 2 minutes
    handler: async (myTimer, context) => {
        const timeStamp = new Date().toISOString();
        context.log('Timer function ran at:', timeStamp);

        const cosmos = new CosmosClient(COSMOS_CONNECTION);
        const container = cosmos.database(COSMOS_DB).container(COSMOS_CONTAINER);

        const blobService = BlobServiceClient.fromConnectionString(BLOB_CONNECTION);
        const blobContainer = blobService.getContainerClient(CONTAINER_NAME);

        const thresholdDate = new Date();
        thresholdDate.setMonth(thresholdDate.getMonth() - 3);

        const query = `SELECT * FROM c WHERE c.timestamp < '${thresholdDate.toISOString()}'`;
        const { resources } = await container.items.query(query).fetchAll();

        context.log(`Found ${resources.length} old records`);

        for (let record of resources) {
            const blobName = `${record.id}.json`;
            const blockBlobClient = blobContainer.getBlockBlobClient(blobName);
            await blockBlobClient.upload(JSON.stringify(record), Buffer.byteLength(JSON.stringify(record)));
            await container.item(record.id, record.id).delete();
            context.log(`Archived and deleted record ${record.id}`);
        }

        context.log('Archival completed.');
    }
});
