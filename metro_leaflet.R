
#Ubicación de líneas y estaciones del Sistema de Transporte Colectivo Metro

#Geolocalización de líneas y estaciones del Sistema de Transporte Colectivo Metro

#creado en  R version 3.5.2 (10-04-2022)

setwd("/Escirbir/tu/ruta/de Trabajo/")
getwd()

rm(list=ls())

library(rgdal)## PAra cargar archivos shape
library(leaflet)## Para generar mapas
library(tmap)

require(pacman)
p_load(leaflet,leaflet.extras,mapview,questionr,janitor,leafem,rgdal,raster,plyr,dplyr,
       data.table,readr, tidyverse,htmltools,htmlwidgets,mapview,sp,sf,readxl)

lineas <- readOGR("/Escirbir/tu/ruta/de Trabajo/STC_Metro_lineas_utm14n.shp")

names(lineas)
unique(lineas@data)
head(lineas[1,])


estaciones <- readOGR("/Escirbir/tu/ruta/de Trabajo/STC_Metro_estaciones_utm14n.shp")

names(estaciones)
tail(estaciones)

cdmx <- readOGR("/Escirbir/tu/ruta/de Trabajo/alcaldias.shp")##Poligonos de la cdmx

names(cdmx)
head(cdmx)


#Transformamos las coordenadas

lineas<-spTransform(lineas,CRS("+proj=longlat +datum=WGS84"))
estaciones<-spTransform(estaciones,CRS("+proj=longlat +datum=WGS84"))
cdmx<-spTransform(cdmx,CRS("+proj=longlat +datum=WGS84"))


##Preparación de datos---------------------------------------------------------
unique(cdmx$nomgeo)##Muestra valores únicos del campo nomgeo
unique(estaciones$NOMBRE)##Muestra valores únicos del campo NOMBRE
unique(estaciones$ALCALDIAS)

##Quitamos tíldes y convertimos de minusculas a mayusculas
##Remplazamos registros
cdmx$nomgeo <- chartr(old = ("ÁÉÍÓÚáéíóú"), new = ("AEIOUaeiou"), toupper(cdmx$nomgeo) )
cdmx$nomgeo <- str_replace(cdmx$nomgeo,"LA MAGDALENA CONTRERAS","MAGDALENA CONTRERAS"  )
cdmx$nomgeo <- str_replace(cdmx$nomgeo,"CUAJIMALPA DE MORELOS","CUAJIMALPA"  )
colnames(cdmx@data)[1] <- "alcaldia"

#creamos etiquetas con html
labels<- sprintf("%s", cdmx$alcaldia ) %>% lapply(htmltools::HTML)

labels2<- sprintf("%s", estaciones$NOMBRE) %>% lapply(htmltools::HTML)

#Creamos título con html
tag.map.title <- tags$style(HTML(".leaflet-control.map-title{
                                 transform: translate(-50%,20%);
                                 position: fixed !important;
                                 left: 30%;
                                 text-align: center;
                                 padding-left: 8px; 
                                 padding-right: 8px; 
                                 background: rgba(255,255,255,0.75);
                                 font-weight: bold;
                                 font-size: 16px;
                                 color: black;
                                 font-family: arial
                                 }
                                 "))
title <- tags$div(
  tag.map.title, HTML(paste("Geolocalización de líneas y estaciones del Sistema de Transporte Colectivo Metro")) 
)  

# Sintaxis:
# <tag_html propiedad1 = 'propiedad'>Contenido dentro de una página</tag_htlm>

#agregamos imagen de la dirección url
html_legend<- "<img src='https://www.metro.cdmx.gob.mx/storage/app/uploads/public/60b/e5f/712/thumb_8202_640_360_0_0_crop.jpeg' width=180px height=100px>"


                   #1       #2     #3         #4       #5        #6       #7        #8       #9  
colorLinea<- c("#FF1493","blue","#EEDD82","#00FFFF","yellow","#FF0000","#FF7F00","#008B00","#8B4513","#A020F0","#C0FF3E","#CDAD00")

leaflet(cdmx)%>%
  addTiles()%>%
  addProviderTiles(providers$CartoDB.Positron)%>%  #Wikimedia
  addPolylines(data = lineas, color =colorLinea)%>% #lineas de metro
  addCircles(data=estaciones,color = "black",labels2 = ~NOMBRE )%>% 
  addPolygons(data=cdmx,
              weight = 0.5,  # Tamaño del contorno de la CDMX 
              opacity = 2,
              dashArray = "0.5",
              fillOpacity = 0.05, #Opacidad de CDMX
              color = "blue",
              #opciones al pasar el curso
              highlightOptions = highlightOptions(
                weight = 1,
                color = "#666",
                dashArray = 5, #contorno alcaldia
                fillOpacity = 0.1, #Opacidad cuando se ilumina 
                bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 3px"),
                textsize = "8px",
                direction = "up"))%>%
  #Etiqueta de información
  addControl(html = HTML("<p style='background-color:#088256; color:white; font-size:11px 
                         '>Fuente: Elaborado por jabpcomplex con Datos Abiertos de la CDMX </p>"),
             position = "bottomright")%>%
  addControl(html= title,position = "topright",className="map-title")%>%
  addControl(html = html_legend, layerId = "A", position = "bottomleft")


