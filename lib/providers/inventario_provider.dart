import 'package:flutter/foundation.dart';
import '../models/producto.dart';
import '../models/movimiento_kardex.dart';
import '../services/database_service.dart';

class InventarioProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  
  List<Producto> _productosTerminados = [];
  List<Producto> _materiasPrimas = [];
  List<MovimientoKardex> _kardexTerminados = [];
  List<MovimientoKardex> _kardexMaterias = [];
  
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Producto> get productosTerminados => _productosTerminados;
  List<Producto> get materiasPrimas => _materiasPrimas;
  List<MovimientoKardex> get kardexTerminados => _kardexTerminados;
  List<MovimientoKardex> get kardexMaterias => _kardexMaterias;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Inicializar base de datos
  Future<void> initializeDatabase() async {
    try {
      _setLoading(true);
      await _db.initializeDatabase();
      await cargarDatos();
    } catch (e) {
      _setError('Error al inicializar base de datos: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Cargar todos los datos
  Future<void> cargarDatos() async {
    try {
      _setLoading(true);
      _clearError();
      
      await Future.wait([
        cargarProductosTerminados(),
        cargarMateriasPrimas(),
        cargarKardexTerminados(),
        cargarKardexMaterias(),
      ]);
    } catch (e) {
      _setError('Error al cargar datos: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Productos Terminados
  Future<void> cargarProductosTerminados() async {
    try {
      _productosTerminados = await _db.obtenerProductos(tipo: 'ProductoTerminado');
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar productos terminados: $e');
    }
  }

  // Materias Primas
  Future<void> cargarMateriasPrimas() async {
    try {
      _materiasPrimas = await _db.obtenerProductos(tipo: 'MateriaPrima');
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar materias primas: $e');
    }
  }

  // Kardex
  Future<void> cargarKardexTerminados() async {
    try {
      _kardexTerminados = await _db.obtenerKardex(tipoProducto: 'ProductoTerminado');
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar kardex de productos terminados: $e');
    }
  }

  Future<void> cargarKardexMaterias() async {
    try {
      _kardexMaterias = await _db.obtenerKardex(tipoProducto: 'MateriaPrima');
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar kardex de materias primas: $e');
    }
  }

  // Crear producto
  Future<bool> crearProducto(Producto producto) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _db.insertarProducto(producto);
      
      // Recargar la lista correspondiente
      if (producto.tipo == 'ProductoTerminado') {
        await cargarProductosTerminados();
      } else {
        await cargarMateriasPrimas();
      }
      
      return true;
    } catch (e) {
      _setError('Error al crear producto: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar stock
  Future<bool> actualizarStock(String codigoNumerico, int cantidad, String tipoMovimiento) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _db.actualizarStock(codigoNumerico, cantidad, tipoMovimiento);
      
      // Recargar datos
      await cargarDatos();
      
      return true;
    } catch (e) {
      _setError('Error al actualizar stock: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Buscar producto por código
  Future<Producto?> buscarProductoPorCodigo(String codigoNumerico) async {
    try {
      _clearError();
      return await _db.obtenerProductoPorCodigo(codigoNumerico);
    } catch (e) {
      _setError('Error al buscar producto: $e');
      return null;
    }
  }

  // Eliminar producto
  Future<bool> eliminarProducto(int id, String tipo) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _db.eliminarProducto(id);
      
      // Recargar la lista correspondiente
      if (tipo == 'ProductoTerminado') {
        await cargarProductosTerminados();
      } else {
        await cargarMateriasPrimas();
      }
      
      // Recargar kardex también
      await cargarKardexTerminados();
      await cargarKardexMaterias();
      
      return true;
    } catch (e) {
      _setError('Error al eliminar producto: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Métodos auxiliares
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
