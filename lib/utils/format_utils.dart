import 'package:intl/intl.dart';

class FormatUtils {
  // Formateadores de fecha
  static final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
  static final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat timeFormatter = DateFormat('HH:mm');
  
  // Formatear fecha
  static String formatDate(DateTime date) {
    return dateFormatter.format(date);
  }
  
  // Formatear fecha y hora
  static String formatDateTime(DateTime date) {
    return dateTimeFormatter.format(date);
  }
  
  // Formatear hora
  static String formatTime(DateTime date) {
    return timeFormatter.format(date);
  }
  
  // Formatear stock con colores
  static String formatStock(int stock) {
    if (stock < 0) return 'Stock: $stock (Negativo)';
    if (stock == 0) return 'Stock: $stock (Agotado)';
    if (stock < 10) return 'Stock: $stock (Bajo)';
    return 'Stock: $stock';
  }
  
  // Capitalizar primera letra
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  // Formatear ID generado para mostrar
  static String formatIdGenerado(String id) {
    if (id.length < 10) return id;
    // Dividir en grupos para mejor legibilidad
    return '${id.substring(0, 2)}-${id.substring(2, 4)}-${id.substring(4, 6)}-${id.substring(6)}';
  }
  
  // Validar código numérico
  static bool isValidCodigoNumerico(String codigo) {
    if (codigo.isEmpty) return false;
    final numericRegex = RegExp(r'^\d{4,6}$');
    return numericRegex.hasMatch(codigo);
  }
  
  // Validar URL de imagen
  static bool isValidImageUrl(String url) {
    if (url.isEmpty) return true; // Es opcional
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}
