class Validator {
  String nameValidator(String value) {
    if (value.isEmpty) {
      return 'Lütfen bir isim giriniz.';
    } else if (value.length < 4) {
      return 'En az 4 karakter giriniz.';
    }
    return null;
  }

  String ageValidator(String value) {
    if (value.length == 0) {
      return 'Lütfen yaşınızı giriniz.';
    }
    return null;
  }
}
