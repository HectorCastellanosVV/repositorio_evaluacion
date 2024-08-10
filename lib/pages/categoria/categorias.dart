import 'package:flutter/material.dart';
import 'package:flutter_prueba_visorus/class/categoria.dart';
import 'package:flutter_prueba_visorus/database/CRUD/crud_categoria.dart';
import 'package:flutter_prueba_visorus/pages/categoria/detalle_categoria.dart';
import 'package:flutter_prueba_visorus/test/constants.dart';

class PanelCategoria extends StatefulWidget {
  const PanelCategoria({super.key});

  @override
  State<PanelCategoria> createState() => _PanelCategoriaState();
}

class _PanelCategoriaState extends State<PanelCategoria> {
  List<Categoria> categorias = [];
  @override
  void initState() {
    super.initState();
    getCategorias();
    setState(() {});
  }

  void getCategorias() async {
    categorias = await CrudCategoria.getListCategoria();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 40),
        child: Column(
          children: [
            const Text(
              "Lista de categorías",
              style: TextStyle(fontSize: 35),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var categoria in categorias)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: getCategoria(
                          width: width, height: height, categoria: categoria),
                    ),
                  GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.arrow_right_outlined,
                        size: 60,
                      )),
                  Center(
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PanelDescriptionCategoria(
                                idCategoria: null,
                              ),
                            ),
                          );
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 40,
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCategoria(
      {required double width,
      required double height,
      required Categoria categoria}) {
    return Column(
      children: [
        Center(
          child: Container(
            width: width - 120,
            height: height / 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey)),
            child: Image.asset(
              "assets/icons/download.png",
              width: 90,
              height: 90,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          '${categoria.id} ${categoria.nombre}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text("Descripción de la categoría"),
        const SizedBox(
          height: 10,
        ),
        Text(
          "${DateTime.fromMillisecondsSinceEpoch(categoria.fechaCreado ?? 0)}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          categoria.activo! ? "Activo" : "Desactivo",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: categoria.activo! ? colorVerde : colorRojo,
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PanelDescriptionCategoria(
                    idCategoria: '${categoria.id}',
                  ),
                ));
          },
          label: const Text("Editar"),
          icon: Image.asset("assets/icons/edit.png"),
        )
      ],
    );
  }
}
