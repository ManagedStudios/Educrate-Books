
import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/selectableItem.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Util/comparison.dart';

class Book implements LfgChip, BookLite, SelectableItem {

  Book({required String bookId,
    required this.name,
    required this.subject,
    required this.classLevel,
    required this.trainingDirection,
    required this.expectedAmountNeeded,
    required this.nowAvailable, required this.totalAvailable}) : _id = bookId;

  final String _id;
  final String name;
  final String subject;
  final int classLevel;
  final List<String> trainingDirection;
  final int expectedAmountNeeded;
  final int nowAvailable;
  final int totalAvailable;

  String get id => _id;


  factory Book.fromJson(Map<String, Object?> json) {
    if(json[TextRes.idJson] == null||
        json[TextRes.bookNameJson] == null||
        json[TextRes.bookSubjectJson] == null||
        json[TextRes.bookClassLevelJson] == null||
        json[TextRes.bookTrainingDirectionJson] == null||
        json[TextRes.bookExpectedAmountNeededJson] == null||
        json[TextRes.bookNowAvailableJson] == null ||
        json[TextRes.bookTotalAvailableJson] == null) {
      throw Exception("Incomplete JSON");
    }

    final int classLevel = json[TextRes.bookClassLevelJson] is int ? json[TextRes.bookClassLevelJson] as int : int.parse(json[TextRes.bookClassLevelJson] as String);
    final int expectedAmountNeeded = json[TextRes.bookExpectedAmountNeededJson] is int ? json[TextRes.bookExpectedAmountNeededJson] as int : int.parse(json[TextRes.bookExpectedAmountNeededJson] as String);
    final int nowAvailable = json[TextRes.bookNowAvailableJson] is int ? json[TextRes.bookNowAvailableJson] as int : int.parse(json[TextRes.bookNowAvailableJson] as String);
    final int totalAvailable = json[TextRes.bookTotalAvailableJson] is int ? json[TextRes.bookTotalAvailableJson] as int : int.parse(json[TextRes.bookTotalAvailableJson] as String);
    late List<String> trDirections;

    try {
      trDirections = List.from(json[TextRes.bookTrainingDirectionJson] as dynamic);
    } on TypeError catch (e) {
      if(e.toString().contains('String') && e.toString().contains('subtype')) {
        trDirections = [json[TextRes.bookTrainingDirectionJson] as String];
      }
    }

    if(classLevel<0||expectedAmountNeeded<0||nowAvailable<0||totalAvailable<0) {
      throw Exception(TextRes.bookNegativeIntError);
    }


    return Book(bookId: json[TextRes.idJson] as String,
        name: json[TextRes.bookNameJson] as String,
        subject: json[TextRes.bookSubjectJson] as String,
        classLevel: classLevel,
        trainingDirection: trDirections,
        expectedAmountNeeded: expectedAmountNeeded,
        nowAvailable: nowAvailable,
        totalAvailable: totalAvailable
      );
  }

  Map<String, Object?> toJson() {
    final data = {TextRes.idJson: id,
      TextRes.bookNameJson: name,
      TextRes.bookSubjectJson: subject,
      TextRes.bookClassLevelJson: classLevel,
      TextRes.bookTrainingDirectionJson: trainingDirection,
      TextRes.bookExpectedAmountNeededJson: expectedAmountNeeded,
      TextRes.bookNowAvailableJson: nowAvailable,
      TextRes.bookTotalAvailableJson: totalAvailable,
      TextRes.typeJson:TextRes.bookTypeJson
    };
    return data;
  }



  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // If both references are the same

    // Check if other is of type Book and then compare all relevant fields
    return other is Book &&
        other._id == _id &&
        other.name == name &&
        other.subject == subject &&
        other.classLevel == classLevel &&
        areListsEqualIgnoringOrder(other.trainingDirection, trainingDirection) &&
        other.expectedAmountNeeded == expectedAmountNeeded &&
        other.nowAvailable == nowAvailable &&
        other.totalAvailable == totalAvailable;
  }

  @override
  int get hashCode {
    // Combine hash codes of all fields for a unique hash code (bitwise shift and bitwise or)
    return _id.hashCode ^
    name.hashCode ^
    subject.hashCode ^
    classLevel.hashCode ^
    trainingDirection.hashCode ^
    expectedAmountNeeded.hashCode ^
    nowAvailable.hashCode ^
    totalAvailable.hashCode;
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
    return other.subject==subject
        && other.classLevel==classLevel
        && other.name == name;
  }

  @override
  List<String> getAttributes() {
    // TODO: implement getAttributes
    throw UnimplementedError();
  }

  @override
  String getDocId() {
    // TODO: implement getDocId
    throw UnimplementedError();
  }

  @override
  String getType() {
    // TODO: implement getType
    throw UnimplementedError();
  }

  @override
  bool isDeletable() {
    // TODO: implement isDeletable
    throw UnimplementedError();
  }

}