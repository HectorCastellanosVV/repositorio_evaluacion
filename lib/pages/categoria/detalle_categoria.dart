import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_prueba_visorus/class/categoria.dart';
import 'package:flutter_prueba_visorus/core/utils/data_validate.dart';
import 'package:flutter_prueba_visorus/database/CRUD/crud_categoria.dart';
import 'package:flutter_prueba_visorus/pages/categoria/categorias.dart';
import 'package:flutter_prueba_visorus/test/constants.dart';
import 'package:intl/intl.dart';

class PanelDescriptionCategoria extends StatefulWidget {
  final String? idCategoria;
  const PanelDescriptionCategoria({super.key, required this.idCategoria});

  @override
  State<PanelDescriptionCategoria> createState() =>
      _PanelDescriptionCategoriaState();
}

class _PanelDescriptionCategoriaState extends State<PanelDescriptionCategoria> {
  TextEditingController cNombre = TextEditingController();
  TextEditingController cFechaCreado = TextEditingController();
  String? idCategoria;
  bool isEditing = false;
  bool valorCategoria = true;
  Categoria? categoria;

  @override
  void initState() {
    super.initState();
    rellenarDatos();
  }

  void rellenarDatos() async {
    if (widget.idCategoria != null && widget.idCategoria!.isNotEmpty) {
      categoria = await CrudCategoria.getCategoria(id: widget.idCategoria!);

      if (categoria != null) {
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(categoria!.fechaCreado!);

        setState(() {
          idCategoria = categoria!.id.toString();
          cNombre.text = categoria!.nombre ?? '';
          cFechaCreado.text = '${date.day}/${date.month}/${date.year}';
          valorCategoria = categoria!.activo ?? true;
        });
      }
    }
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
                "Detalles de la categoría",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
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
              const SizedBox(
                height: 10,
              ),
              Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getPaneles(
                          context: context,
                          titulo: 'Nombre de la categoría',
                          controller: cNombre,
                          descripcion: "Ingresa el nombre de la categoría aquí",
                          inputType: TextInputType.name,
                          listaType: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]')),
                            LengthLimitingTextInputFormatter(100),
                          ],
                          errorText: '',
                          funcionValidator: validateTextField),
                      const SizedBox(
                        height: 20,
                      ),
                      getPaneles(
                          context: context,
                          titulo: 'Fecha en que se creó la categoría',
                          controller: cFechaCreado,
                          descripcion: "dd/mm/yyyy",
                          inputType: TextInputType.name,
                          listaType: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9/]')),
                            LengthLimitingTextInputFormatter(100),
                          ],
                          errorText: '',
                          funcionValidator: validateTextField),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Estado de la categoría",
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colorFondo)),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton(
                          value: valorCategoria,
                          items: const [
                            DropdownMenuItem<bool>(
                                value: true,
                                child: Text(
                                  'Activo',
                                  style: TextStyle(color: colorFondo),
                                )),
                            DropdownMenuItem<bool>(
                                value: false,
                                child: Text('Desactivo',
                                    style: TextStyle(color: colorFondo))),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                valorCategoria = value;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 60,
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
                  ))
            ],
          ),
        ),
      ),
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
                color: Colors.grey,
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
                color: Colors.grey,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.black,
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
    DateFormat format = DateFormat("dd/MM/yyyy");

    if (idCategoria != null) {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(categoria!.fechaCreado!);
      DateTime dateTime = format.parse(cFechaCreado.text);

      if ((categoria!.nombre != cNombre.text.trim()) &&
          (date != dateTime) &&
          (categoria!.activo != valorCategoria)) {
        categoria!.nombre = cNombre.text.trim();
        categoria!.fechaCreado = dateTime.millisecondsSinceEpoch;
        categoria!.activo = valorCategoria;
        CrudCategoria.putCategoria(categoria: categoria!);
      } else {
        if (categoria!.nombre != cNombre.text.trim()) {
          categoria!.nombre = cNombre.text.trim();
          CrudCategoria.patchCategoria(
              idCategoria: categoria!.id!,
              editDato: CategoriaEditing.nombre,
              newValue: categoria!.nombre);
        }
        if (date != dateTime) {
          categoria!.fechaCreado = dateTime.microsecondsSinceEpoch;
          CrudCategoria.patchCategoria(
              idCategoria: categoria!.id!,
              editDato: CategoriaEditing.fechaCreado,
              newValue: categoria!.fechaCreado);
        }
        if (categoria!.activo != valorCategoria) {
          categoria!.activo = valorCategoria;
          CrudCategoria.patchCategoria(
              idCategoria: categoria!.id!,
              editDato: CategoriaEditing.activo,
              newValue: categoria!.activo);
        }
      }
    } else {
      idCategoria = generateRandomId(10);
      DateTime dateTime = format.parse(cFechaCreado.text);
      Categoria categoria = Categoria(
        clave: idCategoria,
        nombre: cNombre.text.trim(),
        fechaCreado: dateTime.microsecondsSinceEpoch,
        activo: valorCategoria,
      );
      await CrudCategoria.postCategoria(categoria: categoria);
      setState(() {});
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
    if (idCategoria != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text("¿Estás seguro de eliminar la categoría?"),
                  content: const Text(
                    "Esta acción no se puede deshacer.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        CrudCategoria.deleteCategoria(
                            idCategoria: categoria!.id!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PanelCategoria(),
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
