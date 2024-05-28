const String tableNotes = 'notes';

class NoteFields {
  static const List<String> values = [
    id,
    number,
    title,
    note,
    lastSavedDate,
    createdTime,
    isFavorite,
    image
  ];
  static const String id = '_id';
  static const String number = 'number';
  static const String title = "title";
  static const String note = "note";
  static const String lastSavedDate = 'lastSavedDate';
  static const String createdTime = 'createdTime';
  static const String isFavorite = 'isFavorite';
  static const String image = 'image';
}

class Note {
  final int? id;
  final int number;
  final String title;
  final String note;
  final DateTime lastSavedDate;
  final DateTime createdTime;
  final bool isFavorite;
  final String image;

  Note(
      {this.id,
      required this.number,
      required this.title,
      required this.note,
      required this.lastSavedDate,
      required this.createdTime,
      required this.isFavorite,
      required this.image});

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.number: number,
        NoteFields.title: title,
        NoteFields.note: note,
        NoteFields.lastSavedDate: lastSavedDate.toIso8601String(),
        NoteFields.createdTime: createdTime.toIso8601String(),
        NoteFields.isFavorite: isFavorite ? 1 : 0,
        NoteFields.image: image,
      };

  static Note empty() => Note(number: 0, title: "", note: "", lastSavedDate: DateTime.now(), createdTime: DateTime.now(), isFavorite: false, image: "");
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        number: json[NoteFields.number] as int,
        title: json[NoteFields.title] as String,
        note: json[NoteFields.note] as String,
        image: json[NoteFields.image] as String,
        lastSavedDate: DateTime.parse(json[NoteFields.lastSavedDate] as String),
        createdTime: DateTime.parse(json[NoteFields.createdTime] as String),
        isFavorite: json[NoteFields.isFavorite] == 1,
      );
  Note copy({
    int? id,
    int? number,
    String? title,
    String? note,
    DateTime? lastSavedDate,
    DateTime? createdTime,
    bool? isFavorite,
    String? image,
  }) =>
      Note(
          id: id ?? this.id,
          number: number ?? this.number,
          title: title ?? this.title,
          note: note ?? this.note,
          lastSavedDate: lastSavedDate ?? this.lastSavedDate,
          createdTime: createdTime ?? this.createdTime,
          isFavorite: isFavorite ?? this.isFavorite,
          image: image ?? this.image);
}
