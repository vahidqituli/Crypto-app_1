class User {
  int id;
  String name;
  String username;
  String city;
  String phone;
  User(this.id, this.name, this.username, this.city, this.phone);
  factory User.fromMapjson(Map<String, dynamic> jsonobject) {
    return User(jsonobject['id'], jsonobject['name'], jsonobject['username'],
        jsonobject['address']['city'], jsonobject['phone']);
  }
}
