Setup:

primary -> replica1 -> replica2

primary replicates to replica1 and replica1 replicates to replica2

```
# spin up containers one by one so that the primary is ready before the replica attempt to subscribe to it
docker-compose up -d primary && docker-compose up -d replica1 && docker-compose up -d replica2
```

# Tests all started with a subscription setup and working

## Adding columns:

### Add new column to primary and do nothing else. 

* Insert data
  * -> Subscription to replica1 fails.
* Add column to replica1
  * -> Subscription fixes itself and previous insert is replicated.
  * -> Subscription to replica2 starts failing
* Add column to replica2
  * -> Everything is fixed and data made it to replica2.


### Add new column (with default) to replica2 and do nothing else

* Insert data
  * -> Subscription keeps working and colum is just getting set to default value.

### Add new column (with default) to replica2 AND then replica1 and do nothing else

* Insert data
  * -> Subscriptions keep working and column is getting set to default value on replica1 and (assume) propagated as-is to replica2

### Add new column (with default) to replica2 AND then replica1 AND then primary and do nothing else

* Insert data
  * -> Everything works without any error.
  

### Conclusion
~~when adding new columns, start with the leaf replicas and add up to the primary. No need to refresh subscriptions.~~

Just add columns everywhere at once and subscriptions will fix themselves in time. No need to refresh subscriptions.

## Removing columns:

### Remove column from replica1 and do nothing else.
* No immediate error
* Insert data (leave "removed" column with default value in primary)
  * -> subscription to replica1 fails.
* Remove column from primary
  * -> subscription is still failing
* Add column back to replica1 to fix subscription.
  * -> subscription fixed.
* Drop column from replica1 again
* Insert data, no problem.
* Drop column from replica2. everything fine.


### Conclusion

When dropping columns, they need to be dropped from primaries first and replicas last. Might need to wait a few seconds to make sure replicas are up to date before dropping their columns


## REFRESH PUBLICATION?
Doesn't seem to be a need to run `REFRESH PUBLICATION` on the subscriptions to pick up schema changes within a table that is already replicated.