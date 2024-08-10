import 'dart:convert';

import 'package:flutter_prueba_visorus/class/categoria.dart';
import 'package:http/http.dart' as http;

class CrudCategoria {
  static const _apiURL = "https://basic3.visorus.com.mx/";
  CrudCategoria._();

  static Future<List<Categoria>> getListCategoria() async {
    List<Categoria> listaCategoria = [];
    try {
      final response = await http.get(Uri.parse('$_apiURL/categoria'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('data')) {
          List<dynamic> data = jsonResponse['data'];

          listaCategoria =
              data.map((item) => Categoria.fromJson(item)).toList();
        } else {
          throw Exception('No se encontraron categorías en la respuesta');
        }
      } else {
        throw Exception('Error al cargar las categorías');
      }
    } catch (e) {
      print("Error getListaCategoria: ${e.toString()}");
    }
    return listaCategoria;
  }

  static Future<Categoria?> getCategoria({required String id}) async {
    try {
      final response = await http.get(Uri.parse('$_apiURL/categoria/$id'));

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return Categoria.fromJson(data);
        } catch (e) {
          print('Error al parsear el JSON: $e');
          throw Exception('Error al parsear la categoría');
        }
      } else if (response.statusCode == 404) {
        print('Categoría no encontrada');
        return null;
      } else {
        throw Exception('Error al cargar la categoría: ${response.statusCode}');
      }
    } catch (e) {
      print("Error getCategoria: ${e.toString()}");
      rethrow;
    }
  }

  static Future<void> postCategoria({required Categoria categoria}) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiURL/categoria'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(categoria.toJson()),
      );

      if (response.statusCode != 201) {
        final errorBody = jsonDecode(response.body);
        throw Exception('Error al crear la categoría: ${errorBody['message']}');
      }
    } catch (e) {
      print('Error al crear la categoría: $e');
    }
  }

  static Future<void> putCategoria({required Categoria categoria}) async {
    try {
      final response = await http.put(
        Uri.parse('$_apiURL/categoria/${categoria.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(categoria.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Error al actualizar la categoría');
      }
    } catch (e) {
      print("Error putCategoria: ${e.toString()}");
    }
  }

  static Future<void> deleteCategoria({required int idCategoria}) async {
    try {
      final response =
          await http.delete(Uri.parse('$_apiURL/categoria/$idCategoria'));
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar la categoría');
      }
    } catch (e) {
      print("Error deleteCategoria: ${e.toString()}");
    }
  }

  static Future<void> patchCategoria({
    required int idCategoria,
    required CategoriaEditing editDato,
    required dynamic newValue,
  }) async {
    String parametro = '';

    switch (editDato) {
      case CategoriaEditing.clave:
        parametro = 'clave';
        break;
      case CategoriaEditing.fechaCreado:
        parametro = 'fechaCreado';
        break;
      case CategoriaEditing.nombre:
        parametro = 'nombre';
        break;
      case CategoriaEditing.activo:
        parametro = 'activo';
        break;
      default:
        throw Exception('Error al seleccionar el dato a editar');
    }

    final uri = Uri.parse('$_apiURL/categoria/$idCategoria');
    final body = jsonEncode({
      parametro: newValue,
    });
    try {
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        throw Exception(
            'Error al modificar la categoría: ${errorBody['message']}');
      }
    } catch (e) {
      print("Error patchCategoria: ${e.toString()}");
    }
  }
}
