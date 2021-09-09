library(magrittr)
library(lubridate)
library(htmltools)

#minimaze TT_lev.js
#https://developers.google.com/closure/compiler
jsDate <- file.info("./data-raw/TT_lev.js")$mtime %>% ymd_hms()
minDate <- file.info("./data-raw/TT_lev-min.js")$mtime %>% ymd_hms()
if (is.na(minDate) || jsDate > minDate){
  library(httr)
  cat("Minifying java scripts")
  js_file <- readLines("./data-raw/TT_lev.js") %>% paste0(collapse = "\n")
  minified <- POST(url = "https://closure-compiler.appspot.com/compile",
                   body = list(js_code = js_file,
                               compilation_level="SIMPLE_OPTIMIZATIONS",
                               output_info="compiled_code",
                               output_format="text"),
                   encode = "form",
                   content_type("application/x-www-form-urlencoded"))

  con <- file("./data-raw/TT_lev-min.js",open="w")
  writeLines(content(minified, as="text"), con)
  close(con)
}
rm(list=ls())


# read js files
kw<-tags$script(readLines("./data-raw/kolorWheel-min.js", warn = FALSE) %>% paste0(collapse = "") %>% HTML)
lev<-tags$script(readLines("./data-raw/TT_lev-min.js",warn = FALSE)%>% paste0(collapse = "") %>% HTML)

usethis::use_data(kw, overwrite = TRUE, internal = TRUE)
usethis::use_data(lev, overwrite = TRUE, internal = TRUE)
