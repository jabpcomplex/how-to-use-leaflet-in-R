
#LIBRERIAS BASICAS HTML--------
rm(list = ls())
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

setwd("C:/Users/jbautistap/Desktop/RUTA VIACRUCIS 2023/")
#CARGAR BASES-------------------------------------
dir()
##################################################################################################################
#Cargamos la informacion para el JUEVES SANTO
rutaJ<-spTransform(shapefile("RUTA JUEVES SANTO 2023.shp"), "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

colnames(base)
unique(base$TIPO_POSTE)

# FILTRAMOS LA BASE QUE FUNCIONA COMO CAPA GENERAL PARA EL JUEVES SANTO
#la base  solo contiene hay POSTES de  9metros
b9t<-base[which((base$TIPO_POSTE)=="9m"),]
#b9ir<-base[which((base$TIPO_POSTE)=="9mIR"),]
#b9t<-rbind(b9,b9ir)


#la base  solo contiene hay POSTES de  20m
b20t<-base[which((base$TIPO_POSTE)=="20m"),]
#b20ir<-base[which((base$TIPO_POSTE)=="20mIR"),]
#b20t<-rbind(b20,b20ir)


totem<- base[which((base$TIPO_POSTE)=="TOTEM"),]
#totem2<-base[which((base$TIPO_POSTE)=="TOTEM_FASE2"),]
#totem<-rbind(totem,totem2)


##################################################################################################################
#Cargamos la informacion para el VIERNES SANTO
base2<- read.csv("COBERTURA VIERNES SANTO.csv", header = T,stringsAsFactors=FALSE, fileEncoding="latin1")
caidaV<-spTransform(shapefile("CAIDAS VIERNES SANTO 2023.shp"), "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
rutaV<-spTransform(shapefile("RUTA VIERNES SANTO 2023.shp"), "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")


colnames(base2)
unique(base2$TIPO_POSTE)
unique(base2$TIPO_CAMARA)
# FILTRAMOS LA BASE QUE FUNCIONA COMO CAPA GENERAL PARA EL VIERNES SANTO
#la base  solo contiene hay POSTES de  9metros
b9t2<-base2[which((base2$TIPO_POSTE)=="9m"),]
#b9ir<-base[which((base$TIPO_POSTE)=="9mIR"),]
#b9t<-rbind(b9,b9ir)


#la base  NO contiene  POSTES de  20m

totem2<- base2[which((base2$TIPO_POSTE)=="TOTEM"),]
#totem2<-base[which((base$TIPO_POSTE)=="TOTEM_FASE2"),]
#totem<-rbind(totem,totem2)

##############################################################################################################
##############################################################################################################

# COMIENZAN LOS PREPARATIVSO PARA HACER MAPA

##############################################################################################################

# Call the color function (colorNumeric) to create a new palette function
#pal <- colorFactor(c("blue","blue","green","green"), c("9m","20m","20mIR","9mIR"))

# Pass the palette function a data vector to get the corresponding colors
#pal(c("9m","20m","9mIR"))


#BUFFER<-spTransform(shapefile("AUTODROMO_POLIGONO_BUFF2.shp"), "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

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
  }
"))


#TITULO------------------------- #creacion de titulo
year<-as.numeric(substr(Sys.Date(),1,4))
dia<-c(1:(as.numeric(substr(Sys.Date(),9,10))))
mes<-as.numeric(substr(Sys.Date(),6,7))
meses<-c("ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE")

title <- tags$div(
  tag.map.title, HTML(paste("VIA CRUCIS Iztapalapa 2023" ))
)
#OOOkOk

#logo institucional C5
ciudad<-iconList(city=makeIcon(iconUrl = "https://github.com/jabpcomplex/GWR-with-R/raw/main/ms-icon-150x150.png"))

#para legendas personalizadas HTML de abajo a la izquierda
colors <- c("orange","red") #relleno circulo
labels <- c( "RUTA",
             paste("CAÍDAS")) 
sizes <- c(10,10)
shapes <- c("square","circle")
#contorno del circulo
borders <- c("orange","red")

#Funcion para agregar etiquetas personalizadas
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
  
  #POSICION DE LA ETIQUETA DE LEGENDAS
  return(addLegend(map, colors = legend_colors, labels = legend_labels, opacity = opacity,position = "bottomleft"))
}

# #funcion para anexar tablas o imagen
# rr <- tags$div( 
#   HTML('<a href="https://cran.r-project.org/"> <img border="0" alt="ImageTitle" top= "-50px" src="https://i.ibb.co/p1Gbb5H/imagen.jpg" width="328" height="141"> </a>')
# )  






















##############################################################################################################
##############################################################################################################

#GENERAMOS MAPA--------------------------------------------------------------------------------------------------------

##############################################################################################################




leaflet()  %>%addTiles() %>%#addProviderTiles(providers$Esri.WorldGrayCanvas) %>%  #capas base ej. capa en tonos grises
  addProviderTiles(providers$OpenStreetMap.Mapnik) %>%

  addFullscreenControl()%>%clearBounds()%>%     #botones de maximizar en pantalla y regresar al centro del mapa
  addControl(title,position = "topleft",className="map-title")%>%   #funcion para agregar el titulo
  #addControl(rr,position = "bottomleft")%>% #funcion para agregar imagen
  leafem::addMouseCoordinates() %>% addFullscreenControl(position = "topleft", pseudoFullscreen = F) %>%  #funcion de mostrar coordenadas
  leafem::addLogo(img=ciudad$city,src="remote",position="bottomright",width=120,height=100)%>%      #funcion que agrega logo institucional

  addResetMapButton()%>%
  setView(lng = mean(base$LONGITUD),lat = mean(base$LATITUD),zoom = 16) %>%
  
  addMapPane("polygons",zIndex = 500)%>%
  addMapPane("ce",zIndex = 510)%>%
  addMapPane("li",zIndex=570)%>%
  #addMapPane("col",zIndex = 550)%>%
  addMapPane("lo",zIndex = 580)%>%
  

 # addPolygons(data=BUFFER,color = "darkgreen",fillOpacity =0.1,fillColor = "transparent",weight = 3,popup =paste("Buffer Autódromo Hermanos Rodríguez"),
  #            highlightOptions = highlightOptions(color = "darkgreen", weight = 3) , group="Buffer",options = pathOptions(pane="polygons"))%>%
  
  addPolylines(data=rutaJ,color = "orange",fillOpacity =0.1,fillColor = "transparent",weight = 6,popup =paste("<b>","RUTA : ","</b>","JUEVES"),
              highlightOptions = highlightOptions(color = "orange", weight = 6) , group="RUTA JUEVES",options = pathOptions(pane="polygons"))%>%
  
  addPolylines(data=rutaV,color = "orange",fillOpacity =0.1,fillColor = "transparent",weight = 6,popup =paste("<b>","RUTA : ","</b>","VIERNES"),
               highlightOptions = highlightOptions(color = "orange", weight = 6) , group="RUTA VIERNES",options = pathOptions(pane="polygons"))%>%
  
  #STVS-------------------------------  
addCircles(data = caidaV,lng = caidaV$LONHITUDE,lat = caidaV$LATITUDE,color = "red" ,fillColor = "red",radius = 10,fillOpacity = T,
           popup = paste("<b>","NO: ","</b>",as.character(caidaV$NO),"<br>",
                         "<b>","CAÍDAS: ","</b>",as.character(caidaV$CAIDAS),"<br>"),
           group = paste("CAÍDAS","(",nrow(caidaV),")"),options = pathOptions(pane="li"))%>%
  
  



#ETIQUETAS----------------------------------------------------------
  addLayersControl(overlayGroups = c( "&nbsp; <b>JUEVES 6 de Abril</b> &nbsp; ",
                                      "RUTA JUEVES",
                                      "&nbsp; <b>VIERNES 7 de Abril</b> &nbsp; ",
                                      paste("CAÍDAS","(",nrow(caidaV),")"),
                                      "RUTA VIERNES"
                                      ),
                                     options = layersControlOptions(collapsed = T))%>% 
  htmlwidgets::onRender(jsCode = htmlwidgets::JS("function(btn,map){ 
                                                 var lc=document.getElementsByClassName('leaflet-control-layers-overlays')[0]
                                                 
                                                 lc.getElementsByTagName('input')[0].style.display='none';
                                                 lc.getElementsByTagName('input')[2].style.display='none';
                                                 lc.getElementsByTagName('div')[0].style.fontSize='160%';
                                                 lc.getElementsByTagName('div')[2].style.fontSize='160%';
                                                 lc.getElementsByTagName('div')[0].style.textAlign='center';
                                                 lc.getElementsByTagName('div')[2].style.textAlign='center';
                                                 lc.getElementsByTagName('div')[0].style.color='white';
                                                 lc.getElementsByTagName('div')[2].style.color='white';
                                                 lc.getElementsByTagName('div')[0].style.backgroundColor='#9F2241';
                                                 lc.getElementsByTagName('div')[2].style.backgroundColor='#9F2241';
   ;  }
                                                 ")) %>%
  
  
  #addMarkers(data = base, lng = as.numeric(base$LONGITUD),lat = as.numeric(base$LATITUD), label = c(base$ID_BCT_O),group = 'CONS')%>% 
  #addMarkers(data = base2, lng = as.numeric(base2$LONGITUD),lat = as.numeric(base2$LATITUD), label = c(base2$ID_BCT_O),group = 'CONS')%>% 
  
  #funcion para agregar la lista de objetos que se pueden buscar
  #addSearchFeatures(targetGroups = c("CONS","TOT"),       #funcion para realizar busquedas
   #                 options = searchFeaturesOptions(zoom=20, openPopup = TRUE, firstTipSubmit = TRUE,
    #                                                autoCollapse = F, hideMarkerOnCollapse = T,
     #                                               textPlaceholder="ID CÁMARA O TOTEM"))%>% 
  #agrega etoquetas de la parte inferior
  addLegendCustom(colors, labels, sizes, shapes, borders)%>%  
  #addLegend(position = "bottomleft",labels = c("Menos de 250 personas","250 a 599 personas","600 a 1000 personas","Más de 1000 personas"),colors = c("#FFFF00","#FFFF00","#FF0000","#FF0000"),title = "AFLUENCIA CENTRO HISTÓRICO")%>%
  
  
  hideGroup( c( "&nbsp; <b>JUEVES 6 de Abril</b> &nbsp; ",
                "RUTA JUEVES",
                "&nbsp; <b>VIERNES 7 de Abril</b> &nbsp; ",
                paste("CAÍDAS","(",nrow(caidaV),")"),
                "RUTA VIERNES"))

  
  
  
