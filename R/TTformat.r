#' @title
#' Format table columns
#' @description
#' \code{\link[DT]{formatCurrency}}
#' @export
formatCurrency <- function (table, columns, currency = "$", interval = 3, mark = ",",
                            digits = 2, dec.mark = getOption("OutDec"), before = TRUE)
                  {
  columns <- columns +3
  DT::formatCurrency(table, columns, tplCurrency, currency, interval,
                mark, digits, dec.mark, before)
}

#' @title
#' Format table columns
#' @description
#' \code{\link[DT]{formatDate}}
#' @export
formatDate <- function (table, columns, method = "toDateString", params = NULL) {
  columns <- columns +3
  DT::formatDate(table, columns, method , params)
}

#' @title
#' Format table columns
#' @description
#' \code{\link[DT]{formatPercentage}}
#' @export
formatPercentage <- function (table, columns, digits = 0, interval = 3, mark = ",",
                              dec.mark = getOption("OutDec")) {
  columns <- columns +3
  DT::formatPercentage(table, columns, digits, interval, mark, dec.mark)
}

#' @title
#' Format table columns
#' @description
#' \code{\link[DT]{formatRound}}
#' @export
formatRound <- function(table, columns, digits = 2, interval = 3, mark = ",",
                         dec.mark = getOption("OutDec")){
  columns <- columns +3
  DT::formatRound(table, columns, digits, interval, mark, dec.mark)
}

#' @title
#' Format table columns
#' @description
#' \code{\link[DT]{formatSignif}}
#' @export
formatSignif <- function(table, columns, digits = 2, interval = 3, mark = ",",
                         dec.mark = getOption("OutDec")){
  columns <- columns +3
  DT::formatSignif(table, columns, digits, interval, mark, dec.mark)
}

#' @title
#' Format table columns
#' @description
#' \code{\link[DT]{formatString}}
#' @export
formatString <- function(table, columns, prefix = "", suffix = ""){
  columns <- columns +3
  DT::formatString(table, columns, prefix, suffix)
}

#' @title
#' Format table columns
#' @description
#' \code{\link[DT]{formatStyle}}
#' @export
formatStyle <- function(table, columns, valueColumns = columns, target = c("cell", "row"),
                        fontWeight = NULL, color = NULL, backgroundColor = NULL,
                        background = NULL, ...){
  columns <- columns +3
  valueColumns <- valueColumns +3
  DT::formatStyle(table, columns, valueColumns, target, fontWeight, color, backgroundColor, background, ...)
}
