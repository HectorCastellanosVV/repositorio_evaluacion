class Categoria {
  String? clave;
  int? id;
  int? fechaCreado;
  String? nombre;
  bool? activo;
  Categoria({
    this.id,
    this.clave,
    this.fechaCreado,
    this.nombre,
    this.activo,
  });

  factory Categoria.fromJson(Map<String, dynamic> datos) {
    return Categoria(
      id: datos['id'],
      clave: datos['clave'],
      fechaCreado: datos['fechaCreado'],
      nombre: datos['nombre'],
      activo: datos['activo'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'clave': clave,
      'fechaCreado': fechaCreado,
      'nombre': nombre,
      'activo': activo,
    };
  }
}

enum CategoriaEditing { clave, fechaCreado, nombre, activo }
