import 'dart:io';
import '../services/database_service.dart';

class DatabaseHelper {
  static Future<bool> checkMySQLConnection() async {
    try {
      print('🔍 Verificando conexión a MySQL...');
      
      // Intentar conectar al servicio de base de datos
      final dbService = DatabaseService.instance;
      await dbService.connection;
      
      print('✅ Conexión a MySQL exitosa');
      return true;
    } catch (e) {
      print('❌ Error de conexión a MySQL: $e');
      return false;
    }
  }
  
  static Future<bool> initializeDatabase() async {
    try {
      print('🚀 Inicializando base de datos...');
      
      final dbService = DatabaseService.instance;
      await dbService.initializeDatabase();
      
      print('✅ Base de datos inicializada correctamente');
      return true;
    } catch (e) {
      print('❌ Error al inicializar base de datos: $e');
      return false;
    }
  }
  
  static Future<void> showSystemInfo() async {
    print('📱 === INFORMACIÓN DEL SISTEMA ===');
    print('SO: ${Platform.operatingSystem}');
    print('Versión: ${Platform.operatingSystemVersion}');
    print('Arquitectura: ${Platform.localeName}');
    
    print('\n🗄️ === CONFIGURACIÓN DE BASE DE DATOS ===');
    print('Host: localhost');
    print('Puerto: 3306');
    print('Base de datos: suan_app');
    print('Usuario: root');
    
    final isConnected = await checkMySQLConnection();
    print('Estado de conexión: ${isConnected ? "Conectado ✅" : "Desconectado ❌"}');
    
    if (isConnected) {
      print('\n🏗️ Intentando inicializar base de datos...');
      final isInitialized = await initializeDatabase();
      print('Base de datos: ${isInitialized ? "Inicializada ✅" : "Error de inicialización ❌"}');
    }
  }
  
  static Future<void> createExampleData() async {
    try {
      print('📝 Creando datos de ejemplo...');
      
      final dbService = DatabaseService.instance;
      final conn = await dbService.connection;
      
      // Verificar si ya existen datos
      final result = await conn.query('SELECT COUNT(*) as count FROM productos');
      final count = result.first['count'] as int;
      
      if (count > 0) {
        print('⚠️ Ya existen $count productos en la base de datos');
        return;
      }
      
      // Insertar datos de ejemplo solo si no existen
      await conn.query('''
        INSERT INTO productos (
          id_generado, tipo, familia, clase, modelo, marca, 
          presentacion, color, capacidad, unidad_venta, 
          rack, nivel, codigo_numerico, stock_actual
        ) VALUES 
        (
          'PRELEMP3NAAPSI16G1', 
          'ProductoTerminado', 
          'Electronica', 
          'Audio', 
          'MP3', 
          'Nano', 
          'Apple', 
          'Slim', 
          'Silver', 
          '16GB', 
          'Unidad', 
          'A1', 
          '1', 
          '1000', 
          50
        ),
        (
          'MATEALCOPLMO11001', 
          'MateriaPrima', 
          'Metal', 
          'Aluminio', 
          'Plancha', 
          'Molina', 
          'Industrial', 
          'Natural', 
          '1mm', 
          'Metro', 
          'B1', 
          '1', 
          '2000', 
          100
        )
      ''');
      
      print('✅ Datos de ejemplo creados exitosamente');
    } catch (e) {
      print('❌ Error al crear datos de ejemplo: $e');
    }
  }
  
  static void printInstructions() {
    print('\n📋 === INSTRUCCIONES DE CONFIGURACIÓN ===');
    print('1. Asegúrate de que MySQL esté instalado y ejecutándose');
    print('2. Crea la base de datos ejecutando:');
    print('   mysql -u root -p -e "CREATE DATABASE suan_app;"');
    print('3. Opcionalmente, ejecuta el script de inicialización:');
    print('   mysql -u root -p suan_app < database/init_database.sql');
    print('4. Reinicia la aplicación');
    print('\n🔧 === SOLUCIÓN DE PROBLEMAS ===');
    print('- Verifica que MySQL esté corriendo: sudo service mysql status');
    print('- Verifica credenciales en lib/services/database_service.dart');
    print('- Asegúrate de que el puerto 3306 esté disponible');
  }
}
