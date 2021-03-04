class Note {

  String id;
  String userId;
  String title;
  String desc;
  int lightColor;
  int darkColor;

  Note({
    this.id,
    this.userId,
    this.title,
    this.desc,
    this.lightColor,
    this.darkColor,
  });

  static Note fromMap(Map<dynamic, dynamic> note) {

    return Note(
      id: note["id"].toString(),
      userId: note["userId"],
      title: note["title"],
      desc: note["desc"],
      lightColor: note["lightColor"],
      darkColor: note["darkColor"],
    );
  }
}