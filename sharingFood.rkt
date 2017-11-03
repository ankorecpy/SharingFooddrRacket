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
(define frame (new frame%  [label "Sharing Food"]
                   [width 300][height 500]
                   [x 500][y 100])
  )

;definicion de elementos graficos junto con su comportamiento
(new message% [parent frame]                           
     [min-height 60]
     [label ""])

(define titulo (new message% [parent frame]                           
     [min-height 75]
     [label "Sharing Food"])
  )

(define nombreUsuario (new text-field% [parent frame]
     [label "Nombre:"])
  )

(new message% [parent frame]                           
     [min-height 1]
     [label ""])

(define clave (new text-field% [parent frame]
     [label "     Clave:"])
)

(new message% [parent frame]                           
     [min-height 60]
     [label ""])

(define botonIngreso (new button%
                   [label "Ingresar"]                           
                   [min-width 200]
                   [parent frame]
                   [callback (lambda (boton event)
                               (iniciarSesion (send nombreUsuario get-value) (send clave get-value))
                               )]
             )
  )

(define botonRegistro (new button%
                   [label "Registrarme"]                           
                   [min-width 200]
                   [parent frame]
                   [callback (lambda (boton event)
                               (send registro show #t)
                               )]
             )
  )

;Despliegue de ventana
(send frame show #t)

;Consulta que retorna 1 si existe una empresa con el nombre y la clave ingresada, retorna 0 de lo contrario
(define (iniciarSesion nombre clave)
  (gestionLoggeo (query-value conexion (string-append "SELECT COUNT(*) FROM EMPRESA WHERE Emp_Nombre='" nombre "' AND Emp_Password = '" clave "'")))    
  )

;Método de prueba (BORRAR LUEGO)-------------------------------------------
(define (mensaje x)
  (write x)
  )

(define (gestionLoggeo resultado)
  (if (= resultado 1)
      (send opciones show #t)
      (mensaje "Falló ingreso")
      )
  )

;---------------------------------------------FIN INTERFAZ LOGIN--------------------

;---------------------------------------------INICIO INTERFAZ OPCIONES--------------------
(define opciones (new frame%  [label "Sharing Food"]
                   [width 300][height 500]
                   [x 500][y 100])
  )

(new message% [parent opciones]                           
     [min-height 60]
     [label ""]
     )

(define lblOpciones (new message% [parent opciones]                           
     [min-height 75]
     [label "Opciones"])
  )

(define btnAgregarPublicacion (new button%
                   [label "Nueva Publicacion"]                           
                   [min-width 200]
                   [parent opciones]
                   [callback (lambda (boton event)
                               (send publicacion show #t)
                               )]
             )  
  )

(define btnMisPublicaciones (new button%
                   [label "Mis Publicaciones"]                           
                   [min-width 200]
                   [parent opciones]
                   [callback (lambda (boton event)
                               (send publicaciones show #t)
                               )]
             )
  )

(define btnAjusteDeDatos (new button%
                   [label "Ajuste de datos"]                           
                   [min-width 200]
                   [parent opciones]
             )
  )

(define btnInformes (new button%
                   [label "Informes"]  
                   [min-width 200]
                   [parent opciones]
             )
  )

;---------------------------------------------FIN INTERFAZ OPCIONES--------------------

;---------------------------------------------INICIO INTERFAZ REGISTRO---------------------------
(define registro (new frame%
                   [label "Sharing Food"]
                   [width 400][height 600]                   
                   [x 500][y 100])
  )

(new message% [parent registro]                           
     [min-height 30]
     [label ""]
     )

(define lblRegistro (new message% [parent registro]
                        [min-height 45]
                        [label "Registro"])
  )

(new message% [parent registro]     
     [min-height 30]
     [label ""]
     )

(define txtNombre (new text-field% [parent registro]
     [label "     Nombre: "])
  )

(define txtClave (new text-field% [parent registro]
     [label "          Clave: "])
  )

(define txtPaginaWeb (new text-field% [parent registro]
     [label "Pagina Web: "])
  )

(define txtDireccion (new text-field% [parent registro]
     [label "     Direccion: "])
  )

(new message% [parent registro]  
     [min-height 150]
     [min-width 100]
     [label ""]
     )


(define btnRegistrar (new button%
                   [label "Registrar"]
                   [min-width 200]
                   [parent registro]                   
             )
  )
;--------------------------------------------FIN INTERFAZ REGISTRO----------------------------------------------

;---------------------------------------------INICIO INTERFAZ PUBLICACION-------------------
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
                        [label "Publicación"])
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
                   [label "Publicar"]
                   [min-width 200]
                   [parent publicacion]                   
             )
  )
;---------------------------------------------FIN INTERFAZ PUBLICACION-------------------

;---------------------------------------------INICIO INTERFAZ PUBLICACIONES-------------------
(define publicaciones (new frame%
                   [label "Sharing Food"]
                   [width 400][height 600]                   
                   [x 500][y 100])
  )

(new message% [parent publicaciones] 
     [min-height 30]
     [label ""]
     )

(define lbltitulo (new message% [parent publicaciones]     
     [min-height 45]
     [label "Restaurante Patojito"])
  )

(new message% [parent publicaciones]     
     [min-height 30]
     [label "Publicaciones"]
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
                   [label "consumir plato"]                           
                   [min-width 100]
                   [parent publicaciones]                   
             )
  )

(new message% [parent publicaciones]                           
     [min-height 180]
     [label ""]
     )

(define botonAnterior (new button%
                   [label "< Anterior"]                           
                   [min-width 100]
                   [parent publicaciones]                   
             )
  )

(define botonSiguiente (new button%
                   [label "Siguiente >"]                           
                   [min-width 100]
                   [parent publicaciones]             
             )
  )
;---------------------------------------------FIN INTERFAZ PUBLICACIONES-------------------

;---------------------------------------------INICIO INTERFAZ INFORMES---------------------

;---------------------------------------------FIN INTERFAZ INFORMES------------------------