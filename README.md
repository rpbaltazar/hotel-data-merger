# README

## Setup and initial run

> rails db:setup

in rails console, run the sync service
> HotelSyncService.call

In the real world this would be managed by an asynchronous process. There are several optimizations that we could do on this logic but more investigation on the API for the service providers should be done.

start the server
> rails s

Query the API in localhost:3000/api/v1/hotels with the filter params

### Run in postman

[![Run in Postman](https://run.pstmn.io/button.svg)](https://god.gw.postman.com/run-collection/185195-09936412-4845-4f2a-b3dd-e0027d26182f?action=collection%2Ffork&collection-url=entityId%3D185195-09936412-4845-4f2a-b3dd-e0027d26182f%26entityType%3Dcollection%26workspaceId%3D72d1659d-fd6c-42a9-995a-4f56fc7f93fd)


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

The data merging depends on two earlier steps:
1. clean values
2. standardize values

The clean values removes all extra empty spaces for strings
The standardize values step transforms the raw data sent by the different service providers in a way that we can safely merge the data later

Regarding images, the raw data is all stored in the same data structure for the different service providers. This means that each service provider is responsible for mapping the external structure into our server's expected structure.
When generating the latest version for our hotel's data, we delete all images associated with that hotel and re-create the associations based on the latest raw data available. When creating images associated with a hotel, we only create records for
those images that do not yet exist for that room type.

For images, for example, this means we will transform the keys from the raw data service response into what our API is supposed to render later.

Regarding amenities, the assumption is that if the word is not found in the specific room type set, then it'll be considered as generic.
We are using [Damerau-Levenshtein](https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance) distance to determine if the words are close enough. If they are considered close enough then duplicate entries will not be added to the final hotel dataset.

For countries, I rely on iso_country_code gem to look for the country name and assure that the raw data will store only country names and not country codes

## Improvements to current solution

1. Images fetching
  - Currently we delete and recreate all images associated with the hotel every sync. We could look into reducing the number of DB writes to determine a diff of new images + images to be deleted.
  - The "merging" logic is purely based on the URL and room type, so the first image url for that room type to be found is the one to stay. If we have the same image url for the same room type from a different service provider, that will be ignored for our dataset
  - If the url is identified as two different room types by different service providers, we show the same image url as two different images one for each of the reported room types.

2. Data deletion - Currently there is no way for us to remove data from our server. It would be good to implement a sync logic that is able to remove stale data. With the currently provided APIs I can't think of a very clean way to achieve this unless we do a diff on all the ids.

3. Data sync - In a real world scenario, we would need to handle pagination for both parts

4. Assuming that the API behaviour will not change and that we have to always fetch the whole dataset, we should include a `last_seen_at` in the raw data records.
  - This would allow us to identify what raw records are stale.
  - Based on the last seen at, we could delete the hotel stale data. E.g. if there is no non-stale raw data, then our hotel is no longer relevant.
