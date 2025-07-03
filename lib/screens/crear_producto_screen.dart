import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventario_provider.dart';
import '../models/producto.dart';

class CrearProductoScreen extends StatefulWidget {
  final String tipoProducto;

  const CrearProductoScreen({
    super.key,
    required this.tipoProducto,
  });

  @override
  State<CrearProductoScreen> createState() => _CrearProductoScreenState();
}

class _CrearProductoScreenState extends State<CrearProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controladores para los campos
  final _familiaController = TextEditingController();
  final _claseController = TextEditingController();
  final _modeloController = TextEditingController();
  final _marcaController = TextEditingController();
  final _presentacionController = TextEditingController();
  final _colorController = TextEditingController();
  final _capacidadController = TextEditingController();
  final _unidadVentaController = TextEditingController();
  final _rackController = TextEditingController();
  final _nivelController = TextEditingController();
  final _imagenController = TextEditingController();

  bool _isCreating = false;
  String _idGeneradoPreview = '';

  @override
  void dispose() {
    _familiaController.dispose();
    _claseController.dispose();
    _modeloController.dispose();
    _marcaController.dispose();
    _presentacionController.dispose();
    _colorController.dispose();
    _capacidadController.dispose();
    _unidadVentaController.dispose();
    _rackController.dispose();
    _nivelController.dispose();
    _imagenController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateIdPreview() {
    if (_familiaController.text.isNotEmpty &&
        _claseController.text.isNotEmpty &&
        _modeloController.text.isNotEmpty &&
        _marcaController.text.isNotEmpty &&
        _presentacionController.text.isNotEmpty &&
        _colorController.text.isNotEmpty &&
        _capacidadController.text.isNotEmpty) {
      
      setState(() {
        _idGeneradoPreview = Producto.generarIdProducto(
          tipo: widget.tipoProducto,
          familia: _familiaController.text,
          clase: _claseController.text,
          modelo: _modeloController.text,
          marca: _marcaController.text,
          presentacion: _presentacionController.text,
          color: _colorController.text,
          capacidad: _capacidadController.text,
        );
      });
    } else {
      setState(() {
        _idGeneradoPreview = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear ${widget.tipoProducto == 'ProductoTerminado' ? 'Producto Terminado' : 'Materia Prima'}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Preview del ID generado
            if (_idGeneradoPreview.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID Generado (Vista Previa):',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _idGeneradoPreview,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // Formulario
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _familiaController,
                      label: 'Familia *',
                      hint: 'Ej: Electrónicos, Textiles, etc.',
                      onChanged: (_) => _updateIdPreview(),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _claseController,
                      label: 'Clase *',
                      hint: 'Ej: Audio, Video, etc.',
                      onChanged: (_) => _updateIdPreview(),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _modeloController,
                      label: 'Modelo *',
                      hint: 'Ej: MP3, MP4, etc.',
                      onChanged: (_) => _updateIdPreview(),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _marcaController,
                      label: 'Marca *',
                      hint: 'Ej: Apple, Samsung, etc.',
                      onChanged: (_) => _updateIdPreview(),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _presentacionController,
                      label: 'Presentación *',
                      hint: 'Ej: Slim, Compact, etc.',
                      onChanged: (_) => _updateIdPreview(),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _colorController,
                      label: 'Color *',
                      hint: 'Ej: Silver, Black, etc.',
                      onChanged: (_) => _updateIdPreview(),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _capacidadController,
                      label: 'Capacidad *',
                      hint: 'Ej: 16GB, 32GB, etc.',
                      onChanged: (_) => _updateIdPreview(),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _unidadVentaController,
                      label: 'Unidad de Venta *',
                      hint: 'Ej: Unidad, Caja, Paquete, etc.',
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _rackController,
                            label: 'Rack *',
                            hint: 'Ej: A1, B2, etc.',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _nivelController,
                            label: 'Nivel *',
                            hint: 'Ej: 1, 2, 3, etc.',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _imagenController,
                      label: 'URL de Imagen (Opcional)',
                      hint: 'https://ejemplo.com/imagen.jpg',
                      required: false,
                    ),
                    const SizedBox(height: 32),
                    
                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isCreating ? null : () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isCreating ? null : _crearProducto,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: _isCreating
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Crear Producto'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = true,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            }
          : null,
      onChanged: onChanged,
    );
  }

  Future<void> _crearProducto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    final producto = Producto(
      idGenerado: '', // Será generado en el servicio
      tipo: widget.tipoProducto,
      familia: _familiaController.text.trim(),
      clase: _claseController.text.trim(),
      modelo: _modeloController.text.trim(),
      marca: _marcaController.text.trim(),
      presentacion: _presentacionController.text.trim(),
      color: _colorController.text.trim(),
      capacidad: _capacidadController.text.trim(),
      unidadVenta: _unidadVentaController.text.trim(),
      rack: _rackController.text.trim(),
      nivel: _nivelController.text.trim(),
      codigoNumerico: '', // Será generado en el servicio
      imagen: _imagenController.text.trim().isEmpty ? null : _imagenController.text.trim(),
      stockActual: 0,
    );

    final provider = Provider.of<InventarioProvider>(context, listen: false);
    final success = await provider.crearProducto(producto);

    setState(() {
      _isCreating = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear producto: ${provider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
