class User {
  final String userid;
  final String firstname;
  final String lastname;
  final String email;

  const User({
    required this.userid,
    required this.firstname,
    required this.lastname,
    required this.email
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userid: json['userid'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname']as String,
      email: json['email'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
    };
  }

  @override
  String toString() => toJson().toString();
}