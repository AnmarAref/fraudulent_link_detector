// ApprovalRequestModel represents the data model for an admin approval request.
class ApprovalRequestModel {
  final String email;
  final String approvalStatus;

  ApprovalRequestModel({
    required this.email,
    required this.approvalStatus,
  });

  // Factory constructor to create an ApprovalRequestModel from JSON data.
  factory ApprovalRequestModel.fromJson(Map<String, dynamic> json) {
    return ApprovalRequestModel(
      email: json['email'] as String,
      approvalStatus: json['approvalStatus'] as String,
    );
  }
}
