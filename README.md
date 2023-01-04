# Crear-mapa-interactivo-lenguaje-R

Tutorial para crear un mapa georeferenciado en en lenguaje de programación R. Creado por jabpcomplex  con la libreria leaflet.

La librería leaflet traduce nuestros comandos de R a JavaScript, creando una página web con elementos de información geográfica (como puntos, líneas o polígonos) y fondos georreferenciados.

# Primeros pasos con Leaflet y R

Una vez que tengamos instalado R y RStudio lo primero es por supuesto instalar el paquete de Leaflet. Para ello escribimos en la consola de RStudio:


```shell

    install.packages("leaflet")

```  

El script en R para leaflet se compone de:

1. Creación del mapa mediante leaflet(), es el equivalente a una instancia de la clase map de la librería JavaScript de Leaflet.
2. Añadir capas.
3. Imprimir el mapa.


En la carpeta CDMX encontramos los archivos georeferenciados correspondientes a la capital de México, es decir, la ciudad de México; en la carpeta stcmetro_shp los correspondientes al Sistema de Transporte Colectivo Metro (las 12 lineas) una de las infraestructuras de transporte más importantes de la ciudad.

![metro de la ciudad de mexico](https://www.mexicodesconocido.com.mx/wp-content/uploads/2018/08/mapa-metro-cdmx-grande-web-769x1024.jpg)

