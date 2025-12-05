# Set Large Language Model in `GitAI` object.

Set Large Language Model in `GitAI` object.

## Usage

``` r
set_llm(gitai, provider = "openai", ...)

get_llm_defaults(provider)
```

## Arguments

- gitai:

  A `GitAI` object.

- provider:

  Name of LLM provider, a string. Results with setting up LLM using
  `ellmer::chat_<provider>` function.

- ...:

  Other arguments to pass to corresponding `ellmer::chat_<provider>`
  function. Please use get_llm_defaults to get default model arguments.

## Value

A `GitAI` object.
