import 'package:flutter/material.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock<IconData>(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (icon) {
              return DraggableIcon(icon: icon);
            },
          ),
        ),
      ),
    );
  }
}

class DraggableIcon extends StatefulWidget {
  final IconData icon;

  const DraggableIcon({Key? key, required this.icon}) : super(key: key);

  @override
  _DraggableIconState createState() => _DraggableIconState();
}

class _DraggableIconState extends State<DraggableIcon> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => scale = 1.2),
      onExit: (_) => setState(() => scale = 1.0),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 60, // Fixed width
          height: 60, // Fixed height
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
            Colors.primaries[widget.icon.hashCode % Colors.primaries.length],
          ),
          child: Center(
            child: Icon(widget.icon, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }
}

class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  final List<T> items;
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T extends Object> extends State<Dock<T>> {
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black12,
            ),
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width:400,
              height: 80, // Adjusted height for a consistent dock
              child: AnimatedReorderableGridView(
                items: _items,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final item = _items[index];
                  return KeyedSubtree(
                    key: Key(item.hashCode.toString()),
                    child: widget.builder(item),
                  );
                },
                enterTransition: [FadeIn(), ScaleIn()],
                exitTransition: [SlideInLeft(), SlideInRight()],
                insertDuration: const Duration(milliseconds: 300),
                removeDuration: const Duration(milliseconds: 300),
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    final T item = _items.removeAt(oldIndex);
                    _items.insert(newIndex, item);
                  });
                },
                isSameItem: (a, b) => a == b,
                sliverGridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Spacing between items
                ),
              ),
            ),
      ),
    );
  }
}
