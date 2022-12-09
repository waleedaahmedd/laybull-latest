class UserFollower {
  int userId;
  String profilePic;
  String userName;
  UserFollower(
      {required this.userId, required this.userName, required this.profilePic});

  factory UserFollower.fromJson(Map<String, dynamic> json) {
    return UserFollower(
      userId: json["follow"]["id"],
      userName: json["follow"]["name"],
      profilePic: json["follow"]["detail"] != null
          ? json["follow"]["detail"]["image"]
          : null,
    );
  }
}
