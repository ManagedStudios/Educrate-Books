import 'package:buecherteam_2023_desktop/Util/stringUtil.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {
  group("Is Class Valid Method", () {

    test ("True normal Class", () {
      String cl = "10K";
      expect(isClassValid(false, cl), isTrue);
    });

    test ("Numeric Class activated", () {
      String cl = "10";
      expect(isClassValid(true, cl), isTrue);
    });

    test ("Numeric Class disabled", () {
      String cl = "10";
      expect(isClassValid(false, cl), isFalse);
    });

    test ("Only Char", () {
      String cl = "K";
      expect(isClassValid(true, cl), isFalse);
    });

    test ("Only Char numeric disabled", () {
      String cl = "K";
      expect(isClassValid(false, cl), isFalse);
    });

    test ("Char + num", () {
      String cl = "K10";
      expect(isClassValid(false, cl), isFalse);
    });

    test ("Whitespace", () {
      String cl = "   ";
      expect(isClassValid(false, cl), isFalse);
    });

    test ("Empty", () {
      String cl = "";
      expect(isClassValid(true, cl), isFalse);
    });

    test ("Lowercase and zero", () {
      String cl = "0a";
      expect(isClassValid(true, cl), isTrue);
    });

    test ("Negative", () {
      String cl = "-5a";
      expect(isClassValid(true, cl), isFalse);
    });

    test ("valid class + Whitespace", () {
      String cl = "  5B   ";
      expect(isClassValid(true, cl), isTrue);
    });



  });

  group("Test isNotValidTrainingDirection", () {

    test ("valid TrainingDirection", () {
      String cl = "ausbildung12#_hallo";
      expect(isAlphaNumericalExtended(cl), isTrue);
    });

    test ("invalid TrainingDirection because of hyphen", () {
      String cl = "ausbildung12#_hallo–neu";
      expect(isAlphaNumericalExtended(cl), isFalse);
    });

    test ("invalid TrainingDirection because of trHyphen", () {
      String cl = "ausbildung12#_hallo-neu";
      expect(isAlphaNumericalExtended(cl), isFalse);
    });

    test ("invalid TrainingDirection because of multiple reasons", () {
      String cl = "ausbildung,–12#_hallo-neu";
      expect(isAlphaNumericalExtended(cl), isFalse);
    });

  });

  group("test isOnlyWhitespace", () {

  });
}