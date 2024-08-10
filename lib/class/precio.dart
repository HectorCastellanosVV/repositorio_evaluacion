class Precio {
  double? precio;
  Precio({this.precio});
  factory Precio.fromJson(Map<String, dynamic> datos) {
    return Precio(precio: datos['Precio']);
  }
  Map<String, dynamic> toJson() {
    return {
      'precio': precio,
    };
  }
}
