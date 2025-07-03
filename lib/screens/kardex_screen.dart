import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/inventario_provider.dart';
import '../models/movimiento_kardex.dart';

class KardexScreen extends StatefulWidget {
  final String tipoProducto;
  final String titulo;

  const KardexScreen({
    super.key,
    required this.tipoProducto,
    required this.titulo,
  });

  @override
  State<KardexScreen> createState() => _KardexScreenState();
}

class _KardexScreenState extends State<KardexScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<InventarioProvider>(context, listen: false);
              if (widget.tipoProducto == 'ProductoTerminado') {
                provider.cargarKardexTerminados();
              } else {
                provider.cargarKardexMaterias();
              }
            },
          ),
        ],
      ),
      body: Consumer<InventarioProvider>(
        builder: (context, provider, child) {
          final movimientos = widget.tipoProducto == 'ProductoTerminado'
              ? provider.kardexTerminados
              : provider.kardexMaterias;

          final movimientosFiltrados = _searchQuery.isEmpty
              ? movimientos
              : movimientos.where((movimiento) =>
                  movimiento.producto.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  movimiento.tipoMovimiento.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  movimiento.rack.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

          return Column(
            children: [
              // Estadísticas rápidas
              Container(
                margin: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatChip(
                            'Total Movimientos',
                            movimientos.length.toString(),
                            Icons.swap_horiz,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatChip(
                            'Entradas',
                            movimientos.where((m) => m.tipoMovimiento == 'ENTRADA').length.toString(),
                            Icons.add_circle,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatChip(
                            'Salidas',
                            movimientos.where((m) => m.tipoMovimiento == 'SALIDA').length.toString(),
                            Icons.remove_circle,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por producto, tipo o ubicación...',
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Lista de movimientos
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : movimientosFiltrados.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'No hay movimientos registrados'
                                      : 'No se encontraron movimientos',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (_searchQuery.isEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Los movimientos aparecerán aquí cuando gestiones el stock',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: movimientosFiltrados.length,
                            itemBuilder: (context, index) {
                              final movimiento = movimientosFiltrados[index];
                              return _buildMovimientoCard(context, movimiento);
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMovimientoCard(BuildContext context, MovimientoKardex movimiento) {
    final isEntrada = movimiento.tipoMovimiento == 'ENTRADA';
    final color = isEntrada ? Colors.green : Colors.red;
    final icon = isEntrada ? Icons.add_circle : Icons.remove_circle;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                movimiento.producto,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${isEntrada ? '+' : '-'}${movimiento.cantidad}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _dateFormat.format(movimiento.fecha),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${movimiento.rack} - ${movimiento.nivel}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Stock: ${movimiento.stockResultado}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _mostrarDetallesMovimiento(context, movimiento),
      ),
    );
  }

  void _mostrarDetallesMovimiento(BuildContext context, MovimientoKardex movimiento) {
    final isEntrada = movimiento.tipoMovimiento == 'ENTRADA';
    final color = isEntrada ? Colors.green : Colors.red;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isEntrada ? Icons.add_circle : Icons.remove_circle,
              color: color,
            ),
            const SizedBox(width: 8),
            Text('Detalle del Movimiento'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID Movimiento:', '#${movimiento.idMovimiento ?? 'N/A'}'),
            _buildDetailRow('Producto:', movimiento.producto),
            _buildDetailRow('Tipo:', movimiento.tipoMovimiento),
            _buildDetailRow('Cantidad:', '${isEntrada ? '+' : '-'}${movimiento.cantidad}'),
            _buildDetailRow('Fecha:', _dateFormat.format(movimiento.fecha)),
            _buildDetailRow('Ubicación:', '${movimiento.rack} - ${movimiento.nivel}'),
            _buildDetailRow('Stock Resultante:', '${movimiento.stockResultado}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
}
