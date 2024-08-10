String? validateTextField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  return null;
}

String? validatePhoneTextField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  } else {
    if (value.trim().length < 10) {
      return 'Debe contener 10 dígitos';
    } else {}
  }
  return null;
}
