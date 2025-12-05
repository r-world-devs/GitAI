# Finding top K records in a vector database.

Finding top K records in a vector database.

## Usage

``` r
find_records(gitai, query, top_k = 1, verbose = is_verbose())
```

## Arguments

- gitai:

  A `GitAI` object.

- query:

  A character, user query.

- top_k:

  A numeric, number of top K records to return.

- verbose:

  A logical. If `FALSE` you won't be getting additional diagnostic
  messages.
