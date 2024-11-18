
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GitAI

<!-- badges: start -->
<!-- badges: end -->

The goal of GitAI is to derive knowledge about given GitHub and GitLab
repositories with the use of Large Language Models. Written in tidyverse
style it allows user to easily setup scope (repositories), content of
interest (files), LLMs with a prompt and process it.

## Installation

You can install the development version of `GitAI` from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("r-world-devs/GitAI")
```

## Example workflow

Basic workflow could look like:

``` r
library(GitAI)
# Set up project
my_project <- initialize_project("fascinating_project") |>
  set_github_repos(repos = c("r-world-devs/GitStats", "r-world-devs/GitAI", "openpharma/DataFakeR")) |>
  add_files(files = "README.md") |>
  set_llm() |>
  set_prompt("Write one-sentence summary for a project based on given input.")

# Get the results
results <- process_repos(my_project)
```
