library(cli)
library(devtools)
library(usethis)

# may not be obvious: javascript file is in data-raw folder (./data-raw/lev.js)
# if edited, will be automatically minified during build.

#source data
source(file="./data-raw/org.r")
source(file="./data-raw/js.r")

devtools::document()

usethis::use_description(fields=list(
  LazyData=TRUE

))


