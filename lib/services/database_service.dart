import 'package:mysql1/mysql1.dart';
import '../models/producto.dart';
import '../models/movimiento_kardex.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static MySqlConnection? _connection;
  
  DatabaseService._();
  
  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Future<MySqlConnection> get connection async {
    if (_connection == null) {
      final settings = ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: '123456',
        db: 'suan_app',
      );
      
      try {
        _connection = await MySqlConnection.connect(settings);
        print('Conexión a MySQL establecida correctamente');
      } catch (e) {
        print('Error al conectar con MySQL: $e');
        rethrow;
      }
    }
    return _connection!;
  }

  Future<void> initializeDatabase() async {
    final conn = await connection;
    
    try {
      // Crear tabla de productos
      await conn.query('''
        CREATE TABLE IF NOT EXISTS productos (
          id INT AUTO_INCREMENT PRIMARY KEY,
          id_generado VARCHAR(50) UNIQUE NOT NULL,
          tipo ENUM('ProductoTerminado', 'MateriaPrima') NOT NULL,
          familia VARCHAR(100) NOT NULL,
          clase VARCHAR(100) NOT NULL,
          modelo VARCHAR(100) NOT NULL,
          marca VARCHAR(100) NOT NULL,
          presentacion VARCHAR(100) NOT NULL,
          color VARCHAR(50) NOT NULL,
          capacidad VARCHAR(50) NOT NULL,
          unidad_venta VARCHAR(50) NOT NULL,
          rack VARCHAR(20) NOT NULL,
          nivel VARCHAR(20) NOT NULL,
          codigo_numerico VARCHAR(20) UNIQUE NOT NULL,
          imagen VARCHAR(500),
          stock_actual INT DEFAULT 0,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
      ''');

      // Crear tabla de movimientos kardex
      await conn.query('''
        CREATE TABLE IF NOT EXISTS movimientos_kardex (
          id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
          fecha DATETIME NOT NULL,
          producto VARCHAR(50) NOT NULL,
          cantidad INT NOT NULL,
          tipo_movimiento ENUM('ENTRADA', 'SALIDA') NOT NULL,
          rack VARCHAR(20) NOT NULL,
          nivel VARCHAR(20) NOT NULL,
          stock_resultado INT NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (producto) REFERENCES productos(id_generado) ON DELETE CASCADE
        )
      ''');

      print('Tablas creadas exitosamente');
    } catch (e) {
      print('Error al crear las tablas: $e');
      rethrow;
    }
  }

  // CRUD Productos
  Future<int> insertarProducto(Producto producto) async {
    final conn = await connection;
    
    try {
      // Generar código numérico único
      String codigoNumerico = await _generarCodigoNumerico();
      
      // Generar secuencial para ID
      String idGenerado = await _generarIdProducto(producto);
      
      final result = await conn.query('''
        INSERT INTO productos (
          id_generado, tipo, familia, clase, modelo, marca, 
          presentacion, color, capacidad, unidad_venta, 
          rack, nivel, codigo_numerico, imagen, stock_actual
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''', [
        idGenerado,
        producto.tipo,
        producto.familia,
        producto.clase,
        producto.modelo,
        producto.marca,
        producto.presentacion,
        producto.color,
        producto.capacidad,
        producto.unidadVenta,
        producto.rack,
        producto.nivel,
        codigoNumerico,
        producto.imagen,
        producto.stockActual,
      ]);
      
      return result.insertId!;
    } catch (e) {
      print('Error al insertar producto: $e');
      rethrow;
    }
  }

  Future<List<Producto>> obtenerProductos({String? tipo}) async {
    final conn = await connection;
    
    try {
      String query = 'SELECT * FROM productos';
      List<dynamic> params = [];
      
      if (tipo != null) {
        query += ' WHERE tipo = ?';
        params.add(tipo);
      }
      
      query += ' ORDER BY created_at DESC';
      
      final results = await conn.query(query, params);
      
      return results.map((row) => Producto.fromMap(row.fields)).toList();
    } catch (e) {
      print('Error al obtener productos: $e');
      rethrow;
    }
  }

  Future<Producto?> obtenerProductoPorCodigo(String codigoNumerico) async {
    final conn = await connection;
    
    try {
      final results = await conn.query(
        'SELECT * FROM productos WHERE codigo_numerico = ?',
        [codigoNumerico]
      );
      
      if (results.isNotEmpty) {
        return Producto.fromMap(results.first.fields);
      }
      return null;
    } catch (e) {
      print('Error al obtener producto por código: $e');
      rethrow;
    }
  }

  Future<void> actualizarStock(String codigoNumerico, int nuevaCantidad, String tipoMovimiento) async {
    final conn = await connection;
    
    try {
      await conn.query('START TRANSACTION');
      
      // Obtener producto actual
      final producto = await obtenerProductoPorCodigo(codigoNumerico);
      if (producto == null) {
        throw Exception('Producto no encontrado');
      }
      
      int stockAnterior = producto.stockActual;
      int stockNuevo;
      
      if (tipoMovimiento == 'ENTRADA') {
        stockNuevo = stockAnterior + nuevaCantidad;
      } else {
        stockNuevo = stockAnterior - nuevaCantidad;
        if (stockNuevo < 0) {
          throw Exception('Stock insuficiente');
        }
      }
      
      // Actualizar stock del producto
      await conn.query(
        'UPDATE productos SET stock_actual = ? WHERE codigo_numerico = ?',
        [stockNuevo, codigoNumerico]
      );
      
      // Insertar movimiento en kardex
      final movimiento = MovimientoKardex(
        fecha: DateTime.now(),
        producto: producto.idGenerado,
        cantidad: nuevaCantidad,
        tipoMovimiento: tipoMovimiento,
        rack: producto.rack,
        nivel: producto.nivel,
        stockResultado: stockNuevo,
      );
      
      await insertarMovimientoKardex(movimiento);
      
      await conn.query('COMMIT');
    } catch (e) {
      await conn.query('ROLLBACK');
      print('Error al actualizar stock: $e');
      rethrow;
    }
  }

  Future<void> eliminarProducto(int id) async {
    final conn = await connection;
    
    try {
      await conn.query('DELETE FROM productos WHERE id = ?', [id]);
    } catch (e) {
      print('Error al eliminar producto: $e');
      rethrow;
    }
  }

  // CRUD Kardex
  Future<int> insertarMovimientoKardex(MovimientoKardex movimiento) async {
    final conn = await connection;
    
    try {
      final result = await conn.query('''
        INSERT INTO movimientos_kardex (
          fecha, producto, cantidad, tipo_movimiento, 
          rack, nivel, stock_resultado
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
        movimiento.fecha,
        movimiento.producto,
        movimiento.cantidad,
        movimiento.tipoMovimiento,
        movimiento.rack,
        movimiento.nivel,
        movimiento.stockResultado,
      ]);
      
      return result.insertId!;
    } catch (e) {
      print('Error al insertar movimiento kardex: $e');
      rethrow;
    }
  }

  Future<List<MovimientoKardex>> obtenerKardex({String? tipoProducto}) async {
    final conn = await connection;
    
    try {
      String query = '''
        SELECT mk.*, p.tipo as producto_tipo 
        FROM movimientos_kardex mk 
        JOIN productos p ON mk.producto = p.id_generado
      ''';
      
      List<dynamic> params = [];
      
      if (tipoProducto != null) {
        query += ' WHERE p.tipo = ?';
        params.add(tipoProducto);
      }
      
      query += ' ORDER BY mk.fecha DESC';
      
      final results = await conn.query(query, params);
      
      return results.map((row) => MovimientoKardex.fromMap(row.fields)).toList();
    } catch (e) {
      print('Error al obtener kardex: $e');
      rethrow;
    }
  }

  // Métodos auxiliares
  Future<String> _generarCodigoNumerico() async {
    final conn = await connection;
    
    // Generar código entre 1000 y 9999
    int codigo = 1000;
    bool existe = true;
    
    while (existe) {
      final results = await conn.query(
        'SELECT COUNT(*) as count FROM productos WHERE codigo_numerico = ?',
        [codigo.toString()]
      );
      
      if (results.first['count'] == 0) {
        existe = false;
      } else {
        codigo++;
        if (codigo > 9999) {
          throw Exception('No hay códigos numéricos disponibles');
        }
      }
    }
    
    return codigo.toString();
  }

  Future<String> _generarIdProducto(Producto producto) async {
    final conn = await connection;
    
    // Generar base del ID
    String baseId = Producto.generarIdProducto(
      tipo: producto.tipo,
      familia: producto.familia,
      clase: producto.clase,
      modelo: producto.modelo,
      marca: producto.marca,
      presentacion: producto.presentacion,
      color: producto.color,
      capacidad: producto.capacidad,
    );
    
    // Quitar el último carácter (secuencial hardcodeado)
    baseId = baseId.substring(0, baseId.length - 1);
    
    // Encontrar el próximo secuencial
    final results = await conn.query(
      'SELECT MAX(CAST(SUBSTRING(id_generado, ?, 1) AS UNSIGNED)) as max_seq FROM productos WHERE id_generado LIKE ?',
      [baseId.length + 1, '$baseId%']
    );
    
    int secuencial = 1;
    if (results.first['max_seq'] != null) {
      secuencial = results.first['max_seq'] + 1;
    }
    
    return '$baseId$secuencial';
  }

  Future<void> close() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }
}
