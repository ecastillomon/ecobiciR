client_id="2138_3w6tbu07xco4ckc8ogsk8sc844cc4ws8sgo4g0ko0ooc0ogcgo"
client_secret = "51yi1ao3itk4kgck8gw4kcw0swsc0ks4k8s04k00scssgogk04"
#' update_ecobici_estaciones
#' Actualiza el índice de estaciones que se debe de consultar a la API de Ecobici
#'
#'
#' @param client_id
#' @param client_secret
#'
#' @return
#' @export
#'
#' @examples
update_ecobici_estaciones=function(){

  url=glue::glue("https://pubsbapi-latam.smartbike.com/oauth/v2/token?client_id={client_id}&client_secret={client_secret}&grant_type=client_credentials")
  data=jsonlite::fromJSON(url)
  access_token=data$access_token
  refresh_token=data$refresh_token
  df_disponibilidad=jsonlite::fromJSON(glue::glue("https://pubsbapi-latam.smartbike.com/api/v1/stations/status.json?access_token={access_token}")) %>%
    data.frame()%>% jsonlite::flatten()

  df_capacidades=df_disponibilidad %>%
    mutate(capacity=stationsStatus.availability.bikes+stationsStatus.availability.slots) %>%
    select(id=stationsStatus.id,capacity)

  df_estaciones=jsonlite::fromJSON(glue::glue("https://pubsbapi-latam.smartbike.com/api/v1/stations.json?access_token={access_token}")) %>%
    data.frame() %>% jsonlite::flatten() %>%
    rename_all(function(x)gsub("stations\\.","",x)) %>%
    left_join(df_capacidades,by=c("id")) %>%
    mutate(coordenadas=paste0(`location.lat`,",",`location.lon`),
           longitud=location.lon,
           latitud=location.lat,
           estacion=id)
  # df_estaciones<<-df_estaciones
  return(df_estaciones)

}


#' update_ecobici_status
#' Actualiza dos dataframes que se deben de consultar a la API de Ecobici,
#' el índice de estaciones
#'
#' @param client_id
#' @param client_secret
#'
#' @return
#' @export
#'
#' @examples
update_ecobici_status=function(){

  url=glue::glue("https://pubsbapi-latam.smartbike.com/oauth/v2/token?client_id={client_id}&client_secret={client_secret}&grant_type=client_credentials")
  data=jsonlite::fromJSON(url)
  access_token=data$access_token
  refresh_token=data$refresh_token
  df_disponibilidad=jsonlite::fromJSON(glue::glue("https://pubsbapi-latam.smartbike.com/api/v1/stations/status.json?access_token={access_token}")) %>%
    data.frame()%>% jsonlite::flatten()
  # df_disponibilidad<<-df_disponibilidad
  return(df_disponibilidad)

}
