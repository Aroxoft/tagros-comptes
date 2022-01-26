extension UniqueList<T, Id> on Iterable<T> {
  Iterable<T> unique({Id Function(T element)? toId}) {
    final ids = <Id>{};
    final list = List<T>.from(this);
    list.retainWhere((e) => ids.add(toId != null ? toId(e) : e as Id));
    return list;
  }
}
