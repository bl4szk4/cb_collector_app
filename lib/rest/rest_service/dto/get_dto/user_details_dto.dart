class UserDetailsDTO{
  int id;
  int departmentId;
  String name;
  String surname;

  UserDetailsDTO({
    required this.id,
    required this.departmentId,
    required this.name,
    required this.surname
});


  @override
  factory UserDetailsDTO.fromJson(dynamic json){
    return UserDetailsDTO(id: json["id"],
        departmentId: json["departmentId"],
        name: json["name"],
        surname: json["surname"]
    );
  }
}