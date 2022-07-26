import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver();

class StagerApp extends StatelessWidget {
  final List<Scene> scenes;

  const StagerApp({super.key, required this.scenes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      home: SceneList(
        scenes: scenes,
      ),
    );
  }
}

class SceneList extends StatefulWidget {
  final List<Scene> scenes;

  SceneList({super.key, required this.scenes});

  @override
  State<SceneList> createState() => _SceneListState();
}

class _SceneListState extends State<SceneList> with RouteAware {
  late OverlayEntry _overlayButton;

  @override
  void initState() {
    super.initState();
    _overlayButton = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: Navigator.of(context, rootNavigator: true).pop,
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    Overlay.of(context)!.insert(_overlayButton);
  }

  @override
  void didPopNext() {
    _overlayButton.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scenes')),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          title: Text(widget.scenes[index].title),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => widget.scenes[index].build(),
              ),
            );
          },
        ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: widget.scenes.length,
      ),
    );
  }
}
