
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ecovizR

<!-- badges: start -->

<!-- badges: end -->

El objetivo de este paquete es facilitar el acceso a los datos públicos
mediante R, ayudando a que las personas de habla hispana tengan ejemplos
divertidos para aprender sobre programación. A su vez, se busca fomentar
el uso de la bicicleta, al hacer más accesible cualquier análisis sobre
un sistema de bicicletas compartidas.

Todos los datos se obtienen del sistema de bicicletas compartidas
[https://www.ecobici.cdmx.gob.mx](Ecobici) de la Ciudad de México.

## Instalación

Puedes instalar la versión más reciente del paquete instalando desde
github.

``` r
devtools::install_github("ecastillomon/ecovizR")
```

## Ejemplo

Para descargar los viajes movimientos de un mes, puedes usar la función
get\_trips(month, year) para descargar los datos de un mes para el
sistema de bicicletas compartidas de la ciudad de México.

``` r
library(ecovizR)

df_viajes=get_trips(11,2020)
#> Rows: 292,055
#> Columns: 9
#> Delimiter: ","
#> chr [5]: Genero_Usuario, Fecha_Retiro, Hora_Retiro, Fecha_Arribo, Hora_Arribo
#> dbl [4]: Edad_Usuario, Bici, Ciclo_Estacion_Retiro, Ciclo_Estacion_Arribo
#> 
#> Use `spec()` to retrieve the guessed column specification
#> Pass a specification to the `col_types` argument to quiet this message

dplyr::glimpse(df_viajes)
#> Rows: 292,052
#> Columns: 16
#> $ Genero_Usuario        <chr> "M", "M", "F", "F", "F", "M", "M", "M", "M", "M…
#> $ Edad_Usuario          <dbl> 48, 29, 43, 35, 27, 36, 55, 53, 45, 31, 54, 46,…
#> $ Bici                  <dbl> 9989, 6898, 11061, 11097, 10308, 8016, 11741, 1…
#> $ Ciclo_Estacion_Retiro <dbl> 140, 276, 60, 408, 379, 119, 61, 229, 63, 142, …
#> $ Fecha_Retiro          <date> 2020-10-31, 2020-11-01, 2020-11-01, 2020-11-01…
#> $ Hora_Retiro           <dttm> 2020-10-31 23:46:40, 2020-11-01 05:16:20, 2020…
#> $ Ciclo_Estacion_Arribo <dbl> 85, 424, 232, 96, 394, 192, 152, 198, 32, 319, …
#> $ Fecha_Arribo          <date> 2020-11-01, 2020-11-01, 2020-11-01, 2020-11-01…
#> $ Hora_Arribo           <dttm> 2020-11-01 00:03:35, 2020-11-01 05:38:13, 2020…
#> $ dia_semana_retiro     <chr> "sábado", "domingo", "domingo", "domingo", "dom…
#> $ dia_semana_arribo     <chr> "domingo", "domingo", "domingo", "domingo", "do…
#> $ horas_retiro          <int> 23, 5, 8, 8, 9, 9, 10, 10, 10, 10, 10, 11, 10, …
#> $ horas_arribo          <int> 0, 5, 9, 9, 9, 9, 10, 10, 10, 10, 10, 11, 11, 1…
#> $ periodo_retiro        <dttm> 2020-10-31 23:45:00, 2020-11-01 05:15:00, 2020…
#> $ periodo_arribo        <dttm> 2020-11-01 00:00:00, 2020-11-01 05:30:00, 2020…
#> $ mes_retiro            <dttm> 2020-10-01, 2020-11-01, 2020-11-01, 2020-11-01…
```

Para obtener un agregado por estación con el número de arribos y retiros
en intervalos de 15 minutos, junto con una suma acumulada de la última
hora, usa la función get\_daily\_counts

``` r
df_viajes_diarios=get_daily_counts(11,2020)
#> Rows: 292,055
#> Columns: 9
#> Delimiter: ","
#> chr [5]: Genero_Usuario, Fecha_Retiro, Hora_Retiro, Fecha_Arribo, Hora_Arribo
#> dbl [4]: Edad_Usuario, Bici, Ciclo_Estacion_Retiro, Ciclo_Estacion_Arribo
#> 
#> Use `spec()` to retrieve the guessed column specification
#> Pass a specification to the `col_types` argument to quiet this message
dplyr::glimpse(df_viajes_diarios)
#> Rows: 1,365,671
#> Columns: 12
#> $ estacion       <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
#> $ hora           <dttm> 2020-11-01 00:00:00, 2020-11-01 00:15:00, 2020-11-01 …
#> $ n_retiro       <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ n_arribo       <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ retiros_60_min <int> NA, NA, NA, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ arribos_60_min <int> NA, NA, NA, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ districtName   <chr> "Cuauhtémoc", "Cuauhtémoc", "Cuauhtémoc", "Cuauhtémoc"…
#> $ name           <chr> "1 RIO SENA-RIO BALSAS", "1 RIO SENA-RIO BALSAS", "1 R…
#> $ zipCode        <chr> "06500", "06500", "06500", "06500", "06500", "06500", …
#> $ location.lat   <dbl> 19.43357, 19.43357, 19.43357, 19.43357, 19.43357, 19.4…
#> $ location.lon   <dbl> -99.16781, -99.16781, -99.16781, -99.16781, -99.16781,…
#> $ capacity       <int> 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27…
```

Si quieres hacer llamadas a la API de Ecobici, puedes usar las funciones
update\_ecobici\_status, y update\_ecobici\_estaciones. Éstas harán
consultas en tiempo real.

``` r
df_disponibilidad=update_ecobici_status()

df_estaciones=update_ecobici_estaciones()

dplyr::glimpse(df_disponibilidad)
#> Rows: 480
#> Columns: 4
#> $ stationsStatus.id                 <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, …
#> $ stationsStatus.status             <chr> "OPN", "OPN", "OPN", "OPN", "OPN", …
#> $ stationsStatus.availability.bikes <int> 5, 9, 17, 7, 1, 14, 10, 6, 4, 9, 10…
#> $ stationsStatus.availability.slots <int> 21, 2, 18, 8, 10, 1, 13, 5, 20, 27,…
```

Para hacer más fácil la instalación se omite el paquete sf. El paquete
sf sirve para utilizar datos geoespaciales en R. Puedes ver una guía
para instalar sf si tienes problemas al hacerlo desde R.

<https://thinkr.fr/Installation_spatial_EN.html>

La función get\_daily\_counts\_sf traerá la misma información que
get\_daily\_counts pero regresará un objeto tipo sf. Esto facilita
graficarlo y luego hacer operaciones de cómputo geográfico sobre los
datos.

``` r

sf_viajes_diarios=get_daily_counts_sf(11,2020)


ggplot2::ggplot()+ggplot2::geom_sf(data=sf_viajes_diarios)
```

<img src="https://gitlab.com/est_092/ecobici-paper/-/raw/master/output/sf_example.png" alt="hi" class="inline"/>

Si tienes alguna sugerencia o contribución, escríbeme en:

  - Email: [est092@gmail.com](est092@gmail.com)

  - Github: [https://github.com/ecastillomon](ecastillomon)
