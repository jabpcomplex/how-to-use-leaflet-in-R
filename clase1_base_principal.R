#creado por jabpcomplex en  R version 4.2.2 (1-01-2023) 

#agregamos ruta de trabajo
setwd("/path/")


#instale la libreria leaflet
install.packages("leaflet")

#Esqueleto principal para crear mapas con leaflet
#1.- Cree un widget de mapa llamando a leaflet().
#2.- Agregue capas (es decir, características) al mapa mediante el uso de funciones de capa (por ejemplo, addTiles, addMarkers, addPolygons) para modificar el widget del mapa.
#3.- Repita el paso 2 según lo desee.
#4.- Imprima el widget de mapa para mostrarlo.


library(leaflet)

mapa <- leaflet() %>%
        addTiles() %>%  # Agregar capas de mapa predeterminados de OpenStreetMap
        addMarkers(lng=-99.1441192, lat=19.4357619, popup="Alameda central Ciudad de México")%>%
        setView(lng=-99.1441192, lat=19.4357619, zoom = 15)
mapa  # imprime el mapa



mapa2 <- leaflet() %>%
  addTiles() %>%  # Agregar capas de mapa predeterminados de OpenStreetMap
  addMarkers(lng=-99.1441192, lat=19.4357619, popup="Alameda central Ciudad de México")%>%
  setView(lng=-99.1441192, lat=19.4357619, zoom = 15)%>%
  #Podemos utilizar servicios de teselas de terceros. Ya hemos visto anteriormente el ejemplo de OpenStreetMap,
  #que es el que R utiliza por defecto, pero también tenemos otros disponibles.
  addProviderTiles(providers$Stamen.Toner)

mapa2  # imprime el mapa
