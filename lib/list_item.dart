import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_eventbus/item_model.dart';

class ListItem extends StatefulWidget {
  final ItemModel item;
  const ListItem({super.key, required this.item});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late Timer _timer;
  late ValueNotifier<int> _countdownNotifier;

  @override
  void initState() {
    super.initState();
    _countdownNotifier = ValueNotifier<int>(widget.item.secondsCountdown);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _countdownNotifier.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownNotifier.value > 0) {
        _countdownNotifier.value--;
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.item.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: ValueListenableBuilder<int>(
        valueListenable: _countdownNotifier,
        builder: (context, value, _) => Text('Countdown: $value'),
      ),
      leading: Image.asset(
        widget.item.imageUrl,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      ),
    );
  }
}
