abstract class SelectableItem {
  List<String> getAttributes();
  bool isDeletable();
  String? getDocId();
  String getType();
}
