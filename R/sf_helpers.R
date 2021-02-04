
#' get_daily_counts_sf
#'
#' Igual a get_daily_counts pero regresa convertido a sf
#'
#'
#' @param month mes o vector de meses requeridos
#' @param year mes o vector de meses requeridos
#' @export
#' @return df dataframe con resumen por estaciones como sf
#' @import dplyr
#'
#' @examples
get_daily_counts_sf=function(month=NULL,year=NULL){
  if (!requireNamespace("sf", quietly = TRUE)) {
    print("sf package is needed, please install")
    break()
  }
  get_daily_counts(month=month,year=year)%>%filter(!is.na(districtName)) %>%
    sf::st_as_sf(coords = c("location.lon", "location.lat"), remove=F) %>%
    sf::st_set_crs(4326)
}

#' get_stations_sf
#'
#' Igual a update_ecobici_estaciones pero regresa convertido a sf
#'
#'
#' @export
#' @return sf dataframe con estaciones
#' @import dplyr
#'
#' @examples
get_stations_sf=function(){
  if (!requireNamespace("sf", quietly = TRUE)) {
    print("sf package is needed, please install")
    break()
  }
  update_ecobici_estaciones()%>%filter(!is.na(districtName)) %>%
    sf::st_as_sf(coords = c("location.lon", "location.lat"), remove=F) %>%
    sf::st_set_crs(4326)
}
