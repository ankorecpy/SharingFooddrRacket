#lang racket

(require racket/gui/base);libreria utilizada
(require db)

(define conexion ; Conexion con mysql
  (mysql-connect
   #:server "localhost"
   #:port 3307
   #:database "BD_SHARING_FOOD"
   #:user "root"
   #:password "12345"))

;---------------------------------------------INICIO INTERFAZ LOGIN--------------------
;definicion de la ventana
(define frame (new frame%  [label "SHARING FOOD"]
                   [width 300][height 500]
                   [x 500][y 100])
  )

;variables globales
(define est_registro 1)
(define vId -1)
(define vIdPublicacion -1)
(define vNumPlatos -1)
(define vAuxiliar -1)
(define menosVen 0);variables de informe
(define vNumPlatosVen -1)
(define vCostoP -1)
(define vTotalV -1)
(define max -1)

;definicion de elementos graficos junto con su comportamiento
(new message% [parent frame]                           
     [min-height 60]
     [label ""])

(define titulo (new message% [parent frame]                           
     [min-height 75]
     [label "SHARING FOOD"])
  )

(define nombreUsuario (new text-field% [parent frame]
     [label "NOMBRE:"])
  )

(new message% [parent frame]                           
     [min-height 1]
     [label ""])

(define clave (new text-field% [parent frame]
     [label "     CLAVE:"])
)

(new message% [parent frame]                           
     [min-height 30]
     [label ""])

(define mensajeIngreso (new message% [parent frame]                           
     [label ""]))

(new message% [parent frame]                           
     [min-height 30]
     [label ""])

(define botonIngreso (new button%
                   [label "INGRESAR"]                           
                   [min-width 200]
                   [parent frame]
                   [callback (lambda (boton event)
                               (iniciarSesion (send nombreUsuario get-value) (send clave get-value))
                               )]
             )
  )

(define botonRegistro (new button%
                   [label "REGISTRARME"]  
                   [min-width 200]
                   [parent frame]
                   [callback (lambda (boton event)
                               (set! vId -1)
                               (send txtNombre set-value "")
                               (send txtClave set-value "")
                               (send txtTelefono set-value "")
                               (send txtPaginaWeb set-value "")
                               (send txtDireccion set-value "")
                               (habilitarInsertar)
                               (send frame show #f)
                               )]
             )
  )

(define (habilitarInsertar)
  (set! est_registro 1)
  (send registro show #t)
  )

;Despliegue de ventana
(send frame show #t)

;Consulta que retorna 1 si existe una empresa con el nombre y la clave ingresada, retorna 0 de lo contrario
(define (iniciarSesion nombre clave)  
  (gestionLoggeo (query-value conexion (string-append "SELECT IFNULL(Emp_Id, -1) FROM EMPRESA WHERE Emp_Nombre = '" nombre "' AND Emp_Password = '" clave "'")))    
  )

(define (gestionLoggeo resultado)
  (if (= resultado -1)
      (send mensajeIngreso set-value "Datos de ingreso incorrectos. Intente de nuevo")
      (habilitarOpciones resultado)  
      )
  )

(define (habilitarOpciones id)
  (set! vId id)
      (send frame show #f)
      (send opciones show #t)
  )

;---------------------------------------------FIN INTERFAZ LOGIN--------------------------

;---------------------------------------------INICIO INTERFAZ OPCIONES--------------------
(define opciones (new frame%  [label "SHARING FOOD"]
                   [width 300][height 500]
                   [x 500][y 100])
  )

(new message% [parent opciones]                           
     [min-height 60]
     [label ""]
     )

(define lblOpciones (new message% [parent opciones]                           
     [min-height 75]
     [label "OPCIONES"])
  )

(define btnAgregarPublicacion (new button%
                   [label "NUEVA PUBLICACION"] 
                   [min-width 200]
                   [parent opciones]
                   [callback (lambda (boton event)
                               (send publicacion show #t)
                               (send opciones show #f)
                               )]
             )  
  )

(define btnMisPublicaciones (new button%
                   [label "MIS PUBLICACIONES"]   
                   [min-width 200]
                   [parent opciones]
                   [callback (lambda (boton event)
                               (set! vIdPublicacion (query-value conexion (string-append "SELECT IFNULL(MAX(pub_Id),-1) FROM Publicacion WHERE Emp_Id = " (number->string vId) " AND pub_UnidadesConsumidas < pub_UnidadesOfertadas")))
                               (cargarDatosPublicacion)
                               (send publicaciones show #t)
                               (send opciones show #f)
                               )]
             )
  )

(define btnAjusteDeDatos (new button%
                   [label "AJUSTE DE DATOS"]  
                   [min-width 200]
                   [parent opciones]
                   [callback (lambda (boton event)
                                   (habilitarAjusteDatos)
                               )]
             )
  )

(define btnInformes (new button%
                   [label "INFORMES"]  
                   [min-width 200]
                   [parent opciones]
                   [callback (lambda (boton event)                             
                               (set! vIdPublicacion (query-value conexion (string-append "SELECT IFNULL(MAX(pub_Id),-1) FROM Publicacion WHERE Emp_Id = " (number->string vId) " AND pub_UnidadesConsumidas < pub_UnidadesOfertadas")))
                               (cargarDatosInformes)
                               (send informes show #t)
                               (send opciones show #f)
                               )]
             )
  )

(new message% [parent opciones]                           
     [min-height 60]
     [label ""]
 )

(define btnCerrarSesion (new button%
                   [label "CERRAR SESIÓN"]  
                   [min-width 200]
                   [parent opciones]
                   [callback (lambda (boton event)
                               (send opciones show #f)
                               (send nombreUsuario set-value "")
                               (send clave set-value "")
                               (send frame show #t)
                               )]
             )
  )

;extraer valores de la base de datos y insertarlos en las cajas de texto
(define (habilitarAjusteDatos)
  (send txtNombre set-value (query-value conexion (string-append "SELECT Emp_Nombre FROM EMPRESA WHERE Emp_Id = " (number->string vId))))
  (send txtClave set-value (query-value conexion (string-append "SELECT Emp_Password FROM EMPRESA WHERE Emp_Id = " (number->string vId))))
  (send txtTelefono set-value (query-value conexion (string-append "SELECT Emp_Telefono FROM EMPRESA WHERE Emp_Id = " (number->string vId))))
  (send txtPaginaWeb set-value (query-value conexion (string-append "SELECT Emp_PaginaWeb FROM EMPRESA WHERE Emp_Id = " (number->string vId))))
  (send txtDireccion set-value (query-value conexion (string-append "SELECT Emp_Direccion FROM EMPRESA WHERE Emp_Id = " (number->string vId))))
  (set! est_registro 0)
  (send opciones show #f)  
  (send registro show #t)  
  )



;---------------------------------------------FIN INTERFAZ OPCIONES--------------------

;---------------------------------------------INICIO INTERFAZ REGISTRO-----------------
(define registro (new frame%
                   [label "SHARING FOOD"]
                   [width 400][height 600]                   
                   [x 500][y 100])
  )

(new message% [parent registro]                           
     [min-height 30]
     [label ""]
     )

(define lblRegistro (new message% [parent registro]
                        [min-height 45]
                        [label "REGISTRO"])
  )

(new message% [parent registro]     
     [min-height 30]
     [label ""]
     )

(define txtNombre (new text-field% [parent registro]
     [label "       NOMBRE: "]
     )
  )

(define txtClave (new text-field% [parent registro]
     [label "            CLAVE: "]
     )
  )  

(define txtTelefono (new text-field% [parent registro]
     [label "    TELEFONO: "]
     )
  )  

(define txtPaginaWeb (new text-field% [parent registro]
     [label "PAGINA WEB: "])
  )

(define txtDireccion (new text-field% [parent registro]
     [label "   DIRECCION: "]
     )
  )

(new message% [parent registro]  
     [min-height 150]
     [min-width 100]
     [label ""]
     )


(define btnRegistrar (new button%
                   [label "GUARDAR"]
                   [min-width 200]
                   [parent registro]
                   [callback (lambda (boton event)
                               (gestionDatosEmpresa (send txtNombre get-value) (send txtClave get-value) (send txtTelefono get-value) (send txtPaginaWeb get-value) (send txtDireccion get-value))
                               )]
             )
  )
(define btnRegresarDeRegistro (new button%
                   [label "REGRESAR"]
                   [min-width 200]
                   [parent registro]
                   [callback (lambda (boton event)
                               (send txtNombre set-value "")
                                (send txtClave set-value "")
                                (send txtTelefono set-value "")
                                (send txtPaginaWeb set-value "")
                                (send txtDireccion set-value "")
                                (send registro show #f)
                                (if (= est_registro 1)                                    
                                    (send frame show #t)
                                    (send opciones show #t)
                                    )
                                
                               )]
             )
  )
;--------------------------------------------FIN INTERFAZ REGISTRO--------------------------

;--------------------------------------------INICIO INTERFAZ PUBLICACION--------------------
(define publicacion (new frame%
                   [label "Sharing Food"]
                   [width 400][height 600]                   
                   [x 500][y 100])
  )

(new message% [parent publicacion] 
     [min-height 30]
     [label ""]
     )

(define lblPublicacion (new message% [parent publicacion]
                        [min-height 45]
                        [label "PUBLICACION"])
  )

(new message% [parent publicacion]  
     [min-height 30]
     [label ""]
     )

(define txtPlato (new text-field% [parent publicacion]
     [label "                 PLATO: "])
  )

(define txtPrecio (new text-field% [parent publicacion]
     [label " PRECIO OFERTA: "])
  )

(define txtPrecioProduccion (new text-field% [parent publicacion]
     [label "PRECIO PRODUC: "])
  )

(define txtUnidades (new text-field% [parent publicacion]
     [label "            UNIDADES: "])
  )


(new message% [parent publicacion] 
     [min-height 150]
     [min-width 100]
     [label ""]
     )

(define btnPublicar (new button%
                   [label "PUBLICAR"]
                   [min-width 200]
                   [parent publicacion]
                   [callback (lambda (boton event)
                               (ingresoPublicacion (send txtPlato get-value) (send txtPrecio get-value) (send txtPrecioProduccion get-value) (send txtUnidades get-value))
                               (send opciones show #t)
                               (send publicacion show #f)
                               )]
             )
  )

(define btnRegresarDePublicacion (new button%
                   [label " REGRESAR "]
                   [min-width 200]
                   [parent publicacion]
                   [callback (lambda (boton event)
                               (send txtPlato set-value "")
                               (send txtPrecio set-value "")
                               (send txtUnidades set-value "")
                               (send opciones show #t)
                               (send publicacion show #f)
                               )]
             )
  )
;---------------------------------------------FIN INTERFAZ PUBLICACION-------------------

;---------------------------------------------INICIO INTERFAZ PUBLICACIONES--------------
(define publicaciones (new frame%
                   [label "SHARING FOOD"]
                   [width 400][height 600]                   
                   [x 500][y 100])
  )

(new message% [parent publicaciones] 
     [min-height 30]
     [label ""]
     )

(define lbltitulo (new message% [parent publicaciones]     
     [min-height 45]
     [label ""])
  )

(new message% [parent publicaciones]     
     [min-height 30]
     [label "PUBLICACIONES"]
     )

(new message% [parent publicaciones]                    
     [min-height 30]
     [label ""]
     )

(define nombrePlato (new text-field% [parent publicaciones]  
     [label "                PLATO:"]
     [enabled #f])     
  )

(define precioPlato (new text-field% [parent publicaciones]                    
     [label "PRECIO OFERTA:"]     
     [enabled #f])
  )
(define precioPlatoProd (new text-field% [parent publicaciones]                    
     [label "    PRECIO PROD:"]     
     [enabled #f])
  )
(define unidadesPlato (new text-field% [parent publicaciones]
     [label "          UNIDADES:"]     
     [enabled #f])
  )


(define decrementarUnidades (new button%
                   [label "CONSUMIR PLATO"]                           
                   [min-width 100]
                   [parent publicaciones]
                   [callback (lambda (boton event)
                               (if (> vNumPlatos 0)
                                   (decrementarValorPlatos 1)
                                   (write " NO decrementado")
                                )
                               )]
             )
  )

(define (decrementarValorPlatos decremento)
     (set! vNumPlatos (- vNumPlatos decremento))
     (send unidadesPlato set-value (number->string vNumPlatos))
     (query-exec conexion (string-append "Update publicacion set Pub_UnidadesConsumidas = (Pub_UnidadesConsumidas + " (number->string decremento) ") where pub_Id = " (number->string vIdPublicacion)))
     (query-exec conexion (string-append "Update publicacion set Pub_UnidadesOfertadas = (Pub_UnidadesOfertadas - " (number->string decremento) ") where pub_Id = " (number->string vIdPublicacion))) 
  )

(new message% [parent publicaciones]                           
     [min-height 180]
     [label ""]
     )

(define botonAnterior (new button%
                   [label "< ANTERIOR"]                           
                   [min-width 100]
                   [parent publicaciones]
                   [callback (lambda (boton event)
                              (cargarOtraPublicacion "<" "MAX")
                              )]                             
             )
  )

(define botonSiguiente (new button%
                   [label "SIGUIENTE >"]                           
                   [min-width 100]
                   [parent publicaciones]             
                   [callback (lambda (boton event)
                              (cargarOtraPublicacion ">" "MIN")
                              )]                             
             )
  )

(define botonRegresarDePublicaciones (new button%
                   [label " REGRESAR "]                           
                   [min-width 100]
                   [parent publicaciones]
                   [callback (lambda (boton event)
                               (send opciones show #t)
                               (send publicaciones show #f)
                               )]                             
             )
  )
;---------------------------------------------FIN INTERFAZ PUBLICACIONES-------------------

;---------------------------------------------INICIO INTERFAZ INFORMES---------------------
(define informes (new frame%
                   [label "SHARING FOOD"]
                   [width 400][height 600]                   
                   [x 500][y 100])
  )
(new message% [parent informes] ;para dar espacio
     [min-height 30]
     [label ""]
     )
(new message% [parent informes]     
     [min-height 30]
     [label "INFORMES"]
     )
(define platoMasVendido (new message% [parent informes]                           
     [min-height 75]
     [label "                                                                                  "])
  )
(new message% [parent informes] ;para dar espacio
     [min-height 30]
     [label ""]
     )
(define nombrePlato2 (new text-field% [parent informes]  
     [label "           PLATO:                     "]
     [enabled #f])     
  )
(define unidadesvendidas (new text-field% [parent informes]
     [label "          UNIDADES VENDIDAS:          "]     
     [enabled #f])
  )
(define costoProduccion (new text-field% [parent informes]
     [label "          COSTO TOTAL DE PRODUCCION   "]     
     [enabled #f])
  )
(define totalventas (new text-field% [parent informes]
     [label "          TOTAL DE VENTAS CONCRETADAS:"]     
     [enabled #f])
  )
(define recomendaciones (new message% [parent informes]                           
     [min-height 75]
     [label "                                                                                  "])
  )
(define recomendaciones2 (new message% [parent informes]                           
     [min-height 75]
     [label "                                                                                  "])
  )

(new message% [parent informes] ;para dar espacio
     [min-height 30]
     [label ""]
     )
(define botonAnteriorInforme (new button%
                   [label "< ANTERIOR"]                           
                   [min-width 100]
                   [parent informes]
                   [callback (lambda (boton event)
                              (cargarOtrosDatosInformes "<" "MAX")
                              )]                             
             )
  )
(define botonSiguienteInforme (new button%
                   [label "SIGUIENTE >"]                           
                   [min-width 100]
                   [parent informes]             
                   [callback (lambda (boton event)
                              (cargarOtrosDatosInformes ">" "MIN")
                              )]                             
             )
  )
(new message% [parent informes] ;para dar espacio
     [min-height 30]
     [label ""]
     )

(define botonRegresarDeInformes (new button%
                   [label " REGRESAR "]                           
                   [min-width 100]
                   [parent informes]
                   [callback (lambda (boton event)
                               (send opciones show #t)
                               (send informes show #f) 
                               )]                             
             )
  )

;datos para informes
(define (cargarDatosInformes)  
  (cond
    ((= vIdPublicacion -1) (write "no hay informes para mostrar"))
    (else (send nombrePlato2 set-value (query-value conexion (string-append "SELECT pub_Plato FROM Publicacion WHERE pub_Id = " (number->string vIdPublicacion))))   
       (set! vNumPlatos (query-value conexion (string-append "SELECT pub_UnidadesOfertadas FROM Publicacion WHERE pub_Id = " (number->string vIdPublicacion))))
       (set! vNumPlatosVen (query-value conexion (string-append "SELECT pub_UnidadesConsumidas FROM Publicacion WHERE pub_Id = " (number->string vIdPublicacion))))
       (send unidadesvendidas set-value (number->string vNumPlatosVen))
       (set! vCostoP (* (+ vNumPlatos vNumPlatosVen) (query-value conexion (string-append "SELECT pub_PrecioProduccion FROM Publicacion WHERE pub_Id = " (number->string vIdPublicacion)))))
       (send costoProduccion set-value (number->string vCostoP))
       (set! vTotalV (* (query-value conexion (string-append "SELECT pub_PrecioOferta FROM Publicacion WHERE pub_Id = " (number->string vIdPublicacion))) vNumPlatosVen))
       (send totalventas set-value (number->string vTotalV))
       (recomendacion vCostoP vTotalV)
    )
))
(define (recomendacion costoP totalV)
  (cond
    ((> costoP totalV) (send recomendaciones set-label (string-append "La empresa tiene una perdida de: " (number->string (- costoP totalV)))))
    ((> totalV costoP) (send recomendaciones set-label (string-append "La empresa tiene una GANANCIA de: " (number->string (- totalV costoP)))))
))
;---------------------------------------------FIN INTERFAZ INFORMES------------------------


;---------------------------------------------INICIO GESTION BASE DE DATOS------------------------
(define (gestionDatosEmpresa nombre clave telefono paginaWeb direccion)
  (if (= est_registro 1)
      (ingreso nombre clave telefono paginaWeb direccion)
      (query-exec conexion (string-append "UPDATE Empresa SET Emp_Nombre = '" nombre "', Emp_Password = '" clave "', Emp_Telefono = '" telefono "', Emp_PaginaWeb = '" paginaWeb "', Emp_Direccion = '" direccion "' WHERE Emp_Id = " (number->string vId)))
      )
  )

(define (ingreso nombre clave telefono paginaWeb direccion)
  (query-exec conexion (string-append "INSERT INTO Empresa (Emp_Nombre, Emp_Password, Emp_Telefono, Emp_PaginaWeb, Emp_Direccion) VALUES ('" nombre "','" clave "','" telefono "','" paginaWeb "','" direccion "')"))
   (if (null? (query-rows conexion (string-append "SELECT * FROM Empresa WHERE Emp_Nombre = '" nombre "'")))       
       (write "Registro Fallido")
       (write "Registro Exitoso")
       )
  )

(define (ingresoPublicacion plato precioOferta precioProduccion unidades)
  (query-exec conexion (string-append "INSERT INTO Publicacion (Pub_Plato, Pub_PrecioOferta, Pub_PrecioProduccion, Pub_UnidadesOfertadas, Emp_Id) VALUES ('" plato "'," precioOferta "," precioProduccion "," unidades"," (number->string vId)")"))
   (if (null? (query-rows conexion (string-append "SELECT * FROM Empresa WHERE Emp_Nombre = '" plato "'")))       
       (write "Registro Fallido")
       (write "Registro Exitoso")
       )
  )
;para cargar la informacion de las publicaciones de cada empresa____________________________________________________________________________
(define (cargarDatosPublicacion)  
  (cond
    ((= vIdPublicacion -1) (write "no hay publicaciones para mostrar"))
    (else (send nombrePlato set-value (query-value conexion (string-append "SELECT pub_Plato FROM Publicacion WHERE pub_Id = " (number->string vIdPublicacion))))
       (send precioPlato set-value (number->string (query-value conexion (string-append "SELECT pub_PrecioOferta FROM Publicacion WHERE pub_Id = " (number->string vIdPublicacion)))))
       (send precioPlatoProd set-value (number->string (query-value conexion (string-append "SELECT pub_PrecioProduccion FROM Publicacion WHERE pub_Id = " (number->string vIdPublicacion)))))
       (set! vNumPlatos (query-value conexion (string-append "SELECT pub_UnidadesOfertadas FROM Publicacion WHERE pub_Id = " (number->string vIdPublicacion))))
       (send unidadesPlato set-value (number->string vNumPlatos)))                           
  )
)

(define (cargarOtraPublicacion operando rango)
  (set! vAuxiliar (query-value conexion (string-append "SELECT IFNULL(" rango "(pub_Id),-1) FROM Publicacion WHERE pub_Id " operando " " (number->string vIdPublicacion)  " AND Emp_Id = " (number->string vId) " AND pub_UnidadesConsumidas < pub_UnidadesOfertadas")))
  (cond
    ((= vAuxiliar -1) (write "No e pueden mostrar mas publicaciones"))
    (else (set! vIdPublicacion vAuxiliar) (cargarDatosPublicacion))
   )
)
;para cargar la informacion de los informes_________________________________________________________________________________________________
(define (cargarOtrosDatosInformes operando rango)
  (set! vAuxiliar (query-value conexion (string-append "SELECT IFNULL(" rango "(pub_Id),-1) FROM Publicacion WHERE pub_Id " operando " " (number->string vIdPublicacion)  " AND Emp_Id = " (number->string vId))))
  (cond
    ((= vAuxiliar -1) (write "No e pueden mostrar mas publicaciones"))
    (else (set! vIdPublicacion vAuxiliar) (cargarDatosInformes))
   )
)
;---------------------------------------------FIN GESTION BASE DE DATOS----------------------------