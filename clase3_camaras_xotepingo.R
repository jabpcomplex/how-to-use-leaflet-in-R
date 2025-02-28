library(sf)
library(leaflet)
library(leaflet.extras)
library(htmltools)
library(htmlwidgets)
library(tidyverse)
library(dplyr)
library(readxl)

########################################################################################
#cargamos los poligonos para colonias y sectores
colRel <- spTransform(shapefile("RUTA/ARCHIVO/COL_EL RELOJ.shp"), "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
secXote <- spTransform(shapefile("RUTA/ARCHIVO/SECTOR_XOTEPINGO.shp"), "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# base con las camaras STV (Sistemas Tecnologicos de Videovigilancia)
camaras <- read_excel("RUTA/ARCHIVO/SECTOR XOTEPINGO_COL_EL RELOJ.xlsx")

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

#Etiquetas personalizadas
etiquetas_camara <- c("9m", "20m","TOTEM" ) 
colores_camara <- c("blue","green","red") # Define los colores para cada categoría




################################################################################################################
####                 #GENERAMOS MAPA CON LEAFLET                                                           ####
################################################################################################################

leaflet()  %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
  addFullscreenControl()%>%clearBounds()%>%
  addControl(title,position = "topleft",className="map-title")%>%
  
  leafem::addMouseCoordinates() %>% addFullscreenControl(position = "topleft", pseudoFullscreen = F) %>%
  addResetMapButton()%>%
  setView(lng = mean(camaras$LONGITUD),lat = mean(camaras$LATITUD),zoom = 13) %>%
  
  addMapPane("polygons",zIndex = 500)%>%
  addMapPane("ce",zIndex = 510)%>%
  addMapPane("li",zIndex=570)%>%
  #addMapPane("col",zIndex = 550)%>%
  addMapPane("lo",zIndex = 580)%>%
  
  addPolygons(data=secXote ,color = "black",fillColor = "transparent",fillOpacity =0.5,weight = 3,
              labelOptions = labelOptions(noHide = T, textOnly = TRUE,direction = "center"),
              highlightOptions = highlightOptions(color = "#7F7F7F", weight = 3) , group="SECTOR",options = pathOptions(pane="polygons"))%>%
  
  addPolygons(data=colRel,color = "black",fillColor = "transparent",fillOpacity =0.5,weight = 3,
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
  
  
  #Legenda de TIPO_POSTE
  addLegend(
    "bottomright",
    colors = colores_camara, # Colores correspondientes a las categorías
    labels = etiquetas_camara, # Etiquetas de las categorías
    title = "Cobertura") %>%
  
  
  #ETIQUETAS----------------------------------------------------------
addLayersControl(overlayGroups = c( "&nbsp; <b>CAPAS</b> &nbsp; ",
                                    paste("9m","(",nrow(cam9),")"),
                                    paste("20m","(",nrow(cam20),")"),
                                    paste("TÓTEMS","(",nrow(totem),")")
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
  
  
  
  hideGroup(c( "&nbsp; <b>CAPAS</b> &nbsp; ",
               paste("9m","(",nrow(cam9),")"),
               paste("20m","(",nrow(cam20),")"),
               paste("TÓTEMS","(",nrow(totem),")"),
               
               "&nbsp; <b>MI C911E</b> &nbsp; ",
               "TOT","CONS"))









