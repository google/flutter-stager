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

/// A [MaterialApp] that inherits its [MediaQuery] and applies the
/// [platform] from its ancestors to default Material dark and light themes.
///
/// This class makes it easier to write Scenes that interact well with the
/// environment manipulation feature provided by [StagerApp]. This class is not
/// required to use Stager, but you will need to ensure that you are properly
/// consuming the [MediaQuery] and [ThemeData.platform] for the environment
/// manipulation feature to work properly.
class EnvironmentAwareApp extends StatelessWidget {
  /// Creates an [EnvironmentAwareApp] with the provided [home].
  const EnvironmentAwareApp(
      {super.key,
      required this.home,
      this.localizationsDelegates,
      this.supportedLocales});

  /// The widget wrapped by this app.
  final Widget home;

  /// Optional list of [LocalizationsDelegate]s, forwarded to the wrapped
  /// [MaterialApp].
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Optional list of [Locale]s, forwarded to the wrapped [MaterialApp]
  final Iterable<Locale>? supportedLocales;

  @override
  Widget build(BuildContext context) {
    if (supportedLocales != null && supportedLocales!.isNotEmpty) {
      return MaterialApp(
        useInheritedMediaQuery: true,
        theme: ThemeData.light().copyWith(platform: Theme.of(context).platform),
        darkTheme:
            ThemeData.dark().copyWith(platform: Theme.of(context).platform),
        home: home,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales!,
        locale: Localizations.localeOf(context),
      );
    }
    return MaterialApp(
      useInheritedMediaQuery: true,
      theme: ThemeData.light().copyWith(platform: Theme.of(context).platform),
      darkTheme:
          ThemeData.dark().copyWith(platform: Theme.of(context).platform),
      home: home,
      localizationsDelegates: localizationsDelegates,
      locale: Localizations.localeOf(context),
    );
  }
}
