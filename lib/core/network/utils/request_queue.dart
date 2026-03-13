import 'dart:collection';

class RequestQueue {
  final Queue<Future Function()> _queue = Queue();
  bool _processing = false;

  void add(Future Function() request) {
    _queue.add(request);
    _process();
  }

  void _process() async {
    if (_processing) return;

    _processing = true;

    while (_queue.isNotEmpty) {
      final request = _queue.removeFirst();
      await request();
    }

    _processing = false;
  }
}
