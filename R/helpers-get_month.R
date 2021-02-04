#' get_trips
#'
#' Descarga los viajes del sistema Ecobici de la CDMX para los meses deseados.
#' La función buscará todas las combinaciones month y year requeridas
#' Solo buscar meses que se requieran ya que puede llegar a ser muy intensiva en RAM.
#'
#'
#' @param month mes o vector de meses requeridos
#' @param year mes o vector de meses requeridos
#'
#' @return df dataframe con todos los viajes
#' @export
#' @import dplyr lubridate
#' @importFrom rlang .data
#' @importFrom zoo rollsum
#'
#' @examples
get_trips=function(month, year){
  df_combinations=expand.grid(year,month) %>% rename(year=1,month=2) %>%
    mutate(month=ifelse(nchar(.data$month)==1,paste0("0",.data$month),.data$month),
           url=glue::glue("https://www.ecobici.cdmx.gob.mx/sites/default/files/data/usages/{year}-{month}.csv")) %>%
    distinct()

  df=df_combinations %>% pull(.data$url) %>%
    purrr::map_dfr(function(x){
      vroom::vroom(x)
  })%>%filter(!is.na(Ciclo_Estacion_Retiro)) %>%
  mutate_at(c("Fecha_Retiro","Fecha_Arribo"),function(x)as.Date(x,"%d/%m/%Y")) %>%
  mutate_at(c("Hora_Retiro","Hora_Arribo"),function(x)hms::parse_hms(x)) %>%
  mutate(Hora_Retiro=paste0(.data$Fecha_Retiro," ",.data$Hora_Retiro) %>% as.POSIXct(),
         Hora_Arribo=paste0(.data$Fecha_Arribo," ",.data$Hora_Arribo)%>% as.POSIXct()) %>%
  mutate(dia_semana_retiro=weekdays(.data$Hora_Retiro),
         dia_semana_arribo=weekdays(.data$Hora_Arribo),
         horas_retiro=lubridate::hour(.data$Hora_Retiro),
         horas_arribo=lubridate::hour(.data$Hora_Arribo) ,
         periodo_retiro=lubridate::floor_date(.data$Hora_Retiro, unit="15 minutes"),
         periodo_arribo=lubridate::floor_date(.data$Hora_Arribo, unit="15 minutes"))  %>%
  mutate(dia_semana_retiro=weekdays(.data$Hora_Retiro),
         dia_semana_arribo=weekdays(.data$Hora_Arribo),
         horas_retiro=lubridate::hour(.data$Hora_Retiro),
         horas_arribo=lubridate::hour(.data$Hora_Arribo) ,
         mes_retiro=lubridate::floor_date(.data$Hora_Retiro, unit="month"))

  return(df)
}
