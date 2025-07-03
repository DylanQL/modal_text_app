import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventario_provider.dart';
import 'productos_screen.dart';
import 'kardex_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Inventario'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Consumer<InventarioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error de conexión',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.initializeDatabase();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header con estadísticas
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Resumen del Inventario',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                'Productos Terminados',
                                provider.productosTerminados.length.toString(),
                                Icons.inventory,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                'Materias Primas',
                                provider.materiasPrimas.length.toString(),
                                Icons.category,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sección de Productos
                Text(
                  'Gestión de Productos',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildMenuCard(
                        context,
                        'Productos Terminados',
                        'Gestionar productos terminados',
                        Icons.inventory_2,
                        Colors.blue,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductosScreen(
                              tipoProducto: 'ProductoTerminado',
                              titulo: 'Productos Terminados',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMenuCard(
                        context,
                        'Materias Primas',
                        'Gestionar materias primas',
                        Icons.category,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductosScreen(
                              tipoProducto: 'MateriaPrima',
                              titulo: 'Materias Primas',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Sección de Kardex
                Text(
                  'Kardex de Movimientos',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildMenuCard(
                        context,
                        'Kardex Productos',
                        'Ver movimientos de productos terminados',
                        Icons.assignment,
                        Colors.orange,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KardexScreen(
                              tipoProducto: 'ProductoTerminado',
                              titulo: 'Kardex - Productos Terminados',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMenuCard(
                        context,
                        'Kardex Materias',
                        'Ver movimientos de materias primas',
                        Icons.list_alt,
                        Colors.purple,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KardexScreen(
                              tipoProducto: 'MateriaPrima',
                              titulo: 'Kardex - Materias Primas',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 48),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
