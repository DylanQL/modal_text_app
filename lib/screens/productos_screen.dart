import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/inventario_provider.dart';
import '../models/producto.dart';
import 'crear_producto_screen.dart';
import 'stock_management_screen.dart';

class ProductosScreen extends StatefulWidget {
  final String tipoProducto;
  final String titulo;

  const ProductosScreen({
    super.key,
    required this.tipoProducto,
    required this.titulo,
  });

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<InventarioProvider>(context, listen: false);
              if (widget.tipoProducto == 'ProductoTerminado') {
                provider.cargarProductosTerminados();
              } else {
                provider.cargarMateriasPrimas();
              }
            },
          ),
        ],
      ),
      body: Consumer<InventarioProvider>(
        builder: (context, provider, child) {
          final productos = widget.tipoProducto == 'ProductoTerminado'
              ? provider.productosTerminados
              : provider.materiasPrimas;

          final productosFiltrados = _searchQuery.isEmpty
              ? productos
              : productos.where((producto) =>
                  producto.idGenerado.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  producto.familia.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  producto.marca.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  producto.codigoNumerico.contains(_searchQuery)).toList();

          return Column(
            children: [
              // Barra de búsqueda
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por ID, familia, marca o código...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // Lista de productos
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productosFiltrados.isEmpty
                        ? Container(
                            color: Colors.grey[50],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.all(32),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: 64,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          _searchQuery.isEmpty
                                              ? 'No hay productos registrados'
                                              : 'No se encontraron productos',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (_searchQuery.isEmpty) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            'Presiona el botón + para agregar el primer producto',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Colors.grey[500],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: productosFiltrados.length,
                            itemBuilder: (context, index) {
                              final producto = productosFiltrados[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildProductoCard(context, producto, provider),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearProductoScreen(
                tipoProducto: widget.tipoProducto,
              ),
            ),
          );
          
          if (result == true) {
            // Recargar productos si se creó uno nuevo
            final provider = Provider.of<InventarioProvider>(context, listen: false);
            if (widget.tipoProducto == 'ProductoTerminado') {
              provider.cargarProductosTerminados();
            } else {
              provider.cargarMateriasPrimas();
            }
          }
        },
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProductoCard(BuildContext context, Producto producto, InventarioProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: const ExpansionTileThemeData(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
          ),
        ),
        child: ExpansionTile(
          title: Text(
            producto.idGenerado,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('${producto.familia} - ${producto.marca}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: producto.stockActual > 0 ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Stock: ${producto.stockActual}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      'Código: ${producto.codigoNumerico}',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del producto (lado izquierdo)
                  Expanded(
                    flex: producto.imagen != null && producto.imagen!.isNotEmpty ? 2 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Clase:', producto.clase),
                        _buildDetailRow('Modelo:', producto.modelo),
                        _buildDetailRow('Presentación:', producto.presentacion),
                        _buildDetailRow('Color:', producto.color),
                        _buildDetailRow('Capacidad:', producto.capacidad),
                        _buildDetailRow('Unidad de Venta:', producto.unidadVenta),
                        _buildDetailRow('Ubicación:', '${producto.rack} - ${producto.nivel}'),
                        
                        // Botones de acción (si no hay imagen, se muestran aquí)
                        if (producto.imagen == null || producto.imagen!.isEmpty) ...[
                          const SizedBox(height: 20),
                          _buildActionButtons(context, producto, provider),
                        ],
                      ],
                    ),
                  ),
                  
                  // Imagen del producto (lado derecho)
                  if (producto.imagen != null && producto.imagen!.isNotEmpty) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Imagen:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildCompactProductImage(producto.imagen!),
                          const SizedBox(height: 16),
                          _buildActionButtons(context, producto, provider),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  Widget _buildCompactProductImage(String imageUrl) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 150,
        maxWidth: 200,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
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
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.blue[600],
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cargando...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
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
                  size: 24,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 4),
                Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Producto producto, InventarioProvider provider) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockManagementScreen(
                    producto: producto,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Gestionar Stock'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _confirmarEliminar(context, producto, provider),
            icon: const Icon(Icons.delete, size: 16),
            label: const Text('Eliminar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmarEliminar(BuildContext context, Producto producto, InventarioProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Está seguro de que desea eliminar el producto "${producto.idGenerado}"?\n\n'
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true && producto.id != null) {
      final success = await provider.eliminarProducto(producto.id!, producto.tipo);
      
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto eliminado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar producto: ${provider.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
