import 'package:flutter/material.dart';

/// A row of controls used to toggle [Theme] and [MediaQuery] parameters, like
/// [MediaQuery.brightness] and [MediaQuery.textScale].
class EnvironmentManipulationPanel extends StatefulWidget {
  /// Creates an [EnvironmentManipulationPanel].
  const EnvironmentManipulationPanel({
    super.key,
    required this.toggleDarkMode,
    required this.toggleSemantics,
    required this.decrementTextScale,
    required this.incrementTextScale,
    required this.onTargetPlatformChanged,
    required this.hidePanel,
    this.targetPlatform,
  });

  /// Executed when the dark mode button is tapped.
  final VoidCallback toggleDarkMode;

  /// Executed when the semantics button is tapped.
  final VoidCallback toggleSemantics;

  /// Executed when the decrement text scale button is tapped.
  final VoidCallback decrementTextScale;

  /// Executed when the increment text scale button is tapped.
  final VoidCallback incrementTextScale;

  /// Executed when the hide panel button is tapped.
  final VoidCallback hidePanel;

  /// Called when the user selects a different [TargetPlatform] from the
  /// [PopupMenu].
  final void Function(TargetPlatform?) onTargetPlatformChanged;

  /// The active [TargetPlatform]. Defaults to the current platform if null.
  final TargetPlatform? targetPlatform;

  @override
  State<EnvironmentManipulationPanel> createState() =>
      _EnvironmentManipulationPanelState();
}

class _EnvironmentManipulationPanelState
    extends State<EnvironmentManipulationPanel> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (Navigator.of(context).canPop())
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                IconButton(
                  onPressed: widget.toggleDarkMode,
                  icon: const Icon(Icons.light_mode),
                ),
                IconButton(
                  onPressed: widget.decrementTextScale,
                  icon: const Icon(Icons.text_decrease),
                ),
                IconButton(
                  onPressed: widget.incrementTextScale,
                  icon: const Icon(Icons.text_increase),
                ),
                IconButton(
                  onPressed: widget.toggleSemantics,
                  icon: const Icon(Icons.shelves),
                ),
                DropdownButton<TargetPlatform>(
                  items: TargetPlatform.values
                      .map(
                        (TargetPlatform e) => DropdownMenuItem<TargetPlatform>(
                          value: e,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: widget.onTargetPlatformChanged,
                  value: widget.targetPlatform ?? Theme.of(context).platform,
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.hidePanel,
                  icon: const Icon(Icons.arrow_downward),
                ),
              ],
            ),
            Container(
              height: mediaQueryData.padding.bottom,
            ),
          ],
        ),
      ),
    );
  }
}
