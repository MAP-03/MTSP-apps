class User {
  final String fullName;
  final String userName;
  final String phoneNumber;
  final String email;

  DateTime timestamp = DateTime.now();

  User({
    required this.fullName,
    required this.userName,
    required this.phoneNumber,
    required this.email,
  });

  Map<String, dynamic> toJson(){
    return {
      'fullName': fullName,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'email': email,
      'timestamp' : timestamp
    };
  }
}
