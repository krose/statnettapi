
#' Get the physical flow from the statnett api.
#'
#' The function returns the datetime as UTC as default.
#'
#' @param from_date Class Date. From date.
#' @param date_as_cet Boolean. Default false. Return the date as CET or not.
#'
#' @export
#'
stat_physical_flow <- function(from_date, date_as_cet = FALSE){

  if(!lubridate::is.Date(from_date)){
    stop("The from_date param is not of class date.")
  }

  data_url <- paste0("http://driftsdata.statnett.no/restapi/Physicalflow/GetData?From=", from_date)

  data_request <- httr::GET(url = data_url, httr::user_agent("https://github.com/krose/statnettapi"))

  data_content <- httr::content(data_request, as = "text", encoding = "UTF-8")
  data_content <- jsonlite::fromJSON(data_content)

  # Create the datetimeseq
  date_utc <- seq(from = data_content$StartPointUTC,
                  to = data_content$EndPointUTC,
                  by = data_content$PeriodTickMs) / 1000

  date_utc <- lubridate::as_datetime(date_utc)

  if(date_as_cet){
    date_utc <- lubridate::with_tz(date_utc, tzone = "CET")
  }

  #
  tibble::tibble(date = date_utc,
                 physical_flow_net_exchange = data_content$PhysicalFlowNetExchange)
}
