# Performance Notes

## Overview

The goal was to keep the system simple, fast, and scalable enough for ~10,000 employees without overengineering.

Most optimizations are focused on:

* avoiding unnecessary data loading
* leveraging the database properly
* keeping API responses lightweight

---

## Database & Indexing

Indexes were added on fields that are frequently queried:

* `email` (unique)
* `country`
* `job_title`
* `(country, job_title)` composite index

This helps especially for insights APIs where filtering and grouping happen often.

---

## Query Strategy

All salary insights are computed using database-level queries instead of Ruby logic.

For example:

```ruby
Employee.where(country: country).average(:salary)
```

instead of looping over records in Ruby.

This avoids loading large datasets into memory and keeps things fast even as data grows.

---

## Pagination

Pagination is implemented for the employees listing endpoint.

This ensures:

* the API doesn’t return large payloads
* UI remains responsive
* performance stays consistent

---

## Filtering

Filtering (by country and job title) is done at the database level.

This reduces the dataset early and works well with indexes.

---

## Seeding (10,000 records)

Seeding uses bulk insert:

```ruby
Employee.insert_all(records)
```

instead of creating records one by one.

This makes a big difference — seeding completes much faster and avoids unnecessary DB overhead.

---

## Memory & Response Efficiency

* No unnecessary object loading
* Lightweight serializer (plain Ruby object)
* Minimal JSON response structure

---

## Trade-offs

Some optimizations were intentionally not added:

* Caching → not needed at this scale yet
* Background jobs → no async-heavy use case
* Complex query abstractions → kept queries readable

The idea was to keep things simple but correct.

---

## Future Improvements

If the system grows further:

* Add caching (e.g. Redis) for insights endpoints
* Introduce background jobs for heavy data operations
* Consider read replicas for analytics queries

---

## Summary

The system focuses on:

* correct use of the database
* clean and simple queries
* avoiding unnecessary complexity

This keeps it both performant and easy to maintain.
