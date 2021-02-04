
#' get_daily_counts_sf
#'
#' Igual a get_daily_counts pero regresa convertido a sf
#'
#'
#' @param month mes o vector de meses requeridos
#' @param year mes o vector de meses requeridos
#' @export
#' @return df dataframe con todos los viajes
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
