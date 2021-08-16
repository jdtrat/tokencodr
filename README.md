# tokencodr

#### Easily encrypt and decrypt authentication tokens

<!-- badges: start -->

<!-- [![R-CMD-check](https://github.com/jdtrat/tokencodr/workflows/R-CMD-check/badge.svg)](https://github.com/jdtrat/tokencodr/actions) -->

<!-- badges: end -->

------------------------------------------------------------------------

<!-- <img src="https://jdtrat.com/project/tokencodr/featured-hex.png" width="328" height="378" align="right"/> -->

tokencodr provides functions to easily encrypt authentication files for both interactive and non-interactive usage using the [sodium package](https://github.com/jeroen/sodium).
It was inspired by [gargle](https://gargle.r-lib.org), and much of the code is directly adapted from the `secret_*` family of functions used by gargle internally. The methods employed follow this [vignette on securely managing tokens](https://gargle.r-lib.org/articles/articles/managing-tokens-securely.html).

> **DISCLAIMER:** I am not a security expert. The methods described in this package could potentially allow certain parties to access your authorization token(s) and, subsequently, your data. Use at your own risk.

## Table of contents

-   [Installation](#installation)
-   [Getting Started](#getting-started)
-   [Further Reading](#further-reading)
-   [Feedback](#feedback)
-   [Code of Conduct](#code-of-conduct)

------------------------------------------------------------------------

## Installation

You can install and load the development version of tokencodr from GitHub as follows:

```r
# Install the development version from GitHub
if (!require("remotes")) install.packages("remotes")
remotes::install_github("jdtrat/tokencodr")

# Load package
library(tokencodr)
```

## Getting Started

tokencodr has three functions:

| Function          | Description                                                                                                                                                                                                  | Example Use                              |
|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|
| `create_env_pw()` | This function accepts a 'service' argument, which would typically be a one-word description for the platform whose token you are attempting to encrypt.                                                      | `create_env_pw(service = "BOXREXAMPLE")` |
| `encrypt_token()` | Accepts the service specified in `create_env_pw()`, an input file, and the destination directory for where the encrypted file should be saved.                                                               |  `encrypt_token(service = "BOXREXAMPLE", input = "~/private/local/path/to/my/jwt/file.json", destination = "~/Desktop/")`                                        |
| `decrypt_token()` | Accepts the service name, path to encrypted token file, and a logical 'complete', indicating whether the file should be returned as raw bytes or as a character string with the decoded (original) contents. |`decrypt_token(service = "BOXREXAMPLE", path = "~/Desktop/.secret/BOXREXAMPLE", complete = TRUE)`                                          |

## Further Reading

For a more in-depth explanation of tokencodr, please see the [vignette](https://tokencodr.jdtrat.com/articles/tokencodr.html).

## Feedback

If you want to see a feature, or report a bug, please [file an issue](https://github.com/jdtrat/tokencodr/issues) or open a [pull-request](https://github.com/jdtrat/tokencodr/pulls)! As this package is just getting off the ground, we welcome all feedback and contributions. See our [contribution guidelines](https://github.com/jdtrat/tokencodr/blob/main/.github/CONTRIBUTING.md) for more details on getting involved!

## Code of Conduct

Please note that the tokencodr project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
