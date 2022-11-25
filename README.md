# README

## General Notes

1. Service provider's API is very limited which causes some problems in regards to an optimal sync process. There are no filtering options available in the Service Provider's API which means that we need to always fetch the whole data from them and filter the data on the response.
2. There is no way for our service to be informed of changes in the dataset, so everytime we want to ensure we have the closest to the most recent data, we will need to consume the whole API again.
3. Based on the previous points, the proposal is that we have an general sync process that runs asynchronously from our API and fetches the latest data from the Service Providers.
4. Because we'll be keeping a version of the hotel information in our servers, when hitting our API we will only consume the data that we have synced. This may mean that we won't always have the latest version of hotel information, but will ensure higher availability of data.

## Syncing logic

1. We have the different service provider's integrations services that are responsible for:
  1. Fetching the data from the API
  2. Standardizing the stored information, parsing the different raw data attribute names into a standard naming convention for our service
  3. Trigger the re-evaluation of the merged/deleted hotel information.
2. Each service provider raw data will be stored standardized in our db
3. When a new hotel's raw data is entered in the database, this will trigger the creation of a new final hotel record, with the merging logic being executed.
4. When an existing hotel's raw data is updated, this will also trigger the merging logic being executed.
5. Our final hotel data will be generated and stored in a separate table ready for API consumption. This will allow us to easily review/improve our merging logic.
6. Our final hotel data will have a "last_generated_at" attribute that will allow us to know when was the data last calculated.

### Current proposed solution challenges

1. Data deletion with the existing API will be sub-optimal. The way to get it done will be keep track of all found hotel identifiers in the APIs and look for all the hotel raw data records that have not been found in the last API sync. For those that have not been found, delete the raw data record.
  1. Once a deletion in the raw data table happens, trigger the merging logic for those identifiers. If no raw data is found, then delete the final hotel record. If some raw data is found (because the hotel info could have been removed only from one of the providers) then run the merging logic.

## Data merging logic

TODO
