/*
 Copyright 2023 Google LLC

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import 'package:flutter/material.dart';

/// Contains a set of controls used to change environment parameters (text
/// scale, viewport size, dark/light mode, etc.) along with any widgets provided
/// by the current Scene's [environmentControlBuilders].
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
