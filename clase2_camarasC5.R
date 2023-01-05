#creado por jabpcomplex en R version 4.2.2 (1-01-2023)

#agregamos ruta de trabajo
setwd("/ruta/general/")


#instale la libreria leaflet
install.packages("leaflet")

library(leaflet)

mapa <- leaflet() %>%
  addTiles() %>%  # Agregar capas de mapa predeterminados de OpenStreetMap
  addMarkers(lng=-99.1441192, lat=19.4357619, popup="Alameda central Ciudad de México")%>%
  setView(lng=-99.1441192, lat=19.4357619, zoom = 15)
mapa  # imprime el mapa


# agregamos algunas geolocalizaciones de camara instaladas por el C5 de la ciudad de mexico
#fuente: datos abiertos de la ciudad de mexico

camaras <- data.frame(
  lat = c(19.414059,19.413347,19.407144,19.422391,19.421935,19.423580,19.423402,19.429865,19.427597),
  lng = c(-99.146791,-99.146333,-99.138640,-99.127843,-99.153914,-99.136965,-99.134763,-99.143751,-99.150683))

camaras_popup = popup = c("MERCADO HIDALGO",
                          "MERCADO HIDALGO",
                          "ISABEL LA CATOLICA",
                          "JARDIN DEL INDIO",
                          "JARDIN DOCTOR IGNACIO CHAVEZ",
                          "PARQUE SAN SALVADOR EL VERDE",
                          "PLAZA TLAXCOAQUE",
                          "PLAZA SAN JUAN",
                          "PARQUE TOLSA")

camaras_map <- leaflet() %>%
            addTiles() %>%
            addMarkers(popup = camaras_popup, clusterOptions = markerClusterOptions())

