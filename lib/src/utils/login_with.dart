enum LoginWith {
  phone,
  email;

  bool get isPhone => this == phone;
  bool get isEmail => this == email;

  @override
  String toString() => this == phone ? 'phone' : 'email';
}
