import 'package:flutter/material.dart';
import 'package:flutter_prueba_visorus/test/constants.dart';

class ProfileCard extends StatelessWidget {
  final String usuario;
  const ProfileCard({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: colorBordeUsuario),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/hipsterAdmi.png",
            height: 38,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: Text(
              usuario,
              style: const TextStyle(color: colorBlanco),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
