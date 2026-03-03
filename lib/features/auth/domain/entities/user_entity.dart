import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl];

  @override
  bool? get stringify => true;
}

class Test {
  const Test({required String uid, required String email});
}

class NewTest extends Test {
  const NewTest({required super.uid, required super.email});

  factory NewTest.ne() => const NewTest(uid: "uid", email: "email");
}

const test = Test(uid: 'uid', email: 'email');
