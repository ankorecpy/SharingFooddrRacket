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
     [min-height 60]
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
  (gestionLoggeo (query-value conexion (string-append "SELECT Emp_Id FROM EMPRESA WHERE Emp_Nombre = '" nombre "' AND Emp_Password = '" clave "'")))    
  )

(define (gestionLoggeo resultado)
  (if (null? resultado)
      (write "FALLÓ EL INGRESO")      
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
                               )]
             )  
  )

(define btnMisPublicaciones (new button%
                   [label "MIS PUBLICACIONES"]   
                   [min-width 200]
                   [parent opciones]
                   [callback (lambda (boton event)
                               (send publicaciones show #t)
                               )]
             )
  )

(define btnAjusteDeDatos (new button%
                   [label "AJUSTE DE DATOS"]  
                   [min-width 200]
                   [parent opciones]
                   [callback (lambda (boton event)
                               ;ajsutar valores de variables globales
                               ;(set! vNombre (query-value conexion (string-append "SELECT Emp_Nombre FROM EMPRESA WHERE Emp_Id = " vId )))                               
                                   (habilitarAjusteDatos)
                               )]
             )
  )

(define btnInformes (new button%
                   [label "INFORMES"]  
                   [min-width 200]
                   [parent opciones]
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
                               (
                                (send registro show #f)
                                (if (= est_registro 1)                                    
                                    (send frame show #t)
                                    (send opciones show #t)
                                    )
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
     [label "      PLATO: "])
  )

(define txtPrecio (new text-field% [parent publicacion]
     [label "     PRECIO: "])
  )

(define txtUnidades (new text-field% [parent publicacion]
     [label "UNIDADES: "])
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
     [label "RESTAURANTE PATOJITO"])
  )

(new message% [parent publicaciones]     
     [min-height 30]
     [label "PUBLICACIONES"]
     )

(new message% [parent publicaciones]                    
     [min-height 30]
     [label ""]
     )

(define nombrePlato (new message% [parent publicaciones]  
     [min-height 25]
     [label "PLATO:      Churrasco punta de anca"])
  )

(define precioPlato (new message% [parent publicaciones]                    
     [min-height 25]
     [label "PRECIO:      $17000                                  "])
  )
(define unidadesPlato (new message% [parent publicaciones]                           
     [min-height 25]
     [label "UNIDADES:      14                                               "])
  )


(define decrementarUnidades (new button%
                   [label "CONSUMIR PLATO"]                           
                   [min-width 100]
                   [parent publicaciones]                   
             )
  )

(new message% [parent publicaciones]                           
     [min-height 180]
     [label ""]
     )

(define botonAnterior (new button%
                   [label "< ANTERIOR"]                           
                   [min-width 100]
                   [parent publicaciones]                   
             )
  )

(define botonSiguiente (new button%
                   [label "SIGUIENTE >"]                           
                   [min-width 100]
                   [parent publicaciones]             
             )
  )
;---------------------------------------------FIN INTERFAZ PUBLICACIONES-------------------

;---------------------------------------------INICIO INTERFAZ INFORMES---------------------



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

;---------------------------------------------FIN GESTION BASE DE DATOS----------------------------