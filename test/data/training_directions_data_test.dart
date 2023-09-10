import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrainingDirectionsData', () {
    test('can be created from JSON', () {
      final data = {
        TextRes.trainingDirectionsJson: 'ExampleLabel',
      };
      final instance = TrainingDirectionsData.fromJson(data);

      expect(instance.label, 'ExampleLabel');
    });

    test('behavior when null', () {
      final data = {
        TextRes.trainingDirectionsJson: null,
      };
      expect(TrainingDirectionsData.fromJson(data).label, "");
    });

    test('can be converted to JSON', () {
      final instance = TrainingDirectionsData('ExampleLabel');
      final json = instance.toJson();

      expect(json[TextRes.trainingDirectionsJson], 'ExampleLabel');
      expect(json[TextRes.typeJson], TextRes.trainingDirectionsTypeJson);
    });

    test('getLabelText returns correct label', () {
      final instance = TrainingDirectionsData('ExampleLabel');
      expect(instance.getLabelText(), 'ExampleLabel');
    });

    test('compareTo compares correctly', () {
      final instance1 = TrainingDirectionsData('LabelA');
      final instance2 = TrainingDirectionsData('LabelB');
      final instance3 = TrainingDirectionsData('LabelA');

      expect(instance1.compareTo(instance2), lessThan(0)); // LabelA < LabelB
      expect(instance2.compareTo(instance1), greaterThan(0)); // LabelB > LabelA
      expect(instance1.compareTo(instance3), equals(0)); // LabelA == LabelA
    });

    // More tests can be added based on above suggestions
  });
}
