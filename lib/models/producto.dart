class Producto {
  final int? id;
  final String idGenerado;
  final String tipo; // 'ProductoTerminado' o 'MateriaPrima'
  final String familia;
  final String clase;
  final String modelo;
  final String marca;
  final String presentacion;
  final String color;
  final String capacidad;
  final String unidadVenta;
  final String rack;
  final String nivel;
  final String codigoNumerico;
  final String? imagen;
  final int stockActual;

  Producto({
    this.id,
    required this.idGenerado,
    required this.tipo,
    required this.familia,
    required this.clase,
    required this.modelo,
    required this.marca,
    required this.presentacion,
    required this.color,
    required this.capacidad,
    required this.unidadVenta,
    required this.rack,
    required this.nivel,
    required this.codigoNumerico,
    this.imagen,
    this.stockActual = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_generado': idGenerado,
      'tipo': tipo,
      'familia': familia,
      'clase': clase,
      'modelo': modelo,
      'marca': marca,
      'presentacion': presentacion,
      'color': color,
      'capacidad': capacidad,
      'unidad_venta': unidadVenta,
      'rack': rack,
      'nivel': nivel,
      'codigo_numerico': codigoNumerico,
      'imagen': imagen,
      'stock_actual': stockActual,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'],
      idGenerado: map['id_generado'] ?? '',
      tipo: map['tipo'] ?? '',
      familia: map['familia'] ?? '',
      clase: map['clase'] ?? '',
      modelo: map['modelo'] ?? '',
      marca: map['marca'] ?? '',
      presentacion: map['presentacion'] ?? '',
      color: map['color'] ?? '',
      capacidad: map['capacidad'] ?? '',
      unidadVenta: map['unidad_venta'] ?? '',
      rack: map['rack'] ?? '',
      nivel: map['nivel'] ?? '',
      codigoNumerico: map['codigo_numerico'] ?? '',
      imagen: map['imagen'],
      stockActual: map['stock_actual'] ?? 0,
    );
  }

  static String generarIdProducto({
    required String tipo,
    required String familia,
    required String clase,
    required String modelo,
    required String marca,
    required String presentacion,
    required String color,
    required String capacidad,
    required String unidadVenta,
  }) {
    // Tomar la primera letra o número de cada campo
    String familiaCode = familia.isNotEmpty ? familia.substring(0, 1).toUpperCase() : '';
    String claseCode = clase.isNotEmpty ? clase.substring(0, 1).toUpperCase() : '';
    String modeloCode = modelo.isNotEmpty ? modelo.substring(0, 1).toUpperCase() : '';
    String marcaCode = marca.isNotEmpty ? marca.substring(0, 1).toUpperCase() : '';
    String presentacionCode = presentacion.isNotEmpty ? presentacion.substring(0, 1).toUpperCase() : '';
    String colorCode = color.isNotEmpty ? color.substring(0, 1).toUpperCase() : '';
    String capacidadCode = capacidad.isNotEmpty ? capacidad.substring(0, 1).toUpperCase() : '';
    String unidadVentaCode = unidadVenta.isNotEmpty ? unidadVenta.substring(0, 1).toUpperCase() : '';
    
    return '$familiaCode$claseCode$modeloCode$marcaCode$presentacionCode$colorCode$capacidadCode$unidadVentaCode';
  }

  Producto copyWith({
    int? id,
    String? idGenerado,
    String? tipo,
    String? familia,
    String? clase,
    String? modelo,
    String? marca,
    String? presentacion,
    String? color,
    String? capacidad,
    String? unidadVenta,
    String? rack,
    String? nivel,
    String? codigoNumerico,
    String? imagen,
    int? stockActual,
  }) {
    return Producto(
      id: id ?? this.id,
      idGenerado: idGenerado ?? this.idGenerado,
      tipo: tipo ?? this.tipo,
      familia: familia ?? this.familia,
      clase: clase ?? this.clase,
      modelo: modelo ?? this.modelo,
      marca: marca ?? this.marca,
      presentacion: presentacion ?? this.presentacion,
      color: color ?? this.color,
      capacidad: capacidad ?? this.capacidad,
      unidadVenta: unidadVenta ?? this.unidadVenta,
      rack: rack ?? this.rack,
      nivel: nivel ?? this.nivel,
      codigoNumerico: codigoNumerico ?? this.codigoNumerico,
      imagen: imagen ?? this.imagen,
      stockActual: stockActual ?? this.stockActual,
    );
  }
}
