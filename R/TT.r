#' @title
#' Display tree structured data using datatable widget
#'
#' @description
#' Extension of datatable widget, allowing display of data.tree objects.
#' All arguments of the data.tree become columns and each node is a row.
#' Adds column with buttons allowing folding and unfolding the levels.
#'
#' @details
#' Package consist of treetable function that convert data.tree object to dataframe and JS function
#' called after creating the table that is responisble for some formating and folding/unfolding level rows.
#' Color formating is done by kolorWheel JS script done by Zalka Erno
#' e-mail: ern0@linkbroker.hu
#' <http://linkbroker.hu/stuff/kolorwheel.js/>
#'
#' @authors@R Michal Zielaskowski \email{michal.zielaskowski@gmail.com}
#' @references \url{https://github.com/zielaskowski/tree-table}
#'
#' @usage
#' treetable(data, color = "#FFFFFF", colnames = list(), ...)
#' @param data
#' data.tree object. \code{treetable} will extract all argumnets in alphabetical order - these will be a columns.
#' For renaming and ordering of the columnes see colnames.
#' @param color
#' base color (hue) to color the table. Each level will differ with saturation and luminosity.
#' @param colnames
#' if \code{list()} of characters provided, arguments of data.tree (columns) will be renamed.
#' If \code{vector()} provided, columns will be renamed as for list input, aditionally columns
#' will be reordered according to vector level after renaming.
#' @examples
#' data("org")
#' data("col_order")
#' colnames <- factor(c("org",org$attributesAll),
#'                    levels =  col_order)
#' treetable(org, color="#FFFFFF", colnames=colnames)
#' @seealso
#' \code{\link{DT}}
#' \code{\link{data.tree}}
#' @export
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#' @import data.tree


treetable <- function(data,
                      color='#FFFFFF',
                      options = list(), class = "display",
                      callback = htmlwidgets::JS("return table;"),
                      rownames = FALSE, colnames = list(), container,
                      caption = NULL, filter = "none",
                      escape = FALSE, style = "default",
                      width = NULL, height = NULL,
                      elementId = NULL,
                      fillContainer = getOption("DT.fillContainer", NULL),
                      autoHideNavigation = getOption("DT.autoHideNavigation", NULL),
                      selection = c("multiple", "single", "none"),
                      extensions = list(), plugins = NULL, editable = FALSE)
{
  #INPUT:
  #   data      data.tree object
  #   colnames  if missing, the c(node$name, node$attributesAll in alphbetical order) will be the column names;
  #             otherway the colnames will be used; if is.factor(colnames) will sort per levels
  #   color     base color (hue) to colorize the levels; defoult is white
  # First 3 columns are protected and hidden: TT_path, TT_button, TT_on_off,
  # warn about styling: some of options will be overridden

  tree2DF <- function(node){
    if(!(node$isLeaf)) TT_button <- "&oplus;"
    else TT_button <- "|&mdash;"

    atrs <- node$attributesAll
    atrVal <- c(purrr::map_chr(atrs, ~ node[[.x]]))

    db <- c(node$path %>% paste0(collapse = "/"),
            TT_button,
            node$level,
            node$name,
            atrVal)
    names(db) <- c("TT_path", "TT_button", "TT_on_off", "name",atrs)

    return(db)
  }

  # if data is not in data.tree format, return standard datatable
  dt <- tryCatch(data$isRoot,
                 warning = function(e){
                   warning("Provided data is not in data.tree format. Creating standard datatable.")
                   DT::datatable(data,
                             options = options, class = class,
                             callback = callback,
                             rownames = rownames, colnames = colnames,
                             container = container, caption = caption,
                             filter = filter,
                             escape = escape, style = style,
                             width = width, height = height,
                             elementId = elementId,
                             fillContainer = fillContainer,
                             autoHideNavigation = autoHideNavigation,
                             selection = selection,
                             extensions = extensions, plugins = plugins)
                 }
  )
  if(!is.logical(dt)) return(dt)

  #extract data.frame from data.tree
  dt_data <- data$Get(tree2DF)
  dt_data <- apply(dt_data,2,list) %>%
    purrr::map(~.x) %>%
    unlist(dt_data, recursive = FALSE) %>%
    dplyr::bind_rows()
  # initialize with only top level
  dt_data %<>% dplyr::mutate(TT_on_off=ifelse(TT_on_off!=1,0,1))


  # rownames always jump in as first so we need to shift by one
  if(rownames) shift <- 1
  else shift<-0

  # set width of button column based on max no of levels
  max_lev <- data$Get(function(node)node$level) %>% max()

  # arrange columns if collnames!=list()
  if(!missing(colnames))
  {
    dt_data %<>% dplyr::rename_with(function(x){
      c("TT_path","lev","TT_on_off", colnames %>% as.character())
    })
    dt_data %<>% dplyr::select("TT_path","lev","TT_on_off",all_of(colnames %>% sort()))
  }

  #warn when overriding options
  if(any(options$columnDefs %>% unlist() %>% names() %in% "orderable")){
    warning("option 'orderable' will be overwritten with FALSE", call. = FALSE)
  }
  if(escape) warning("option 'escape' will be overwritten with FALSE", call. = FALSE)
  if(callback[1] != "return table;") warning("option 'callback' not possible (yet)", call. = FALSE)
  #shift column options and protect classNames
  options$columnDefs %>% purrr::map(function(x){
    if(is.numeric(x$targets)) x$targets <- x$targets + 3
    if(!is.null(x$className) && x$className %in% c("button-col","path-col","onoff-col")) {
      warning(paste0("renamed protected className: ", x$className,". Renamed to X_", x$className), call. = FALSE)
    }
  })


  #hardcoded options
  escape = FALSE
  callback = htmlwidgets::JS("lev(table)")

  options$columnDefs <- c(options$columnDefs,list(
    list(className = 'button-col', targets = 1 +shift), #TT_button
    list(className = 'path-col', targets = 0 + shift), #TT_path
    list(className = 'onoff-col', targets= 2 + shift), #TT_on_off
    list(visible = FALSE, targets = 0 + shift), #TT_path
    list(visible = FALSE, targets= 2 + shift), #TT_on_off
    list(orderable = FALSE, targets = '_all'),
    list(width = paste0(max_lev*20,'px'),targets = 1 +shift)
  ))

  options$color <- color

  dt <- DT::datatable(dt_data,
                  options = options, class = class,
                  callback = callback,
                  rownames = rownames, colnames = colnames(dt_data),
                  container = container, caption = caption,
                  filter = filter,
                  escape = escape, style = style,
                  width = width, height = height,
                  elementId = elementId,
                  fillContainer = fillContainer,
                  autoHideNavigation = autoHideNavigation,
                  selection = selection,
                  extensions = extensions, plugins = plugins)

  ## add JS scripts####
  #scripts are in "sysdata.rda" as kw, lev
  #"sysdata.rda" is loaded silently and avilable...just like this
  #####################
  ###kolorWHEEL########
  #credits to:
  #Zalka Erno
  #e-mail: ern0@linkbroker.hu
  #http://linkbroker.hu/stuff/kolorwheel.js/

  dt <- htmlwidgets::appendContent(dt,kw,lev)

  return (dt)

}
