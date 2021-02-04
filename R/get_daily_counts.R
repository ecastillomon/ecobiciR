#' get_daily_counts
#' Obtiene cuentas de retiros y arribos por estación, además de sumas en ventanas de los últimos 60 minutos de cada una
#' Los últimos 60 minutos representan que tan concurrida ha sido esta estación recientemente.
#' La función está vectorizada y buscará todas las combinaciones month y year requeridas
#' Solo buscar meses que se requieran ya que puede llegar a ser muy intensiva en RAM.
#' @param month mes o vector de meses requeridos
#' @param year mes o vector de meses requeridos
#'
#' @return
#' @export
#' @import dplyr
#' @importFrom rlang .data
#' @importFrom zoo rollsum
#' @importFrom lubridate ceiling_date
#' @importFrom lubridate floor_date
#' @examples
#' get_daily_counts(9,2019)
get_daily_counts=function(month=NULL,year=NULL){
  df_viajes=get_trips(month,year)
  pad_estacion=expand.grid(hora=seq(from=mean(df_viajes$Hora_Retiro) %>% lubridate::floor_date(unit="months"),
                                    to=mean(df_viajes$Hora_Arribo)%>% lubridate::ceiling_date(unit="months"),by="15 mins"),estacion=unique(df_viajes$Ciclo_Estacion_Retiro))

  df_estaciones_viajes=df_viajes %>%
    group_by(estacion=Ciclo_Estacion_Retiro,hora=periodo_retiro) %>%
    summarise(n_retiro=n()) %>%
    full_join(pad_estacion,by=c("estacion","hora")) %>%
    bind_rows({    df_viajes %>%
        group_by(estacion=Ciclo_Estacion_Arribo,hora=periodo_arribo) %>%
        summarise(n_arribo=n())   }) %>%
    group_by(estacion,hora) %>%
    summarise(n_retiro=sum(n_retiro, na.rm = TRUE), n_arribo=sum(n_arribo, na.rm = TRUE)) %>%
    ungroup() %>%
    arrange(estacion, hora) %>%
    group_by(estacion) %>%
    mutate(retiros_60_min=zoo::rollsum(n_retiro,k=4,fill = NA,align = "right"), arribos_60_min=zoo::rollsum(n_arribo,k=4,fill = NA,align = "right")) %>%
    ungroup() %>%
    left_join(df_estaciones %>% select(id, districtName, name,zipCode,location.lat,location.lon,capacity), by=c("estacion"="id"))
  return(df_estaciones_viajes)
}
