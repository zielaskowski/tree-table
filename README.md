
# TT

<!-- badges: start -->
<!-- badges: end -->

Extension of datatable widget, allowing display of data.tree objects.
All arguments of the data.tree become columns and each node is a row.
Adds column with buttons allowing folding and unfolding the levels.

![example](https://github.com/zielaskowski/tree-table/blob/master/dev/example.png?raw=true)

Package consist of treetable function that convert data.tree object to dataframe and JS function
called after creating the table that is responisble for some formating and folding/unfolding level rows.

Color formating is done by kolorWheel JS script done by Zalka Erno

e-mail: ern0@linkbroker.hu

<http://linkbroker.hu/stuff/kolorwheel.js/>

https://github.com/ern0/kolorwheel.js

## Installation

You can install the released version of TT from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("TT")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(TT)
## basic example code
data("org")
data("col_order")
colnames <- factor(c("org",org$attributesAll),
                    levels =  col_order)
treetable(org, color="#FFFFFF", colnames=colnames)
```

