import 'package:flutter/material.dart';

/// A row of controls used to toggle [Theme] and [MediaQuery] parameters, like
/// [MediaQuery.brightness] and [MediaQuery.textScale].
class EnvironmentControlPanel extends StatefulWidget {
  /// Creates an [EnvironmentControlPanel].
  const EnvironmentControlPanel({
    super.key,
    required this.children,
    // required this.hidePanel,
    this.targetPlatform,
  });

  /// Widgets displayed in the panel.
  final List<Widget> children;

  /// Active [TargetPlatform]. Defaults to the current platform if null.
  final TargetPlatform? targetPlatform;

  @override
  State<EnvironmentControlPanel> createState() =>
      _EnvironmentControlPanelState();
}

class _EnvironmentControlPanelState extends State<EnvironmentControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(4),
        bottomRight: Radius.circular(4),
      ),
      shadowColor: Colors.black,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (Navigator.of(context).canPop())
                IconButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ...widget.children,
            ],
          ),
        ),
      ),
    );
  }
}
