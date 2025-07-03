import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    // Generar preview dinámico mientras el usuario escribe
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
        unidadVenta: _unidadVentaController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Crear ${widget.tipoProducto == 'ProductoTerminado' ? 'Producto Terminado' : 'Materia Prima'}'),
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.preview, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ID Generado (Vista Previa):',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _idGeneradoPreview,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

            // Formulario
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: _familiaController,
                        label: 'Familia *',
                        icon: Icons.category,
                        onChanged: (_) => _updateIdPreview(),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _claseController,
                        label: 'Clase *',
                        icon: Icons.class_,
                        onChanged: (_) => _updateIdPreview(),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _modeloController,
                        label: 'Modelo *',
                        icon: Icons.device_hub,
                        onChanged: (_) => _updateIdPreview(),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _marcaController,
                        label: 'Marca *',
                        icon: Icons.branding_watermark,
                        onChanged: (_) => _updateIdPreview(),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _presentacionController,
                        label: 'Presentación *',
                        icon: Icons.style,
                        onChanged: (_) => _updateIdPreview(),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _colorController,
                        label: 'Color *',
                        icon: Icons.color_lens,
                        onChanged: (_) => _updateIdPreview(),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _capacidadController,
                        label: 'Capacidad *',
                        icon: Icons.storage,
                        onChanged: (_) => _updateIdPreview(),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _unidadVentaController,
                        label: 'Unidad de Venta *',
                        icon: Icons.shopping_cart,
                        onChanged: (_) => _updateIdPreview(),
                      ),
                      const SizedBox(height: 20),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _rackController,
                              label: 'Rack *',
                              icon: Icons.shelves,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _nivelController,
                              label: 'Nivel *',
                              icon: Icons.layers,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      _buildTextField(
                        controller: _imagenController,
                        label: 'URL de Imagen (Opcional)',
                        icon: Icons.image,
                        required: false,
                        onChanged: (value) {
                          setState(() {
                            // Trigger rebuild para mostrar preview
                          });
                        },
                      ),
                      
                      // Preview de imagen
                      if (_imagenController.text.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildImagePreview(_imagenController.text),
                      ],
                      
                      const SizedBox(height: 40),
                      
                      // Botones
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isCreating ? null : () => Navigator.pop(context),
                              icon: const Icon(Icons.cancel),
                              label: const Text('Cancelar'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.grey[400]!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isCreating ? null : _crearProducto,
                              icon: _isCreating
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.add),
                              label: Text(_isCreating ? 'Creando...' : 'Crear Producto'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
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
    IconData? icon,
    bool required = true,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.blue[600]) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      ),
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

  Widget _buildImagePreview(String imageUrl) {
    if (imageUrl.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vista Previa de la Imagen:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 220,
              maxWidth: 280,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.blue[600],
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cargando...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'URL inválida',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Verifica que la URL sea correcta',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
