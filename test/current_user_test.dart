
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class MockBookDatabase extends Mock implements BookDatabase {}
class MockFirebaseUser extends Mock implements User {
  @override
  String get uid => "asdfghjio";
  @override
  String get email => "hello@hello.com";
  @override
  String get displayName => "hello";
}

class TestMockFirebaseAuth extends Mock implements MockFirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {
  @override
  User get user => MockFirebaseUser();
  @override
  AdditionalUserInfo get additionalUserInfo => MockAdditionalUserInfo();
}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {
  @override
  bool get isNewUser => true;
}

class TestMockGoogleSignIn extends Mock implements GoogleSignIn {
  @override
  Future<GoogleSignInAccount> signIn() => Future.value(MockGoogleSignInAccount());
}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  @override
  Future<GoogleSignInAuthentication> get authentication => Future.value(MockGoogleSignInAuth());
}

class MockGoogleSignInAuth extends Mock implements GoogleSignInAuthentication {
  @override
  String get idToken => "denemeidtoken";

  @override
  String get accessToken => "denemeAccessToken";
}


void main() {
  test('signOut test', () async {
    final mockFirebaseAuth = TestMockFirebaseAuth();
    final mockBookDatabase = MockBookDatabase();

    CurrentUser currentUser = CurrentUser(auth: mockFirebaseAuth);
    currentUser.bookDatabase = mockBookDatabase;

    expect(await currentUser.signOut(), "Success");
    verify(mockFirebaseAuth.signOut()).called(1);
  });

  test('signUpUser test success', () async {
    final mockFirebaseAuth = TestMockFirebaseAuth();
    final mockBookDatabase = MockBookDatabase();
    final mockUserCredential = MockUserCredential();

    when(mockFirebaseAuth.createUserWithEmailAndPassword(email: "hello@hello.com", password: "hello123"))
        .thenAnswer((realInvocation) => Future.value(mockUserCredential));

    when(mockBookDatabase.createUser(any)).thenAnswer((realInvocation) => Future.value("Success"));

    CurrentUser currentUser = CurrentUser(auth: mockFirebaseAuth);
    currentUser.bookDatabase = mockBookDatabase;

    expect(await currentUser.signUpUser("hello@hello.com", "hello123", "hello123"), "Success");
    verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: "hello@hello.com", password: "hello123"))
        .called(1);
  });

  test('signUpUser test fail', () async {
    final mockFirebaseAuth = TestMockFirebaseAuth();
    final mockBookDatabase = MockBookDatabase();
    final mockUserCredential = MockUserCredential();

    when(mockFirebaseAuth.createUserWithEmailAndPassword(email: "hello@hello.com", password: "hello123"))
        .thenAnswer((realInvocation) => Future.value(mockUserCredential));

    when(mockBookDatabase.createUser(any)).thenAnswer((realInvocation) => Future.value("Error"));

    CurrentUser currentUser = CurrentUser(auth: mockFirebaseAuth);
    currentUser.bookDatabase = mockBookDatabase;

    expect(await currentUser.signUpUser("hello@hello.com", "hello123", "hello123"), "Error");
    verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: "hello@hello.com", password: "hello123"))
        .called(1);
  });
  
  test('loginUserWithEmail success', () async {
    final mockFirebaseAuth = TestMockFirebaseAuth();
    final mockBookDatabase = MockBookDatabase();
    final mockUserCredential = MockUserCredential();
    
    when(mockFirebaseAuth.signInWithEmailAndPassword(email: "hello@hello.com", password: "hello123"))
        .thenAnswer((realInvocation) => Future.value(mockUserCredential));
    
    when(mockBookDatabase.getUserInfo(any)).thenAnswer((realInvocation) => Future.value(Bookworm()));

    CurrentUser currentUser = CurrentUser(auth: mockFirebaseAuth);
    currentUser.bookDatabase = mockBookDatabase;

    expect(await currentUser.loginUserWithEmail("hello@hello.com", "hello123"), "Success");
    verify(mockFirebaseAuth.signInWithEmailAndPassword(email: "hello@hello.com", password: "hello123"))
        .called(1);
    verify(mockBookDatabase.getUserInfo(any))
        .called(1);
  });

  test('loginUserWithEmail fail', () async {
    final mockFirebaseAuth = TestMockFirebaseAuth();
    final mockBookDatabase = MockBookDatabase();
    final mockUserCredential = MockUserCredential();

    when(mockFirebaseAuth.signInWithEmailAndPassword(email: "hello@hello.com", password: "hello123"))
        .thenAnswer((realInvocation) => Future.value(mockUserCredential));

    when(mockBookDatabase.getUserInfo(any)).thenAnswer((realInvocation) => Future.value(null));

    CurrentUser currentUser = CurrentUser(auth: mockFirebaseAuth);
    currentUser.bookDatabase = mockBookDatabase;

    expect(await currentUser.loginUserWithEmail("hello@hello.com", "hello123"), "Error");
    verify(mockFirebaseAuth.signInWithEmailAndPassword(email: "hello@hello.com", password: "hello123"))
        .called(1);
    verify(mockBookDatabase.getUserInfo(any))
        .called(1);
  });
  
  test('saveInfo success', () async {
    final mockFirebaseAuth = TestMockFirebaseAuth();
    final mockBookDatabase = MockBookDatabase();
    Bookworm tempUser = Bookworm(
        uid: "werjkwarlkwj",
        photoIndex: 14,
        name: "hello",
        username: "hello",
        email: "hello@hello.com",
        accountCreated: Timestamp.now()
    );
    
    when(mockBookDatabase.setUserInfo(tempUser.uid, 3, "new name")).thenAnswer((realInvocation) => Future.value(null));
    when(mockBookDatabase.getUserInfo(tempUser.uid)).thenAnswer((realInvocation) => Future.value(Bookworm(
        uid: "werjkwarlkwj",
        photoIndex: 3,
        name: "new name",
        username: "hello",
        email: "hello@hello.com",
        accountCreated: Timestamp.now()
    )));

    CurrentUser currentUser = CurrentUser(auth: mockFirebaseAuth);
    currentUser.bookDatabase = mockBookDatabase;
    currentUser.currentUser = tempUser;

    await currentUser.saveInfo(3, "new name");
    verify(mockBookDatabase.setUserInfo(tempUser.uid, 3, "new name")).called(1);
    verify(mockBookDatabase.getUserInfo(tempUser.uid)).called(1);
    expect(currentUser.getCurrentUser.photoIndex, 3);
    expect(currentUser.getCurrentUser.name, "new name");
  });

  test('signIn method with google', () async {
    final mockFirebaseAuth = TestMockFirebaseAuth();
    final mockBookDatabase = MockBookDatabase();
    final mockUserCredential = MockUserCredential();
    final testMockGoogleSignIn = TestMockGoogleSignIn();
    final _user = Bookworm(
      uid: mockUserCredential.user.uid,
      email: mockUserCredential.user.email,
      username: mockUserCredential.user.displayName,
      name: mockUserCredential.user.displayName,
      photoIndex: 15
    );

    when(mockFirebaseAuth.signInWithCredential(any))
        .thenAnswer((realInvocation) => Future.value(mockUserCredential));

    when(mockBookDatabase.createUser(_user)).thenAnswer((realInvocation) => null);

    when(mockBookDatabase.getUserInfo(mockUserCredential.user.uid))
        .thenAnswer((realInvocation) => Future.value(Bookworm(
      uid: mockUserCredential.user.uid,
      email: mockUserCredential.user.email,
      username: mockUserCredential.user.displayName,
      name: mockUserCredential.user.displayName,
      photoIndex: 15,
      accountCreated: Timestamp.now(),
    )));

    CurrentUser currentUser = CurrentUser(auth: mockFirebaseAuth);
    currentUser.bookDatabase = mockBookDatabase;
    currentUser.googleSignIn = testMockGoogleSignIn;


    expect(await currentUser.loginUserWithGoogle(), "Success");
    verify(mockBookDatabase.getUserInfo(mockUserCredential.user.uid)).called(1);

  });
}