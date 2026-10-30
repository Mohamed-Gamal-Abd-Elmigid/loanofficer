class SignedInOfficer {
  const SignedInOfficer({
    required this.fullName,
    required this.employeeId,
    required this.email,
  });

  final String fullName;
  final String employeeId;
  final String email;

  factory SignedInOfficer.fromJson(Map<String, dynamic> json) {
    return SignedInOfficer(
      fullName: '${json['full_name'] ?? json['fullName'] ?? ''}',
      employeeId: '${json['employee_id'] ?? json['employeeId'] ?? ''}',
      email: '${json['email'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'employee_id': employeeId,
    'email': email,
  };
}
