# Flutter 로 개발하는 Google 로그인 with Firebase

### 공통 변수
```dart
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
```

### 로그인
```dart
// Google Sign-In 시작
final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

// Google 인증 정보 가져오기
final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

// Firebase 에서 Google 사용자를 인증하기 위해서 GoogleAuthProvider.credential() 사용하여
// Firebase 인증자격(AuthCredential) 생성
final AuthCredential credential = GoogleAuthProvider.credential(
accessToken: googleAuth.accessToken,
idToken: googleAuth.idToken,
);

// FirebaseAuth 로 생성된 Firebase 인증자격을 사용하여 계정을 생성하거나 로그인 진행
final UserCredential userCredential =
    await _auth.signInWithCredential(credential);
final User? user = userCredential.user;
```
  
### 로그아웃
```dart
await _auth.signOut();
await _googleSignIn.signOut();
```

### 세션유지
```dart
final User? user = FirebaseAuth.instance.currentUser;
```