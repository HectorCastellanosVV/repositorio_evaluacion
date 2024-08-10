import 'package:flutter/material.dart';
import 'package:flutter_prueba_visorus/pages/articulos/articulos.dart';
import 'package:flutter_prueba_visorus/pages/categoria/categorias.dart';
import 'package:flutter_prueba_visorus/test/constants.dart';
import 'package:flutter_prueba_visorus/widget/user.dart';

class PanelHome extends StatefulWidget {
  const PanelHome({super.key});

  @override
  State<PanelHome> createState() => _PanelHomeState();
}

class _PanelHomeState extends State<PanelHome> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        backgroundColor: colorFondo,
        actions: const [ProfileCard(usuario: "Administrador")],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PanelCategoria(),
                      ));
                },
                child: Container(
                  width: width - 60,
                  height: height / 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorNaranja),
                  child: const Center(
                      child: Text(
                    "Categoría",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PanelArticulos(),
                      ));
                },
                child: Container(
                  width: width - 60,
                  height: height / 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorVerde),
                  child: const Center(
                      child: Text(
                    "Artículos",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
