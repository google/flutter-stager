import 'dart:async';

import 'package:flutter/widgets.dart';

import 'environment/controls/environment_control.dart';
import 'environment/state/environment_state.dart';

/// The central class of Stager, used to demonstrate a single piece of UI.
///
/// Use [setUp] to configure dependencies and [build] to create the Widget you
/// would like to develop or demo. You may find yourself wanting to use the
/// same [build] implementation with different [setUp] implementations (or vice
/// versa). In these cases, you can create a base Scene class defines the code
/// you wish to share and extend that. The following example defines a shared
/// base Scene that is extended to configure the Api dependency in different
/// ways while sharing the same [build] implementation.
///
/// ```
/// @GenerateMocks([Api])
/// abstract class BasePostsListScene extends Scene {
///   late MockApi mockApi;
///
///   @override
///   Widget build() {
///     return EnvironmentAwareApp(
///       home: Provider<Api>.value(
///         value: mockApi,
///         child: const PostsList(),
///       ),
///     );
///   }
///
///   @override
///   Future<void> setUp() async {
///     mockApi = MockApi();
///   }
/// }
///
/// class EmptyListScene extends BasePostsListScene {
///   @override
///   String get title => 'Empty List';
///
///   @override
///   Future<void> setUp() async {
///     await super.setUp();
///     when(mockApi.fetchPosts()).thenAnswer((_) async => []);
///   }
/// }
///
/// class WithPostsScene extends BasePostsListScene {
///   @override
///   String get title => 'With Posts';
///
///   @override
///   Future<void> setUp() async {
///     await super.setUp();
///     when(mockApi.fetchPosts()).thenAnswer((_) async => Post.fakePosts);
///   }
/// }
/// ```
///
abstract class Scene {
  /// This Scene's name in the [StagerApp]'s list of scenes.
  ///
  /// Scenes without a [title] will not be displayed in the [StagerApp]'s list
  /// of scenes.
  String get title;

  /// Used to configure this Scene's dependencies.
  ///
  /// Analogous to StatefulWidget's `initState`, this is called once at app
  /// launch.
  Future<void> setUp() async {}

  /// Creates the widget tree for this Scene.
  ///
  /// This is called on every rebuild, including by Hot Reload.
  ///
  /// [EnvironmentState] is available through [context] using
  /// `context.read<EnvironmentState>()`. Get specific values using
  /// `context.read<EnvironmentState>().get(key: myKey)`.
  Widget build(BuildContext context);

  /// Used to add custom controls to the [EnvironmentControlPanel].
  ///
  /// Stager provides several controls that should address most use cases,
  /// including the [StepperControl], [DropdownControl], and [BooleanControl].
  /// The example below demonstrates usage of the [StepperControl] to increment
  /// and decrement a value that is reflected on screen.
  ///
  /// ```
  /// class CounterScene extends Scene {
  ///   final countControl = StepperControl<int>(
  ///     title: 'Count',
  ///     stateKey: 'CounterScene.CountKey',
  ///     defaultValue: Post.fakePosts().length,
  ///     onDecrementPressed: (int currentValue) => currentValue - 1,
  ///     onIncrementPressed: (int currentValue) => currentValue + 1
  ///   );
  ///
  ///   @override
  ///   Widget build() {
  ///     return EnvironmentAwareApp(
  ///       home: Scaffold(
  ///         body: Center(
  ///           child: Text(countControl.currentValue.toString()),
  ///         ),
  ///       ),
  ///     );
  ///   }
  ///
  ///   @override
  ///   String get title => 'Counter';
  ///
  ///   @override
  ///   final List<EnvironmentControl<Object?>> environmentControls =
  ///     <EnvironmentControl<Object?>>[
  ///       countControl,
  ///     ];
  /// }
  /// ```
  ///
  /// Note that the rebuild that occurs as a result of changing the backing
  /// [EnvironmentState] will not cause StatefulWidgets in your Scene to
  /// recreate their state. To do this, call [setNeedsReconstruct].
  List<EnvironmentControl<Object?>> get environmentControls =>
      <EnvironmentControl<Object?>>[];

  /// Emits an event when [setNeedsReconstruct] is called.
  Stream<void> get onNeedsReconstruct => _needsReconstructController.stream;

  /// Call this function to force recreation of StatefulWidget state in your
  /// Scene. Use this if you have an [EnvironmentControl] that changes a value
  /// used in `initState`.
  void setNeedsReconstruct() => _needsReconstructController.add(null);

  final StreamController<void> _needsReconstructController =
      StreamController<void>.broadcast();
}
