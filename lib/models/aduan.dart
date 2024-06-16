class Aduan {
  String type;
  String subject;
  String comment;

  Aduan({
    required this.type,
    required this.subject,
    required this.comment,
  });

  String get _type => type;
  String get _subject => subject;
  String get _comment => comment;
}
