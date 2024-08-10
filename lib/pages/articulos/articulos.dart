import 'package:flutter/material.dart';
import 'package:flutter_prueba_visorus/class/articulo.dart';
import 'package:flutter_prueba_visorus/database/CRUD/crud_articulo.dart';
import 'package:flutter_prueba_visorus/pages/articulos/detalles_articulo.dart';
import 'package:flutter_prueba_visorus/test/constants.dart';

class PanelArticulos extends StatefulWidget {
  const PanelArticulos({super.key});

  @override
  State<PanelArticulos> createState() => _PanelArticulosState();
}

class _PanelArticulosState extends State<PanelArticulos> {
  List<Articulo> articulos = [];
  @override
  void initState() {
    super.initState();
    getArticulos();
    setState(() {});
  }

  void getArticulos() async {
    articulos = await CrudArticulo.getListArticulo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            const Text(
              "Lista de artículos",
              style: TextStyle(fontSize: 35),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: articulos.length,
                itemBuilder: (context, index) {
                  final articulo = articulos[index];
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    articulo.nombre ?? 'Nombre no disponible',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "Descripción del producto",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$${articulo.precios!.isNotEmpty ? articulo.precios![0].precio : '0.00'}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        articulo.activo!
                                            ? "Activo"
                                            : "Inactivo",
                                        style: TextStyle(
                                            color: articulo.activo!
                                                ? colorVerde
                                                : colorRojo,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: -3,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PanelDetalleProducto(
                                  idArticulo: articulo.id!.toString(),
                                ),
                              ),
                            );
                            getArticulos();
                            setState(() {});
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 3, color: Colors.white),
                            ),
                            child: Image.asset("assets/icons/edit.png"),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PanelDetalleProducto(
                          idArticulo: null,
                        ),
                      ),
                    );
                    getArticulos();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 40,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
