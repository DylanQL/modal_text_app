import 'dart:io';

class DatabaseConfig {
  static const String host = 'localhost';
  static const int port = 3306;
  static const String database = 'suan_app';
  static const String username = 'root';
  static const String password = '123456';
  
  // Configuración alternativa para desarrollo
  static const String devHost = '127.0.0.1';
  static const String devDatabase = 'suan_app_dev';
  
  // Función para obtener configuración basada en el entorno
  static Map<String, dynamic> getConfig({bool isDevelopment = false}) {
    return {
      'host': isDevelopment ? devHost : host,
      'port': port,
      'database': isDevelopment ? devDatabase : database,
      'username': username,
      'password': password,
    };
  }
  
  // Función para verificar conectividad
  static Future<bool> testConnection() async {
    try {
      final result = await Process.run('mysql', [
        '-h', host,
        '-P', port.toString(),
        '-u', username,
        '-p$password',
        '-e', 'SELECT 1;'
      ]);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }
}
