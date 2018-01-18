#' Get the physical flow from the statnett api.
#'
#' The function returns the datetime as UTC as default.
#'
#' @param from_date Class Date. From date.
#' @param date_as_cet Boolean. Default false. Return the date as CET or not.
#'
#' @export
#'
stat_primary_reserves_day <- function(local_date){

  if(!lubridate::is.Date(local_date)){
    stop("The from_date param is not of class date.")
  }

  data_url <- paste0("http://driftsdata.statnett.no/restapi/Reserves/PrimaryReservesPerDay?localDateTime=", local_date)

  data_request <- httr::GET(url = data_url, httr::user_agent("https://github.com/krose/statnettapi"))

  data_content <- httr::content(data_request, as = "text", encoding = "UTF-8")
  data_content <- jsonlite::fromJSON(data_content)

  description <-
    c("hour", "NO1-FNR-Price",	"NO1-FNR-Volume",	"NO1-FDR-Price",	"NO1-FDR-Volume",
      "NO2-FNR-Price","NO2-FNR-Volume", "NO2-FDR-Price", "NO2-FDR-Volume", "NO3-FNR-Price",
      "NO3-FNR-Volume", "NO3-FDR-Price", "NO3-FDR-Volume", "NO4-FNR-Price", "NO4-FNR-Volume",
      "NO4-FDR-Price", "NO4-FDR-Volume", "NO5-FNR-Price", "NO5-FNR-Volume", "NO5-FDR-Price", "NO5-FDR-Volume")

  colnames(data_content) <- description

  data_content <-
    tibble::as_tibble(data_content) %>%
    tidyr::gather(variable, value, -hour) %>%
    dplyr::mutate(local_date = local_date) %>%
    dplyr::select(local_date, hour, variable, value)

  data_content
}



