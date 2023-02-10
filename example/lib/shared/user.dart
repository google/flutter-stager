import 'package:equatable/equatable.dart';

/// A person or entity that creates [Post]s.
class User extends Equatable {
  /// Creates a [User].
  const User({
    required this.id,
    required this.name,
    required this.handle,
  });

  /// This user's ID.
  final int id;

  /// This user's full name.
  final String name;

  /// This user's @ handle.
  final String handle;

  @override
  List<Object?> get props => <Object?>[id, name, handle];

  @override
  String toString() => handle;

  /// A fake user named "Joe User".
  static User joeUser = const User(
    id: 1,
    name: 'Joe User',
    handle: '@joe',
  );

  /// A fake user named "Alice User".
  static User aliceUser = const User(
    id: 2,
    name: 'Alice User',
    handle: '@alice',
  );

  /// Creates a [User] with the given id.
  static User fakeUser({required int id}) => User(
        id: id,
        name: 'User $id',
        handle: '@user$id',
      );
}
