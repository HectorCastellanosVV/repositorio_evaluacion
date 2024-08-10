import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_prueba_visorus/class/articulo.dart';
import 'package:flutter_prueba_visorus/class/categoria.dart';
import 'package:flutter_prueba_visorus/class/precio.dart';
import 'package:flutter_prueba_visorus/core/utils/data_validate.dart';
import 'package:flutter_prueba_visorus/database/CRUD/crud_articulo.dart';
import 'package:flutter_prueba_visorus/database/CRUD/crud_categoria.dart';
import 'package:flutter_prueba_visorus/pages/articulos/articulos.dart';
import 'package:flutter_prueba_visorus/test/constants.dart';

class PanelDetalleProducto extends StatefulWidget {
  final String? idArticulo;
  const PanelDetalleProducto({super.key, required this.idArticulo});

  @override
  State<PanelDetalleProducto> createState() => _PanelDetalleProductoState();
}

class _PanelDetalleProductoState extends State<PanelDetalleProducto> {
  TextEditingController cNombre = TextEditingController();
  TextEditingController cPrecio = TextEditingController();
  String valuearticulo = "";
  bool isEditing = false;
  bool valorarticulo = true;
  Articulo? articulo;
  String? idArticulo;
  String? idCatalogo;
  List<Categoria> categorias = [];
  List<Precio> precios = [];
  int value = 1;

  @override
  void initState() {
    super.initState();
    rellenarDatos();
  }

  void rellenarDatos() async {
    categorias = await CrudCategoria.getListCategoria();
    if (widget.idArticulo != null && widget.idArticulo!.isNotEmpty) {
      articulo = await CrudArticulo.getArticulo(idArticulo: widget.idArticulo!);

      if (articulo != null) {
        setState(() {
          idArticulo = articulo!.id.toString();
          cNombre.text = articulo!.nombre ?? '';
          valorarticulo = articulo!.activo ?? true;

          if (articulo!.precios != null && articulo!.precios!.isNotEmpty) {
            cPrecio.text = articulo!.precios![0].precio.toString();
          }
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detalles del producto",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                child: TextButton(
                  onPressed: () async {},
                  child: const Text(
                    'Agregar\nFoto',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Form(
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getPaneles(
                      context: context,
                      titulo: 'Nombre del producto',
                      controller: cNombre,
                      descripcion: "Ingresa el nombre del producto aquí",
                      inputType: TextInputType.name,
                      listaType: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]')),
                        LengthLimitingTextInputFormatter(100),
                      ],
                      errorText: '',
                      funcionValidator: validateTextField,
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Categoría del producto"),
                        Text("Estado del producto"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colorFondo),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<String>(
                            value: idCatalogo,
                            items: [
                              for (final categoria in categorias)
                                DropdownMenuItem<String>(
                                  value: categoria.id!.toString(),
                                  child: Text(categoria.nombre!),
                                )
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  idCatalogo = value;
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colorFondo),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<bool>(
                            value: valorarticulo,
                            items: const [
                              DropdownMenuItem<bool>(
                                value: true,
                                child: Text('Activo',
                                    style: TextStyle(color: colorFondo)),
                              ),
                              DropdownMenuItem<bool>(
                                value: false,
                                child: Text('Desactivo',
                                    style: TextStyle(color: colorFondo)),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  valorarticulo = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    getPaneles2(
                      context: context,
                      titulo: 'Precio del producto \$',
                      controller: cPrecio,
                      descripcion: "0",
                      inputType: TextInputType.phone,
                      listaType: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      errorText: '',
                      funcionValidator: validatePhoneTextField,
                      onPriceSubmitted: handlePriceSubmitted,
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: articulo?.precios?.map((precio) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Text("\$${precio.precio}"),
                                  ),
                                  Positioned(
                                    top: -3,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                          Icons.disabled_by_default_outlined),
                                    ),
                                  ),
                                ],
                              );
                            }).toList() ??
                            [],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                      if (!isEditing) {
                        guardarDatos();
                      }
                    },
                    label: Text(isEditing ? "Guardar" : "Editar"),
                    icon: Image.asset("assets/icons/edit.png"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      eliminarBoton();
                    },
                    label: const Text(
                      "Eliminar",
                      style: TextStyle(color: colorRojo),
                    ),
                    icon: Image.asset("assets/icons/remove.png"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void handlePriceSubmitted(String value) {
    final precio = double.tryParse(value);
    if (precio != null) {
      setState(() {
        precios.add(Precio(precio: precio));
        cPrecio.clear();
      });
    }
  }

  Widget getPaneles2({
    required BuildContext context,
    required String titulo,
    required TextEditingController controller,
    required String descripcion,
    required TextInputType inputType,
    required List<TextInputFormatter> listaType,
    String? errorText,
    FormFieldValidator<String>? funcionValidator,
    required void Function(String) onPriceSubmitted, // Nuevo parámetro
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          cursorColor: colorRojo,
          controller: controller,
          keyboardType: inputType,
          inputFormatters: listaType,
          decoration: InputDecoration(
            errorText: errorText,
            errorStyle: const TextStyle(color: Colors.red),
            hintText: descripcion,
            labelStyle: Theme.of(context).textTheme.bodySmall,
            fillColor: Colors.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors
                    .grey, // Color del borde cuando el campo no está enfocado
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.grey, // Color del borde cuando hay un error
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors
                    .black, // Color del borde cuando el campo está enfocado y hay un error
              ),
            ),
          ),
          onChanged: (value) {},
          validator: funcionValidator,
          onFieldSubmitted: onPriceSubmitted, // Usa el nuevo parámetro aquí
        )
      ],
    );
  }

  Widget getPaneles({
    required BuildContext context,
    required String titulo,
    required TextEditingController controller,
    required String descripcion,
    required TextInputType inputType,
    required List<TextInputFormatter> listaType,
    String? errorText,
    FormFieldValidator<String>? funcionValidator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          cursorColor: colorRojo,
          controller: controller,
          keyboardType: inputType,
          inputFormatters: listaType,
          decoration: InputDecoration(
            errorText: errorText,
            errorStyle: const TextStyle(color: Colors.red),
            hintText: descripcion,
            labelStyle: Theme.of(context).textTheme.bodySmall,
            fillColor: Colors.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors
                    .grey, // Color del borde cuando el campo no está enfocado
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.grey, // Color del borde cuando hay un error
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors
                    .black, // Color del borde cuando el campo está enfocado y hay un error
              ),
            ),
          ),
          onChanged: (value) {},
          validator: funcionValidator,
        )
      ],
    );
  }

  void guardarDatos() async {
    if (idArticulo != null) {
      await CrudArticulo.putArticulo(
          articulo: Articulo(
        id: articulo!.id!,
        nombre: cNombre.text,
        precios: precios,
      ));
      Navigator.pop(context);
      setState(() {});
    } else {
      print(idCatalogo);
      await CrudArticulo.postArticulo(
          articulo: Articulo(
              categoria: Categoria(id: int.parse(idCatalogo!)),
              clave: generateRandomId(10),
              nombre: cNombre.text,
              precios: precios,
              activo: valorarticulo));
    }
  }

  String generateRandomId(int length) {
    var rng = Random();
    String valor = '';
    for (var i = 0; i < length; i++) {
      valor += rng.nextInt(10).toString();
    }
    return valor;
  }

  void eliminarBoton() {
    if (idArticulo != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text("¿Estás seguro de eliminar el articulo?"),
                  content: const Text(
                    "Esta acción no se puede deshacer.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        CrudArticulo.deleteArticulo(idArticulo: articulo!.id!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PanelArticulos(),
                            ));
                        setState(() {});
                      },
                      child: const Text("Sí"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(),
                      child: const Text("No"),
                    ),
                  ]));
    }
  }
}
