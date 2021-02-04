sf_estaciones=get_stations_sf()


ggplot2::ggplot()+ggplot2::geom_sf(data=sf_estaciones)+ggsave("output/sf_example.png")
