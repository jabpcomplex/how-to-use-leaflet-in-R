# 🗺️ Crear un Mapa Interactivo del Metro de la CDMX con R y Leaflet

¡Bienvenido a este repositorio! Aquí aprenderás a crear un **mapa interactivo** en HTML utilizando el lenguaje **R** y la librería **Leaflet**. Este proyecto está enfocado en visualizar las líneas del Sistema de Transporte Colectivo Metro de la Ciudad de México (CDMX) de manera dinámica y profesional.



## 🌟 ¿Qué encontrarás aquí?

- **Código en R**:
   - 1. Un script completo para generar un mapa interactivo con las 12 líneas del Metro de la CDMX.
   - 2. Un script completo para generar un mapa interactivo con las cámaras de C5 en la colonia XOTEPINGO
- **Datos georreferenciados**: Archivos shapefile (`.shp`) con la información geográfica de las líneas del Metro y la colonia XOTEPINGO Ciudad de México.
- **Resultado visual**: Un mapa interactivo que puedes abrir en cualquier navegador web.
- **Explicaciones paso a paso**: Guías detalladas para que cualquier persona, incluso sin experiencia previa, pueda replicar el proyecto.



## 🚀 ¿Por qué usar Leaflet en R?

**Leaflet** es una de las librerías más populares para crear mapas interactivos. Al combinarla con **R**, puedes aprovechar el poder del análisis de datos y la visualización geográfica. Algunas ventajas de este enfoque son:

- **Fácil de usar**: Con pocas líneas de código, puedes crear mapas profesionales.
- **Interactividad**: Los mapas generados permiten zoom, desplazamiento y clics para obtener más información.
- **Personalización**: Puedes agregar capas, marcadores, polígonos y mucho más.


## 🛠️ Requisitos previos

Antes de empezar, asegúrate de tener instalado:

- [R](https://www.r-project.org/)
- [RStudio](https://www.rstudio.com/)
- El paquete `leaflet` de R (instalación en el siguiente paso).



## 📦 Instalación y configuración

1. **Instala el paquete `leaflet`**:
   Abre RStudio y ejecuta el siguiente comando en la consola:

   ```R
   install.packages("leaflet")

2. **Clona este repositorio:**
Si deseas trabajar con los archivos locales, clona el repositorio en tu computadora:


```shell

    git clone https://github.com/jabpcomplex/how-to-use-leaflet-in-R.git

```  

3. **Explora los archivos sobre METRO:**

En la carpeta CDMX encontrarás los archivos georreferenciados de la Ciudad de México.

En la carpeta stcmetro_shp están los shapefiles de las 12 líneas del Metro.

🗺️ Estructura del script en R
El script se divide en tres partes principales:

4. Creación del mapa FINAL:


<p align="center">
<img src="https://raw.githubusercontent.com/jabpcomplex/how-to-use-leaflet-in-R/refs/heads/main/Captura%20de%20pantalla%20de%202022-05-11%2014-21-46.png">
</p>

---

# 🗺️ Mapa Interactivo con la instalación de  Cámaras del  C5 en la Colonia XOTEPINGO

<p align="center">
<img src="https://raw.githubusercontent.com/jabpcomplex/how-to-use-leaflet-in-R/refs/heads/main/xotepingo_html.png">
</p>
---

## 🎯 ¿Por qué este repositorio es útil?
1. Aprendizaje: Ideal para quienes quieren aprender a crear mapas interactivos con R.

2. Aplicaciones prácticas: Puedes adaptar este código para visualizar otros datos geográficos, como rutas de transporte, zonas urbanas o datos demográficos.

3. Comunidad: Si tienes dudas o sugerencias, ¡no dudes en abrir un issue o contribuir al repositorio!

## 📂 Estructura del repositorio

```shell
Copy
Crear-mapa-interactivo-lenguaje-R/
├── CDMX/                  # Archivos georreferenciados de la CDMX
├── stcmetro_shp/          # Shapefiles de las líneas del Metro
├── script.R               # Script principal en R
├── README.md              # Este archivo
└── mapa_interactivo.html  # Mapa generado (resultado final)
```

## 👥 ¿Cómo contribuir?

1. ¡Tu contribución es bienvenida! Si tienes ideas para mejorar el proyecto, sigue estos pasos:

2. Haz un fork del repositorio.

3. Crea una nueva rama (git checkout -b mejora/mi-mejora).

4. Realiza tus cambios y haz commit (git commit -m "Agrega mi mejora").

5. Haz push a la rama (git push origin mejora/mi-mejora).

6. Abre un Pull Request y describe tus cambios.

## 📌 ¿Te gustó el proyecto?
¡Dale una ⭐ al repositorio y compártelo con tus amigos! Si tienes alguna pregunta o sugerencia, no dudes en contactarme.

## 📲 Sígueme en mis redes
¡Conéctate conmigo para más proyectos interesantes!

- 🐦 Twitter

- 🔗 LinkedIn

- 📸 Instagram

- 📹 YouTube

¡Gracias por visitar este repositorio! Espero que te sea útil y que disfrutes creando mapas interactivos con R y Leaflet. 🚀


