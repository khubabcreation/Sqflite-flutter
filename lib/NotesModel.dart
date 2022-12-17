class NotesModel {
  int? id;
  String title;
  int age;
  String description;
  String email;

  NotesModel(
      {this.id,
      required this.title,
      required this.email,
      required this.age,
      required this.description});

  NotesModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        email = res['email'],
        age = res['age'],
        description = res['description'];

  Map<String, Object?> tomap() {
    return {
      'id': id,
      'title': title,
      'email': email,
      'age': age,
      'description': description,
    };
  }
}
