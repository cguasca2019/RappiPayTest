# RappiMovie (Prueba Técnica para Rappi Pay)




El aplicativo está diseñado para que sea ejecutado tanto en un emulador como en un dispositivo físico, pero la experiencia de usuario es mejor en el dispositivo físico, se recomienda ejecutar con una cuenta DEMO,


Rappi Movie - Swift 5 - IOS 14 En adelante.


## Como ejecutar el app en xcode


Ejecutar POD INSTALL
Esto hará que descargue los pods necesarios para su funcionamiento.


```sh
cd RappiPayTest
pod install
```


## Preguntas adicionales de la prueba


##### 1.  Las capas de la aplicación (por ejemplo capa de persistencia, vistas, red, negocio, etc) y qué clases pertenecen a cual.


El aplicativo está diseñado bajo el patrón de arquitectura MVC con dos capas adicionales, capa del tratamiento de datos de forma interna y consumo de información externa a continuación se explica de que forma esta implementado:


- Models: En esta capa se encuentran todas las clases que gestionan la persistencia y los objetos 
- View: Esta dividida en dos, todas las clases auxiliares que se necesitan para interactuar con main.storyboard, que se encuentran en Utils, por ejemplo aquellas para darle diseño, animación, celdas y filas de las tablas y por otra parte están los storyboards de launcher y main donde se desarrolla todo el diseño y UX/UI que se implemento en esta solución   
- Controller: Son todas las clases que comunican el main.storyboard (View) con el modelo y las capas de persistencia y consumo
- ExternalDataManager: Es el encargado de mediar entre los servicios (TMDB) y la capa de Models, de esta forma por medio de peticiones http y herramientas como SwiftyJSON (Deserialización) y Alamofire (Manejo de headers), junto con URLSesion (Propio de Fundation) interpreta y entrega los datos de una manera legible
- InternalDataManager: Su tarea dentro del sistema es almacenar los datos por medio de una base de datos local (SqlLite) para contemplar el caso de que el dispositivo no cuente con conexión a internet


##### 2.  La responsabilidad de cada clase creada.


- ExternalDataManager/MoviesApi: Clase responsable del manejo de las peticiones HTTP de la fuente TMDB
- ExternalDataManager/MoviesProtocol: Comunica el Api con los controladores 
- InternalDataManager/ModelDB: Encargada del manejo de la base de datos, querys directos al sqlite
- Models/Category: Objeto global corresponde a la respuesta de los métodos de cada categoría 
- Models/Movie: Objeto película, embebido dentro del objeto Category en la variable result 
- Models/Trailer: Clase que representa la respuesta del método "video" del api, aqui se almacenan todos los videos relacionados con la película, incluyendo los trailers oficiales
- Controllers/PopularController: Controlador que comunica la vista de películas populares con el modelo y las demás capas
- Controllers/CentralListController: Controlador de la lista global que es utilizada en las 4 categorías del sistema
- Controllers/MoviesDetailsController: Controlador que interactúa con el detalle de cada película
- Controllers/NowPlayingController: Controlador que comunica la vista de películas que se reproducen actualmente con el modelo y las demás capas
- Controllers/UpcomingController: Controlador que comunica la vista de películas que se estrenaran próximamente con el modelo y las demás capas
- Controllers/TopRatingController: Controlador que comunica la vista de películas con mejor puntuación con el modelo y las demas capas
- Controllers/SearchOnlineController: Controlador encargado de realizar la búsqueda online en el buscador con conexión
- Cells/CentralListCell: Representación visual para ser llamado en el collectionview que arma la lista principal
- Cells/ReusableFooter: Pie de página de la lista principal
- Cells/SearchOnlineCell: Componente visual de la tabla de elementos del buscador online
- Protocols/CentralListProtocol: Clase que agiliza la comunicación entre la lista principal (CentralListController) y los demas controladores del sistema (En este caso puntual)
- Utils/Tools: Clase transversal que maneja las preferencias y los datos almacenados en memoria
- Utils/ViewShadow: Es una clase de inspección encargada de darle propiedades como bordes redondeados y sombras a las vistas
- Utils/ImageRound: Agrega bordes a las imágenes de la lista principal
- Utils/MultiplerChange: Es la clase encargada de reducir y aumentar el multiplicador del constrain en el detalle de las peliculas para que el diseño sea armonioso
- Utils/CachedImages: Realiza la descarga y procesamiento de las imágenes para utilizarlas sin conexión
- Utils/DissmisTransition: Transición animada al salir de la vista secundaria y retornar a la vista primaria
- Utils/PresentTransition: Transición animada al entrar en la vista secundaria desde la vista primaria
- Utils/ImageUrl: Clase encargada de descargar los datos de una imagen por medio de su URL
- Utils/Rechability: Objeto cuya responsabilidad es conocer el estado de la conexión a internet del dispositivo


##### 3. En qué consiste el principio de responsabilidad única? Cuál es su propósito?


El principio de responsabilidad única o Single responsibility principle es el primero de los principios S.O.L.I.D que indica que una clase debe tener una única responsabilidad en el software, cada uno de sus métodos deben estar diseñados para cumplir ese propósito, en caso de tener una clase con distintas funcionalidades, lo correcto seria refactorizar la clase en varias subclases para poder cumplir este principio.


##### 4. Qué características tiene, según su opinión, un “buen” código o código limpio


En mí opinión, la forma de escribir un buen código, consiste en ponerse en los zapatos de otro desarrollador y preguntarse si el podría entender lo que está escrito y realizar alguna tarea sobre esa parte del software de manera ágil, para esto es optimo que las variables tengan un sentido, un nombre coherente y descriptivo, que el código tenga buenos comentarios, se debe codificar como si se estuviera escribiendo un libro, con un orden, para así facilitar su lectura.


## Presentado por César Guasca

