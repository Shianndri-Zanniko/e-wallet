class UserCreationReq {
  String ? fullName;
  String ? username;
  String ? phoneNumber;
  String ? email;
  String ? password;
  String ? confirmPassword;
  String ? balance;

  UserCreationReq({
    required this.fullName,
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.balance
  });
}