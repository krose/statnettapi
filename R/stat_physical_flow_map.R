#' Get the physical flow map data from the statnett api.
#'
#' The function returns the datetime as UTC as default.
#'
#' @param date_as_cet Boolean. Default false. Return the date as CET or not.
#'
#' @export
#'
stat_physical_flow_map <- function(date_as_cet = FALSE){
  
  data_url <- "http://driftsdata.statnett.no/restapi/PhysicalFlowMap/GetFlow"
  
  data_request <- httr::GET(url = data_url, httr::user_agent("https://github.com/krose/statnettapi"))
  data_content <- httr::content(data_request, as = "text", 
                                encoding = "UTF-8")
  data_content <- jsonlite::fromJSON(data_content)
  
  data_content[, 4] <- lubridate::as_datetime(data_content[, 4]/1000)
  
  if (date_as_cet) {
    data_content[, 4] <- lubridate::with_tz(data_content[, 4], tzone = "CET")
  }
  
  return(data_content)
  
}