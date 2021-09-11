formatCurrency <- function (table, columns, currency = "$", interval = 3, mark = ",",
                            digits = 2, dec.mark = getOption("OutDec"), before = TRUE)
                  {
  columns <- columns +3
  DT::formatCurrency(table, columns, tplCurrency, currency, interval,
                mark, digits, dec.mark, before)
}

formatDate <- function (table, columns, method = "toDateString", params = NULL) {
  columns <- columns +3
  DT::formatDate(table, columns, method , params)
}

formatPercentage <- function (table, columns, digits = 0, interval = 3, mark = ",",
                              dec.mark = getOption("OutDec")) {
  columns <- columns +3
  DT::formatPercentage(table, columns, digits, interval, mark, dec.mark)
}

formarRound <- function(table, columns, digits = 2, interval = 3, mark = ",",
                         dec.mark = getOption("OutDec")){
  columns <- columns +3
  DT::formatRound(table, columns, digits, interval, mark, dec.mark)
}

formatSignif <- function(table, columns, digits = 2, interval = 3, mark = ",",
                         dec.mark = getOption("OutDec")){
  columns <- columns +3
  DT::formatSignif(table, columns, digits, interval, mark, dec.mark)
}

formatString <- function(table, columns, prefix = "", suffix = ""){
  columns <- columns +3
  DT::formatString(table, columns, prefix, suffix)
}

formatStyle <- function(table, columns, valueColumns = columns, target = c("cell", "row"),
                        fontWeight = NULL, color = NULL, backgroundColor = NULL,
                        background = NULL, ...){
  columns <- columns +3
  valueColumns <- valueColumns +3
  DT::formatStyle(table, columns, valueColumns, target, fontWeight, color, backgroundColor, background, ...)
}
