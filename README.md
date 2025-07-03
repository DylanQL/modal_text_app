# Sistema de Inventario SUAN

Sistema de gestión de inventario desarrollado en Flutter para el manejo de productos terminados y materias primas con control de stock y kardex de movimientos.

## Características Principales

- ✅ **Gestión de Productos**: Crear, visualizar y eliminar productos terminados y materias primas
- ✅ **ID Automático**: Generación automática de ID basado en las iniciales de las características del producto
- ✅ **Control de Stock**: Añadir y quitar stock usando códigos numéricos
- ✅ **Kardex Completo**: Historial detallado de entradas y salidas
- ✅ **Base de Datos MySQL**: Persistencia de datos robusta
- ✅ **Interfaz Intuitiva**: Diseño moderno y fácil de usar

## Modelo de Datos

### Tabla Productos
```sql
- id (AUTO_INCREMENT)
- id_generado (ÚNICO) - Ejemplo: PRELEMP3NAAPSI16G1
- tipo (ProductoTerminado | MateriaPrima)
- familia
- clase
- modelo
- marca
- presentacion
- color
- capacidad
- unidad_venta
- rack
- nivel
- codigo_numerico (ÚNICO)
- imagen (URL)
- stock_actual
```

### Tabla Movimientos Kardex
```sql
- id_movimiento (AUTO_INCREMENT)
- fecha
- producto (FK -> productos.id_generado)
- cantidad
- tipo_movimiento (ENTRADA | SALIDA)
- rack
- nivel
- stock_resultado
```

## Requisitos Previos

1. **Flutter SDK** (3.7.2 o superior)
2. **MySQL Server** (8.0 o superior)
3. **Dart SDK** (incluido con Flutter)

## Instalación

### 1. Configurar Base de Datos

1. Instalar MySQL Server
2. Crear usuario y base de datos:
```sql
-- Ejecutar en MySQL
CREATE DATABASE suan_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'root'@'localhost' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON suan_app.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
```

3. Ejecutar el script de inicialización:
```bash
mysql -u root -p123456 suan_app < database/init_database.sql
```

### 2. Configurar Aplicación Flutter

1. Clonar o descargar el proyecto
```bash
cd modal_text_app
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Verificar configuración de base de datos en `lib/services/database_service.dart`:
```dart
final settings = ConnectionSettings(
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: '123456',
  db: 'suan_app',
);
```

### 3. Ejecutar Aplicación

```bash
flutter run
```

## Uso de la Aplicación

### Pantalla Principal
- Ver resumen de inventario
- Acceder a gestión de productos terminados
- Acceder a gestión de materias primas
- Ver kardex de movimientos

### Gestión de Productos
1. **Crear Producto**: Presionar el botón "+" y llenar el formulario
2. **Ver Detalles**: Expandir la tarjeta del producto
3. **Gestionar Stock**: Usar el botón "Gestionar Stock"
4. **Eliminar**: Confirmar eliminación en el diálogo

### Control de Stock
1. Ingresar código numérico del producto
2. Seleccionar tipo de movimiento (Entrada/Salida)
3. Ingresar cantidad
4. Confirmar operación

### Kardex
- Ver historial completo de movimientos
- Filtrar por producto, tipo o ubicación
- Ver estadísticas rápidas

## Estructura del Proyecto

```
lib/
├── models/
│   ├── producto.dart
│   └── movimiento_kardex.dart
├── providers/
│   └── inventario_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── productos_screen.dart
│   ├── crear_producto_screen.dart
│   ├── stock_management_screen.dart
│   └── kardex_screen.dart
├── services/
│   └── database_service.dart
└── main.dart
```

## Dependencias Principales

- `mysql1`: Conexión a base de datos MySQL
- `provider`: Gestión de estado
- `intl`: Formateo de fechas
- `flutter_datetime_picker_plus`: Selector de fechas

## Ejemplos de ID Generados

| Producto | ID Generado |
|----------|-------------|
| Producto Terminado - Electrónicos - Audio - MP3 - Nano - Apple - Slim - Silver - 16GB | PRELEMP3NAAPSI16G1 |
| Materia Prima - Metal - Aluminio - Plancha - Molina - Industrial - Natural - 1mm | MATEALCOPLMO11001 |

## Solución de Problemas

### Error de Conexión a MySQL
1. Verificar que MySQL esté ejecutándose
2. Confirmar credenciales en `database_service.dart`
3. Verificar permisos del usuario de base de datos

### Error al Crear Productos
1. Verificar que todos los campos obligatorios estén llenos
2. Confirmar que no exista conflicto con códigos numéricos

### Problemas de Dependencias
```bash
flutter clean
flutter pub get
```

## Desarrollo y Contribución

Para contribuir al proyecto:

1. Fork del repositorio
2. Crear rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver archivo LICENSE para más detalles.

## Contacto

Para preguntas o soporte técnico, contactar al equipo de desarrollo.
