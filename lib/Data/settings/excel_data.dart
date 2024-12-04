

/*
class to represent a Excel cell in Dart
 */

class ExcelData {
  ExcelData({required this.row, required this.column, required this.content});

  final int row;
  final int column;
  final String content;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // If both references are the same

    // Check if other is of type Book and then compare all relevant fields
    return other is ExcelData && other.row == row
        && other.column == column
        && other.content == content;
  }


  @override
  int get hashCode {
    // Combine hash codes of all fields for a unique hash code (bitwise shift and bitwise or)
    return row.hashCode + column.hashCode + content.hashCode;
  }

}
