
# mergen <img src="man/figures/mergen_logo.png" align="right" height="200" style="float:right; height:200px;"/>

<!-- README.md is generated from README.Rmd. Please edit that file -->

### Overview

mergen employs artificial intelligence to convert data analysis
questions into executable code, explanations, and algorithms. The
self-correction feature ensures the generated code is optimized for
performance and accuracy. mergen features a user-friendly chat
interface, enabling users to interact with the AI agent and extract
valuable insights from their data effortlessly.

### Installation

The easiest way to install mergen is via `install.packages`

``` r
install.packages("mergen")
```

#### Development version

To get a bug fix or to use a feature from the development version, you
can install the development version of mergen from GitHub.

``` r
# install.packages("pak")
pak::pak("BIMSBbioinfo/mergen")
```

### Prerequisites

- Make an AI account
- [Create an OpenAI API
  key](https://platform.openai.com/account/api-keys) to use with the
  package
- [Create a replicate API key](https://replicate.com/pricing)
- Set up the API key in R

#### Configuring your AI API key

To interact with an AI API, you require a valid AI API key. To configure
your key so that it is present globally in your environment at all
times, you can include it in your .Renviron file. This will ensure that
the key is automatically loaded.

For setting up mergen, this variable should be called `AI_API_KEY`. For
more information on setting up an agent, we recommend you visit **Get
Started** .

**Caution:** If you’re using version control systems like GitHub,
include .Renviron in your .gitignore file to prevent exposing your
personal API key.

Here is how to open your .Renviron file for modification in your
project:

``` r
require(usethis)

edit_r_environ(scope="project")
```

For a persistent loading of your API key, add the following line to your
.Renviron file replacing `"your_key"` with your key.

``` r
AI_API_KEY="your_key"
```

**NOTE:** After setting up your API key in the .Renviron file, either
restart the R session or run `readRenviron(".Renviron")` to apply the
changes.

If you however wish to set this variable only for a single session, you
can use the following command:

``` r
Sys.setenv(AI_API_KEY="your_key")
```

### Getting help

If you encounter a clear bug, please file an issue with a minimal
reproducible example on
[GitHub](https://github.com/BIMSBbioinfo/mergen). There you can also
post further questions.
