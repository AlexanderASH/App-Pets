class InputValidations {

  static String validateText(String text) {
    if (_isEmptyOrNull(text)) {
      return "El campo es obligatorio";
    }
    return null;
  }

  static String validateDropDown(int id) {
    if (id == null) {
      return "El campo es obligatorio";
    }
    return null;
  }

  static bool _isEmptyOrNull(String text) {
    return text == null || text.isEmpty;
  }
}