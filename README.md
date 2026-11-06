Sistema de gestión de inventarios y control de stock de una miscelánea

Prototipo desarrollado para la asignatura Ecuaciones Diferenciales (Ingeniería de Sistemas, Universidad Libre).

Docente asesor: Jorge Enrique Taboada Álvare Integrantes: Gabriel Francisco Santos Pineda, Leonor Gabriela Rubio Delgado, Juan Esteban Suarez Garcia

¿Qué hace?

Permite registrar productos, proveedores y ventas. Cada venta descuenta el stock automáticamente y el sistema estima cuándo se agotará cada producto para avisar a tiempo que hay que reponerlo.

Modelo matemático

El inventario se trata como un sistema dinámico. Con I(t) como el inventario y v como la tasa de venta diaria:

dI/dt = -v   →   I(t) = I₀ - v·t
Tasa de venta diaria: unidades vendidas en el periodo elegido (7, 10, 15 o 30 días) divididas entre los días del periodo.
Días para agotarse: I / v, el tiempo en que I(t) llega a cero.
Punto de reorden: v · tiempo de entrega + stock de seguridad.
Alerta: se genera cuando el stock actual es menor o igual al punto de reorden.
Tecnologías
Frontend: HTML y CSS
Lógica: JavaScript
Backend y base de datos: Supabase (PostgreSQL)