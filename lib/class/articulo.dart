import 'package:flutter_prueba_visorus/class/categoria.dart';
import 'package:flutter_prueba_visorus/class/precio.dart';

class Articulo {
  String? clave;
  int? id;
  Categoria? categoria;
  String? nombre;
  List<Precio>? precios;
  bool? activo;

  Articulo(
      {this.clave,
      this.categoria,
      this.nombre,
      this.precios,
      this.activo,
      this.id});

  factory Articulo.fromJson(Map<String, dynamic> datos) {
    return Articulo(
        id: datos['id'],
        clave: datos['clave'],
        categoria: datos['categoria'] != null
            ? Categoria.fromJson(datos['categoria'])
            : null,
        nombre: datos['nombre'],
        precios: datos['precios'] != null
            ? List<Precio>.from(
                datos['precios'].map((datos) => Precio.fromJson(datos)))
            : null,
        activo: datos['activo']);
  }
  Map<String, dynamic> toJson() {
    return {
      'clave': clave ?? '',
      'categoria': categoria != null ? {'id': categoria!.id ?? 0} : null,
      'nombre': nombre ?? '',
      'precios': precios?.map((item) => item.toJson()).toList() ?? [],
      'activo': activo ?? true,
    };
  }
}

enum ArticuloEditing {
  clave,
  categoria,
  nombre,
  precios,
  activo,
}
