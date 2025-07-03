import 'package:flutter/material.dart';

class AppConstants {
  // Información de la aplicación
  static const String appName = 'Sistema de Inventario SUAN';
  static const String appVersion = '1.0.0';
  
  // Tipos de productos
  static const String productoTerminado = 'ProductoTerminado';
  static const String materiaPrima = 'MateriaPrima';
  
  // Tipos de movimientos
  static const String entrada = 'ENTRADA';
  static const String salida = 'SALIDA';
  
  // Rangos de códigos numéricos
  static const int minCodigoNumerico = 1000;
  static const int maxCodigoNumerico = 9999;
  
  // Límites de caracteres para campos
  static const int maxLengthTexto = 100;
  static const int maxLengthId = 50;
  static const int maxLengthUrl = 500;
  
  // Colores del tema
  static const Color primaryColor = Colors.blue;
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;
  static const Color infoColor = Colors.blue;
  
  // Mensajes de error comunes
  static const String errorConexion = 'Error de conexión a la base de datos';
  static const String errorCampoObligatorio = 'Este campo es obligatorio';
  static const String errorCodigoInvalido = 'Código numérico inválido';
  static const String errorStockInsuficiente = 'Stock insuficiente para esta operación';
  static const String errorProductoNoEncontrado = 'Producto no encontrado';
  
  // Mensajes de éxito
  static const String exitoProductoCreado = 'Producto creado exitosamente';
  static const String exitoStockActualizado = 'Stock actualizado exitosamente';
  static const String exitoProductoEliminado = 'Producto eliminado exitosamente';
  
  // Configuraciones de UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 2.0;
  
  // Duración de animaciones
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Configuraciones de red
  static const Duration timeoutDuration = Duration(seconds: 30);
  static const int maxRetries = 3;
}

class AppStrings {
  // Títulos de pantallas
  static const String homeTitle = 'Sistema de Inventario';
  static const String productosTerminadosTitle = 'Productos Terminados';
  static const String materiasPrimasTitle = 'Materias Primas';
  static const String kardexProductosTitle = 'Kardex - Productos Terminados';
  static const String kardexMateriasTitle = 'Kardex - Materias Primas';
  static const String crearProductoTitle = 'Crear Producto';
  static const String gestionarStockTitle = 'Gestionar Stock';
  
  // Labels de campos
  static const String familiaLabel = 'Familia';
  static const String claseLabel = 'Clase';
  static const String modeloLabel = 'Modelo';
  static const String marcaLabel = 'Marca';
  static const String presentacionLabel = 'Presentación';
  static const String colorLabel = 'Color';
  static const String capacidadLabel = 'Capacidad';
  static const String unidadVentaLabel = 'Unidad de Venta';
  static const String rackLabel = 'Rack';
  static const String nivelLabel = 'Nivel';
  static const String imagenLabel = 'URL de Imagen';
  static const String codigoNumericoLabel = 'Código Numérico';
  static const String cantidadLabel = 'Cantidad';
  
  // Hints de campos
  static const String familiaHint = 'Ej: Electrónicos, Textiles, etc.';
  static const String claseHint = 'Ej: Audio, Video, etc.';
  static const String modeloHint = 'Ej: MP3, MP4, etc.';
  static const String marcaHint = 'Ej: Apple, Samsung, etc.';
  static const String presentacionHint = 'Ej: Slim, Compact, etc.';
  static const String colorHint = 'Ej: Silver, Black, etc.';
  static const String capacidadHint = 'Ej: 16GB, 32GB, etc.';
  static const String unidadVentaHint = 'Ej: Unidad, Caja, Paquete, etc.';
  static const String rackHint = 'Ej: A1, B2, etc.';
  static const String nivelHint = 'Ej: 1, 2, 3, etc.';
  static const String imagenHint = 'https://ejemplo.com/imagen.jpg';
  static const String codigoNumericoHint = 'Ingrese el código numérico';
  static const String cantidadHint = 'Ingrese la cantidad';
  
  // Botones
  static const String btnCrear = 'Crear';
  static const String btnGuardar = 'Guardar';
  static const String btnCancelar = 'Cancelar';
  static const String btnEliminar = 'Eliminar';
  static const String btnBuscar = 'Buscar';
  static const String btnActualizar = 'Actualizar';
  static const String btnConfirmar = 'Confirmar';
  static const String btnCerrar = 'Cerrar';
  static const String btnReintentar = 'Reintentar';
  
  // Estados
  static const String cargando = 'Cargando...';
  static const String sinDatos = 'No hay datos disponibles';
  static const String sinResultados = 'No se encontraron resultados';
}
