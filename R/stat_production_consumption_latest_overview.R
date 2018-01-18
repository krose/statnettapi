
#' Get the latest detailed overview statnett api.
#'
#' The function returns the datetime as UTC as default.
#'
#' @param date_as_cet Boolean. Default false. Return the date as CET or not.
#'
#' @importFrom dplyr %>%
#'
#' @export
#'
stat_production_consumption_latest_overview <- function(date_as_cet = FALSE, data_wide = FALSE){

  data_url <- "http://driftsdata.statnett.no/restapi/ProductionConsumption/GetLatestDetailedOverview"

  data_request <- httr::GET(url = data_url, httr::user_agent("https://github.com/krose/statnettapi"))

  data_content <- httr::content(data_request, as = "text", encoding = "UTF-8")
  data_content <- jsonlite::fromJSON(data_content)

  # Create the datetimeseq
  date_utc <- data_content$MeasuredAt / 1000
  date_utc <- lubridate::as_datetime(date_utc)

  if(date_as_cet){
    date_utc <- lubridate::with_tz(date_utc, tzone = "CET")
  }

  # drop measured at and headers
  data_content$MeasuredAt <- NULL
  data_content$Headers <- NULL

  data_content <- dplyr::bind_rows(data_content, .id = "variable")
  data_content$measured_at <- date_utc

  # clean up
  data_content <-
    data_content %>%
    dplyr::filter(!is.na(titleTranslationId)) %>%
    dplyr::mutate(varible = stringr::str_replace(variable, "Data", "")) %>%
    dplyr::mutate(titleTranslationId = stringr::str_replace(titleTranslationId, "Desc", ""),
                  # overvej en anden metode. extract country
                  country = as.character(NA),
                  country = dplyr::if_else(stringr::str_detect(titleTranslationId, "SE"), "SE", country),
                  country = dplyr::if_else(stringr::str_detect(titleTranslationId, "DK"), "DK", country),
                  country = dplyr::if_else(stringr::str_detect(titleTranslationId, "NO"), "NO", country),
                  country = dplyr::if_else(stringr::str_detect(titleTranslationId, "FI"), "FI", country),
                  country = dplyr::if_else(stringr::str_detect(titleTranslationId, "EE"), "EE", country),
                  country = dplyr::if_else(stringr::str_detect(titleTranslationId, "LT"), "LT", country),
                  country = dplyr::if_else(stringr::str_detect(titleTranslationId, "LV"), "LV", country),
                  country = dplyr::if_else(stringr::str_detect(titleTranslationId, "Total"), "Total", country)) %>%
    dplyr::select(measured_at, variable, country, value) %>%
    # fix values
    dplyr::mutate(value = stringr::str_replace_all(value, " ", "")) %>%
    dplyr::mutate(value = stringr::str_replace(value, "-", "")) %>%
    dplyr::mutate(value = suppressWarnings(as.integer(value))) %>%
    dplyr::filter(country != "Total")

  if(data_wide){
    data_content <-
      data_content %>%
      tidyr::spread(country, value)
  }

  data_content
}
