library(devtools)
library(usethis)

# for JS development use ./dev/dev.Rmd

# may not be obvious: javascript file is in data-raw folder (./data-raw/lev.js)
# if edited, will be automatically minified during build.

#source data
source(file="./data-raw/org.r")
source(file="./data-raw/js.r") # check!! it depends on external server which may be down


usethis::use_mit_license("Michal Zielaskowski")

devtools::document()

devtools::check()
