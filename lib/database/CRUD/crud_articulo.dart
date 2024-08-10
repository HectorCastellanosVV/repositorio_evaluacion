import 'dart:convert';

import 'package:flutter_prueba_visorus/class/articulo.dart';
import 'package:http/http.dart' as http;

class CrudArticulo {
  static const _apiURL = "https://basic3.visorus.com.mx/";
  CrudArticulo._();

  static Future<List<Articulo>> getListArticulo() async {
    List<Articulo> listaArticulo = [];
    try {
      final response = await http.get(Uri.parse('$_apiURL/articulo'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('data')) {
          List<dynamic> data = jsonResponse['data'];
          listaArticulo = data.map((item) => Articulo.fromJson(item)).toList();
        }
      } else {
        throw Exception("Error al cargar listaArticulo");
      }
    } catch (e) {
      print("Error getListaArticulo ${e.toString()}");
    }
    return listaArticulo;
  }

  static Future<Articulo> getArticulo({required String idArticulo}) async {
    Articulo articulo = Articulo();
    try {
      final response =
          await http.get(Uri.parse('$_apiURL/articulo/$idArticulo'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Articulo.fromJson(data);
      } else {
        throw Exception("Error al cargar articulo");
      }
    } catch (e) {
      print("Error getArticulo ${e.toString()}");
    }
    return articulo;
  }

  static Future<void> postArticulo({required Articulo articulo}) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiURL/articulo'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(articulo.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear artículo: ${response.body}');
      }
    } catch (e) {
      print('Error en postArticulo: ${e.toString()}');
    }
  }

  static Future<void> putArticulo({required Articulo articulo}) async {
    try {
      final response =
          await http.put(Uri.parse("$_apiURL/articulo/${articulo.id}"),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(articulo.toJson()));
      print(jsonEncode(articulo.toJson()));

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar el articulo');
      }
    } catch (e) {
      print("Error en putArticulo: ${e.toString()}");
    }
  }

  static Future<void> deleteArticulo({required int idArticulo}) async {
    try {
      final response =
          await http.delete(Uri.parse("$_apiURL/articulo/$idArticulo"));
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar articulo");
      }
    } catch (e) {
      print("Error en deleteArticulo: ${e.toString()}");
    }
  }

  static Future<void> patchArticulo({
    required String idArticulo,
    required ArticuloEditing editType,
    required dynamic newValue,
  }) async {
    String parametro = '';
    dynamic body;

    try {
      switch (editType) {
        case ArticuloEditing.clave:
          parametro = 'clave';
          body = {parametro: newValue};
          break;
        case ArticuloEditing.nombre:
          parametro = 'nombre';
          body = {parametro: newValue};
          break;
        case ArticuloEditing.activo:
          parametro = 'activo';
          body = {parametro: newValue};
          break;
        case ArticuloEditing.precios:
          parametro = 'precios';
          body = {
            parametro: newValue.map((precio) => precio.toJson()).toList()
          };
          break;
        case ArticuloEditing.categoria:
          parametro = 'categoria';
          body = {
            parametro: {"id": newValue}
          };
          break;
        default:
          throw Exception('Error al seleccionar el dato a editar');
      }

      final response = await http.patch(
        Uri.parse('$_apiURL/articulo/$idArticulo'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al modificar artículo: ${response.body}');
      }
    } catch (e) {
      print("Error patchArticulo: ${e.toString()}");
    }
  }
}
