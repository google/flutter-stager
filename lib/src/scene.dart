import 'package:flutter/widgets.dart';

/// Signature for a function that creates a widget and provides a hook to
/// trigger a rebuild of the current [Scene].
typedef EnvironmentControlBuilder = Widget Function(
  BuildContext context,
  VoidCallback rebuildScene,
);

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
  Widget build();

  /// Used to present custom controls to Stager's [EnvironmentControlPanel].
  ///
  /// Stager provides several widgets that should address most use cases,
  /// including the [NumberStepperControl], [DropdownControl], and
  /// [BooleanControl]. However, the Widgets returned by the
  /// [EnvironmentControlBuilder]s in this list can return any arbitrary widget.
  ///
  /// The example below demonstrates usage of the [NumberStepperControl] to
  /// increment and decrement a value that is reflected on screen.
  ///
  /// ```
  /// class CounterScene extends Scene {
  ///   int count = 0;
  ///
  ///  @override
  ///  Widget build() {
  ///    return EnvironmentAwareApp(
  ///      home: Scaffold(
  ///        body: Center(
  ///          child: Text(count.toString()),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  ///   @override
  ///   String get title => 'Counter';
  ///
  ///   @override
  ///   List<EnvironmentControlBuilder> get environmentControlBuilders => [
  ///         (_, VoidCallback rebuildScene) {
  ///           return NumberStepperControl(
  ///             title: const Text('Count'),
  ///             value: count,
  ///             onDecrementPressed: () {
  ///               count -= 1;
  ///               rebuildScene();
  ///             },
  ///             onIncrementPressed: () {
  ///               count += 1;
  ///               rebuildScene();
  ///             },
  ///           );
  ///         }
  ///       ];
  /// }
  /// ```
  ///
  /// To make effective use of this functionality, these widgets should
  /// mutate a property defined on this Scene in the various onChange callbacks
  /// **and call [rebuildScene()] afterwards.**
  List<EnvironmentControlBuilder> environmentControlBuilders =
      <EnvironmentControlBuilder>[];
}
