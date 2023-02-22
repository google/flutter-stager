import 'package:flutter/material.dart';

/// A row of controls used to toggle [Theme] and [MediaQuery] parameters, like
/// [MediaQuery.brightness] and [MediaQuery.textScale].
class EnvironmentControlPanel extends StatefulWidget {
  /// Creates an [EnvironmentControlPanel].
  const EnvironmentControlPanel({
    super.key,
    required this.children,
    this.targetPlatform,
  });

  /// Standard width used for individual control title labels.
  static const double labelWidth = 80;

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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...widget.children,
            ],
          ),
        ),
      ),
    );
  }
}
