
#LIBRERIAS--------
rm(list = ls())
library(readxl)
library(cleangeo)
library(deldir)
library(dplyr)
library(foreign)
library(ggmap) 
library(ggplot2) 
library(htmltools)
library(htmlwidgets)
library(leaflet)
library(leaflet.extras)
library(mapproj)
library(maptools)
library(mapview)
library(raster)
library(readr)
library(rgdal)
library(spatstat) 
library(sp) 
library(tidyr)
library(webshot)
library(graphics)
library(leafem)

setwd("C:/Users/jbautistap/Documents/ArchivosC5/R/productos html/xotepingo/")

########################################################################################
#cargamos los poligonos para colonias y sectores
colRel <- spTransform(shapefile("COL_EL RELOJ.shp"), "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
secXote <- spTransform(shapefile("SECTOR_XOTEPINGO.shp"), "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
#shpf <- readOGR("SECTOR_XOTEPINGO.shp",verbose=FALSE,use_iconv = TRUE, encoding = "UTF-8") # encoding="latin1", use_iconv=FALSE)

# base con las camaras STV (Sistemas Tecnologicos de Videovigilancia)
camaras <- read_excel("SECTOR XOTEPINGO_COL_EL RELOJ.xlsx")


########################################################
#     Exploramos los datos
unique(camaras$TIPO_POSTE)
unique(camaras$ALCALDÍA)#SE REPITE GUSTAVO A MADERO ***ELIMINAR***
unique(camaras$CLASIFICACION)

########################################################
#FILTRADO DE BASE DE DATOS
#Filtramos el dataframe con los STV de 9m
cam9<-camaras[camaras$TIPO_POSTE=="9m",]
#Filtramos el dataframe con los STV de 9m
cam20<-camaras[camaras$TIPO_POSTE=="20m",]
#Filtramos los TOTEMS
totem<-camaras[camaras$TIPO_POSTE=="TOTEM",]
totemF2<-camaras[camaras$TIPO_POSTE=="TOTEM_FASE2",]
totem<-rbind(totem,totemF2)


################################################################################################################
####                 COMIENZA LA CREACION DE MAPA                                                           ####
################################################################################################################

tag.map.title <- tags$style(HTML("
    .leaflet-control.map-title { 
    transform: translate(-50%,20%);
   position: fixed !important;
    left: 50%;
    text-align: center;
    padding-left: 10px; 
    padding-right: 10px; 
    background: TRANSPARENT;
    font-weight: bold;
    font-size: 25px;
    color: #9F2241
    }"))

######################################################################################
#TITULO-------------------------
title <- tags$div(
  tag.map.title, HTML(paste("Camaras en Coyoacán (Xotepingo)"))
)

######################################################################################
#imagen
imagen1<-iconList(city=makeIcon(iconUrl = "https://i.ibb.co/7131jWL/logo-reducido.png"))

######################################################################################
#Etiquetas personalizadas
map <- c("#1F77B4","#FF7F0E","#2CA02C")#,"#D62728","#9467BD","#8C564B","#358000","#17BECF")
colors <- c("#7F7F7F","#17BECF","red","blue","#358000")
# Calculamos la dimensión para las etiquetas
labels <- c("SECTORES","COLONIAS",
            paste("9m","(",nrow(cam9),")"),
            paste("20m","(",nrow(cam20),")"),
            paste("TÓTEMS","(",nrow(totem),")"))

sizes <- c(10,10,10,10,10)
shapes <- c("square","square","circle","circle","circle")
borders <- c("#7F7F7F","#17BECF","red","blue","#358000")

####
#Funcion para crear etiquetas
addLegendCustom <- function(map, colors, labels, sizes, shapes, borders, opacity = 0.5){
  
  make_shapes <- function(colors, sizes, borders, shapes) {
    shapes <- gsub("circle", "50%", shapes)
    shapes <- gsub("square", "0%", shapes)
    paste0(colors, "; width:", sizes, "px; height:", sizes, "px; border:3px solid ", borders, "; border-radius:", shapes)
  }
  make_labels <- function(sizes, labels) {
    paste0("<div style='display: inline-block;height: ", 
           sizes, "px;margin-top: 4px;line-height: ", 
           sizes, "px;'>", labels, "</div>")
  }
  
  legend_colors <- make_shapes(colors, sizes, borders, shapes)
  legend_labels <- make_labels(sizes, labels)
  
  return(addLegend(map, colors = legend_colors, labels = legend_labels, opacity = opacity,position = "bottomleft"))
}
###





################################################################################################################
####                 #GENERAMOS MAPA CON LEAFLET                                                           ####
################################################################################################################

leaflet()  %>%addTiles() %>%addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
  # addProviderTiles(providers$OpenStreetMap.Mapnik) %>%
  
  addFullscreenControl()%>%clearBounds()%>%
  addControl(title,position = "topleft",className="map-title")%>%
  #  addControl(rr,position = "bottomleft")%>% #TABLA DE DATOS
  leafem::addMouseCoordinates() %>% addFullscreenControl(position = "topleft", pseudoFullscreen = F) %>%
  leafem::addLogo(img=imagen1$city,src="remote",position="bottomright",width=403,height=127)%>%
  #  addDrawToolbar(editOptions = editToolbarOptions(selectedPathOptions()),polylineOptions = drawPolylineOptions(metric = T),
  #                circleOptions = F,rectangleOptions = F,circleMarkerOptions = F) %>%
  addResetMapButton()%>%
  setView(lng = mean(camaras$LONGITUD),lat = mean(camaras$LATITUD),zoom = 13) %>%
  
  addMapPane("polygons",zIndex = 500)%>%
  addMapPane("ce",zIndex = 510)%>%
  addMapPane("li",zIndex=570)%>%
  #addMapPane("col",zIndex = 550)%>%
  addMapPane("lo",zIndex = 580)%>%
  
  addPolygons(data=secXote ,color = "#7F7F7F",fillColor = "transparent",fillOpacity =0.005,weight = 3,popup = paste("<b>","SECTOR : ","</b>",secXote$SECTOR),
              labelOptions = labelOptions(noHide = T, textOnly = TRUE,direction = "center"),
              highlightOptions = highlightOptions(color = "#7F7F7F", weight = 3) , group="SECTOR",options = pathOptions(pane="polygons"))%>%
  
  addPolygons(data=colRel,color = "#17BECF",fillColor = "#F4A460",fillOpacity =0.005,weight = 3,popup = paste("<b>","COLONIA : ","</b>",colRel$NOM_ASENTA) ,
              labelOptions = labelOptions(noHide = T, textOnly = TRUE,direction = "center"),
              highlightOptions = highlightOptions(color = "#17BECF", weight = 3) , group="COLONIAS",options = pathOptions(pane="polygons"))%>%
  
  
  #STVS-------------------------------  
  addCircles(data = cam20,lng = cam20$LONGITUD,lat = cam20$LATITUD,color = "blue" ,fillColor = "blue",radius = 8,fillOpacity = T,
             popup = paste("<b>","ID: ","</b>",as.character(cam20$ID_BCT_O),"<br>",
                           "<b>","TIPO DE POSTE : ","</b>",as.character(cam20$TIPO_POSTE)),
             group = paste("20m","(",nrow(cam20),")"),options = pathOptions(pane="li"))%>%
  
  addCircles(data = cam9,lng = cam9$LONGITUD,lat = cam9$LATITUD,color = "red" ,fillColor ="red",radius = 10,fillOpacity = T,
             popup = paste("<b>","ID: ","</b>",as.character(cam9$ID_BCT_O),"<br>",
                           "<b>","TIPO DE POSTE: ","</b>",as.character(cam9$TIPO_POSTE),"<br>",
                           "<b>","BOTON: ","</b>",as.character(cam9$BOTON),"<br>",
                           "<b>","ALTAVOZ: ","</b>",as.character(cam9$ALTAVOZ),"<br>"),
             group = paste("9m","(",nrow(cam9),")"),options = pathOptions(pane="li"))%>%
  
  #TOTEMS-------------------
addCircles(data = totem, lng = totem$LONGITUD, lat = totem$LATITUD,radius = 8,color = "black",fillColor = "black",fillOpacity = T,
           popup = paste("<b>","ID: ","</b>",(totem$ID_BCT_O)), 
           group = paste("TÓTEMS","(",nrow(totem),")"),options = pathOptions(pane="li"))%>%
  
  
  #ETIQUETAS----------------------------------------------------------
addLayersControl(overlayGroups = c( "&nbsp; <b>CAPAS</b> &nbsp; ",
                                    "SECTORES","COLONIAS",
                                    paste("9m","(",nrow(cam9),")"),
                                    paste("20m","(",nrow(cam20),")"),
                                    paste("TÓTEMS","(",nrow(totem),")")#,
                                    #"&nbsp; <b>CLASIFICACI?N</b> &nbsp; ",
                                    #paste("HOMICIDIO POR ARMA BLANCA","(",nrow(arma_blanca),")"),
),
options = layersControlOptions(collapsed = T))%>% 
  
  
  htmlwidgets::onRender(jsCode = htmlwidgets::JS("function(btn,map){ 
                                                
                                                 
                                                 var lc=document.getElementsByClassName('leaflet-control-layers-overlays')[0]
                                                 
                                                 lc.getElementsByTagName('input')[0].style.display='none';
                                                 lc.getElementsByTagName('input')[6].style.display='none';
                                                 
                                                 lc.getElementsByTagName('div')[0].style.fontSize='100%';
                                                 lc.getElementsByTagName('div')[0].style.textAlign='center';
                                                 lc.getElementsByTagName('div')[0].style.color='white';
                                                 lc.getElementsByTagName('div')[0].style.backgroundColor='#9F2241';
                                                 
                                                 lc.getElementsByTagName('div')[6].style.fontSize='100%';
                                                 lc.getElementsByTagName('div')[6].style.textAlign='center';
                                                 lc.getElementsByTagName('div')[6].style.color='white';
                                                 lc.getElementsByTagName('div')[6].style.backgroundColor='#9F2241';
                                                 
                                         
   ;
                                                 }
                                                 ")) %>%
  
  addMarkers(data = camaras, lng = as.numeric(camaras$LONGITUD),lat = as.numeric(camaras$LATITUD), label = c(camaras$ID_BCT_O),group = 'CONS')%>%
  addMarkers(data = totem,lng=totem$LONGITUD,lat = totem$LATITUD,label = totem$ID_BCT_O,group = "TOT")%>% 
  addSearchFeatures(targetGroups = c("CONS","TOT"),
                    options = searchFeaturesOptions(zoom=20, openPopup = TRUE, firstTipSubmit = TRUE,
                                                    autoCollapse = F, hideMarkerOnCollapse = T,
                                                    textPlaceholder="ID STV"))%>% 
  addLegendCustom(colors, labels, sizes, shapes, borders)%>%  
  #addLegend(position = "bottomleft",labels = c("Menos de 250 personas","250 a 599 personas","600 a 1000 personas","Más de 1000 personas"),colors = c("#FFFF00","#FFFF00","#FF0000","#FF0000"),title = "AFLUENCIA CENTRO HISTÓRICO")%>%
  
  hideGroup(c( "&nbsp; <b>CAPAS</b> &nbsp; ",
               "SECTORES","COLONIAS",
               paste("9m","(",nrow(cam9),")"),
               paste("20m","(",nrow(cam20),")"),
               paste("TÓTEMS","(",nrow(totem),")"),
               #"&nbsp; <b>CLASIFICACI?N</b> &nbsp; ",
               #paste("HOMICIDIO POR ARMA BLANCA","(",nrow(arma_blanca),")"),
               
               "&nbsp; <b>MI C911E</b> &nbsp; ",
               "TOT","CONS"))








