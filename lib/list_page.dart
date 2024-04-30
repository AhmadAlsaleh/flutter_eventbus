import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_eventbus/event_bus.dart';
import 'package:flutter_eventbus/item_model.dart';
import 'package:flutter_eventbus/list_item.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<ItemModel> _items = [];
  int _nextId = 1;

  @override
  void initState() {
    super.initState();

    EventBus().subscribe('add')?.listen((event) {
      setState(() {
        _items = _items..add(event as ItemModel);
      });
    });

    EventBus().subscribe('clearList')?.listen((event) {
      setState(() {
        _items = [];
      });
    });
  }

  @override
  void dispose() {
    EventBus().unsubscribe('add');
    EventBus().unsubscribe('clearList');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventBus List'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Clear List"),
                onTap: () => EventBus().publish('clearList'),
              )
            ],
          ),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: ElevatedButton(
                  onPressed: () {
                    for (var i = 0; i < 1000; i++) {
                      EventBus().publish(
                        'add',
                        ItemModel(
                          id: _nextId++,
                          name: 'Item $_nextId',
                          imageUrl:
                              'assets/gif/gif${Random().nextInt(6) + 1}.gif',
                          secondsCountdown: Random().nextInt(60) + 1,
                        ),
                      );
                    }
                  },
                  child: const Text("Generate 1000")),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) => ListItem(item: _items[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EventBus().publish(
          'add',
          ItemModel(
            id: _nextId++,
            name: 'Item $_nextId',
            imageUrl: 'assets/gif/gif${Random().nextInt(6) + 1}.gif',
            secondsCountdown: Random().nextInt(60) + 1,
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
