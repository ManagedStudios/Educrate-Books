import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/selectableItem.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';

class Book implements LfgChip, BookLite, SelectableItem {
  Book(
      {required String bookId,
      required this.name,
      required this.subject,
      required this.classLevel,
      required this.trainingDirection,
      required this.amountInStudentOwnership,
      required this.nowAvailable,
      required this.totalAvailable,
      this.isbnNumber})
      : _id = bookId;

  final String _id;
  final String name;
  final String subject;
  final int classLevel;
  final List<String> trainingDirection;
  int amountInStudentOwnership;
  int nowAvailable;
  final int totalAvailable;
  final String? isbnNumber;

  String get id => _id;

  factory Book.fromJson(Map<String, Object?> json) {
    if (json[TextRes.idJson] == null ||
        json[TextRes.bookNameJson] == null ||
        json[TextRes.bookSubjectJson] == null ||
        json[TextRes.bookClassLevelJson] == null ||
        json[TextRes.bookTrainingDirectionJson] == null ||
        json[TextRes.bookAmountInStudentOwnershipJson] == null ||
        json[TextRes.bookNowAvailableJson] == null ||
        json[TextRes.bookTotalAvailableJson] == null) {
      throw Exception("Incomplete JSON");
    }

    final int classLevel = json[TextRes.bookClassLevelJson] is int
        ? json[TextRes.bookClassLevelJson] as int
        : int.parse(json[TextRes.bookClassLevelJson] as String);
    final int expectedAmountNeeded =
        json[TextRes.bookAmountInStudentOwnershipJson] is int
            ? json[TextRes.bookAmountInStudentOwnershipJson] as int
            : int.parse(
                json[TextRes.bookAmountInStudentOwnershipJson] as String);
    final int nowAvailable = json[TextRes.bookNowAvailableJson] is int
        ? json[TextRes.bookNowAvailableJson] as int
        : int.parse(json[TextRes.bookNowAvailableJson] as String);
    final int totalAvailable = json[TextRes.bookTotalAvailableJson] is int
        ? json[TextRes.bookTotalAvailableJson] as int
        : int.parse(json[TextRes.bookTotalAvailableJson] as String);
    final String? isbnNumber = json[TextRes.bookIsbnNumberJson] != null
        ? (json[TextRes.bookIsbnNumberJson] as String)
        : null;
    late List<String> trDirections;

    try {
      trDirections =
          List.from(json[TextRes.bookTrainingDirectionJson] as dynamic);
    } on TypeError catch (e) {
      if (e.toString().contains('String') && e.toString().contains('subtype')) {
        trDirections = [json[TextRes.bookTrainingDirectionJson] as String];
      }
    }

    //TODO search when amounts go to negative and prevent it!

    /*
    if(classLevel<0||expectedAmountNeeded<0||nowAvailable<0||totalAvailable<0) {
      print("Negative book Int: see class book");
      throw Exception(TextRes.bookNegativeIntError);
    }

     */

    return Book(
        bookId: json[TextRes.idJson] as String,
        name: json[TextRes.bookNameJson] as String,
        subject: json[TextRes.bookSubjectJson] as String,
        classLevel: classLevel,
        trainingDirection: trDirections,
        amountInStudentOwnership: expectedAmountNeeded,
        nowAvailable: nowAvailable,
        totalAvailable: totalAvailable,
        isbnNumber: isbnNumber);
  }

  Map<String, Object?> toJson() {
    final data = {
      TextRes.idJson: id,
      TextRes.bookNameJson: name,
      TextRes.bookSubjectJson: subject,
      TextRes.bookClassLevelJson: classLevel,
      TextRes.bookTrainingDirectionJson: trainingDirection,
      TextRes.bookAmountInStudentOwnershipJson: amountInStudentOwnership,
      TextRes.bookNowAvailableJson: nowAvailable,
      TextRes.bookTotalAvailableJson: totalAvailable,
      TextRes.bookIsbnNumberJson: isbnNumber,
      TextRes.typeJson: TextRes.bookTypeJson,
    };
    return data;
  }

  BookLite toBookLite() {
    return BookLite(id, name, subject, classLevel);
  }

  void updateBookAmountOnDeletes(int n) {
    amountInStudentOwnership -= n;
    nowAvailable += n;
  }

  /*
  updates Book amount if enough books are available
  returns false if not enough books are available else true
   */
  bool updateBookAmountOnAdds(int n) {
    if (nowAvailable - n < 0) return false;
    amountInStudentOwnership += n;
    nowAvailable -= n;
    return true;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // If both references are the same

    // Check if other is of type Book and then compare all relevant fields
    return other is Book && other._id == _id;
  }

  @override
  int get hashCode {
    // Combine hash codes of all fields for a unique hash code (bitwise shift and bitwise or)
    return _id.hashCode;
  }

  @override
  int compareTo(other) {
    String first = "$classLevel$subject";
    String second = "${other.classLevel}${other.subject}";
    return first.compareTo(second);
  }

  @override
  String getLabelText() {
    String label = "$classLevel $subject";
    return label;
  }

  @override
  String get bookId => id;

  @override
  bool equals(BookLite other) {
    return other.bookId == id;
  }

  @override
  List<String> getAttributes() {
    // TODO: implement getAttributes
    throw UnimplementedError();
  }

  @override
  String getDocId() {
    return id;
  }

  @override
  String getType() {
    return TextRes.bookTypeJson;
  }

  @override
  bool isDeletable() {
    return true;
  }
}
