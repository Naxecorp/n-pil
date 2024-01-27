class replyListFiFO {
  final int _capacity;
  final List<String> _items;

  replyListFiFO(this._capacity) : _items = [];

  void addItem(String item) {
    if (_items.length == _capacity) {
      _items.removeAt(0); // Retire le premier élément (FIFO)
    }
    _items.add(item); // Ajoute le nouvel élément
  }

  List<String> get items => _items;

  @override
  String toString() => _items.toString();
}