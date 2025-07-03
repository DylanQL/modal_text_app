import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/inventario_provider.dart';
import '../models/producto.dart';

class StockManagementScreen extends StatefulWidget {
  final Producto? producto;

  const StockManagementScreen({
    super.key,
    this.producto,
  });

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _cantidadController = TextEditingController();
  
  String _tipoMovimiento = 'ENTRADA';
  Producto? _productoSeleccionado;
  bool _isLoading = false;
  bool _buscandoProducto = false;

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      _productoSeleccionado = widget.producto;
      _codigoController.text = widget.producto!.codigoNumerico;
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Stock'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Información del producto actual
              if (_productoSeleccionado != null) ...[
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Producto Seleccionado',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildProductoInfo('ID:', _productoSeleccionado!.idGenerado),
                        _buildProductoInfo('Familia:', _productoSeleccionado!.familia),
                        _buildProductoInfo('Marca:', _productoSeleccionado!.marca),
                        _buildProductoInfo('Modelo:', _productoSeleccionado!.modelo),
                        _buildProductoInfo('Ubicación:', '${_productoSeleccionado!.rack} - ${_productoSeleccionado!.nivel}'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _productoSeleccionado!.stockActual > 0 ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Stock Actual: ${_productoSeleccionado!.stockActual}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Campo para código numérico
              TextFormField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: 'Código Numérico del Producto',
                  hintText: 'Ingrese el código numérico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: _buscandoProducto
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _buscarProducto,
                        ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El código es obligatorio';
                  }
                  if (_productoSeleccionado == null) {
                    return 'Debe buscar y seleccionar un producto válido';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.length >= 4) {
                    _buscarProducto();
                  } else {
                    setState(() {
                      _productoSeleccionado = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Tipo de movimiento
              Text(
                'Tipo de Movimiento',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Entrada'),
                      subtitle: const Text('Aumentar stock'),
                      value: 'ENTRADA',
                      groupValue: _tipoMovimiento,
                      onChanged: (value) {
                        setState(() {
                          _tipoMovimiento = value!;
                        });
                      },
                      tileColor: Colors.green.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Salida'),
                      subtitle: const Text('Disminuir stock'),
                      value: 'SALIDA',
                      groupValue: _tipoMovimiento,
                      onChanged: (value) {
                        setState(() {
                          _tipoMovimiento = value!;
                        });
                      },
                      tileColor: Colors.red.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Cantidad
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  hintText: 'Ingrese la cantidad',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(
                    _tipoMovimiento == 'ENTRADA' ? Icons.add : Icons.remove,
                    color: _tipoMovimiento == 'ENTRADA' ? Colors.green : Colors.red,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La cantidad es obligatoria';
                  }
                  
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad <= 0) {
                    return 'Ingrese una cantidad válida mayor a 0';
                  }
                  
                  if (_tipoMovimiento == 'SALIDA' && _productoSeleccionado != null) {
                    if (cantidad > _productoSeleccionado!.stockActual) {
                      return 'No hay suficiente stock disponible';
                    }
                  }
                  
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Simulación del resultado
              if (_productoSeleccionado != null && _cantidadController.text.isNotEmpty) ...[
                Card(
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resultado de la Operación',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Stock actual: ${_productoSeleccionado!.stockActual}'),
                        Text('${_tipoMovimiento == 'ENTRADA' ? 'Sumar' : 'Restar'}: ${_cantidadController.text}'),
                        const Divider(),
                        Text(
                          'Stock resultante: ${_calcularStockResultante()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _calcularStockResultante() >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading || _productoSeleccionado == null 
                          ? null 
                          : _actualizarStock,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _tipoMovimiento == 'ENTRADA' ? Colors.green : Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(_tipoMovimiento == 'ENTRADA' ? 'Agregar Stock' : 'Quitar Stock'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductoInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calcularStockResultante() {
    if (_productoSeleccionado == null || _cantidadController.text.isEmpty) {
      return 0;
    }
    
    final cantidad = int.tryParse(_cantidadController.text) ?? 0;
    if (_tipoMovimiento == 'ENTRADA') {
      return _productoSeleccionado!.stockActual + cantidad;
    } else {
      return _productoSeleccionado!.stockActual - cantidad;
    }
  }

  Future<void> _buscarProducto() async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) return;

    setState(() {
      _buscandoProducto = true;
    });

    final provider = Provider.of<InventarioProvider>(context, listen: false);
    final producto = await provider.buscarProductoPorCodigo(codigo);

    setState(() {
      _buscandoProducto = false;
      _productoSeleccionado = producto;
    });

    if (producto == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto no encontrado'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _actualizarStock() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<InventarioProvider>(context, listen: false);
    final cantidad = int.parse(_cantidadController.text);
    
    final success = await provider.actualizarStock(
      _codigoController.text,
      cantidad,
      _tipoMovimiento,
    );

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stock actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar stock: ${provider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
