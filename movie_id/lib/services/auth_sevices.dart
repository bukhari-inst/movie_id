part of 'services.dart';

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<SignInSignUpResult> signUp(String email, String password,
      String name, List<String> selectedGenres, String selectedLanguage) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // convert firebaseUser menjadi user
      User user = result.user.convertToUser(
          name: name,
          selectedGenres: selectedGenres,
          selectedLanguage: selectedLanguage);

      // simpan ke firestore
      await UserServices.updateUser(user);

      return SignInSignUpResult(user: user); //kalo berhasil kembaliannya user
    } catch (e) {
      // ambil string message urutan yg ke 1
      return SignInSignUpResult(message: e.toString().split(',')[1].trim());
    }
  }

// proses signIn
  static Future<SignInSignUpResult> signIn(
      String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = await result.user.fromFireStore();

      return SignInSignUpResult(user: user);
    } catch (e) {
      return SignInSignUpResult(message: e.toString().split(',')[1].trim());
    }
  }

// proses singout
  static Future<void> signOut() async {
    await _auth.signOut();
  }

// proses reset pass
  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

// proses autentikasi signIn signOut dengan main page
  static Stream<FirebaseUser> get userStream => _auth.onAuthStateChanged;
}

class SignInSignUpResult {
  final User user;
  final String message;

  SignInSignUpResult({this.user, this.message});
}
