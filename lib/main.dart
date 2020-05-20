import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:wpqkfwha/widget/bottom_bar.dart';
import 'package:wpqkfwha/widget/wise_saying.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeWidget()
    );
  }
}

class AppState {
  bool loading;
  FirebaseUser user;
  AppState(this.loading, this.user);
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final app = AppState(false, null);
  @override
  Widget build(BuildContext context) {
    if (app.loading) return _loading();
    if (app.user == null) return _logIn();
    return _main();
  }
  Widget _loading () {
    return Scaffold(
        appBar: AppBar(title: Text('loading...')),
        body: Center(child: CircularProgressIndicator())
    );
  }
  Widget _logIn () {
    return Scaffold(
        appBar: AppBar(
            title: Text('일정뽀시기')
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    child: Text('google ID로 로그인'),
                    onPressed: () {
                      _signIn();
                    }
                )
              ],
            )
        )
    );
  }
  Widget _main () {
    return MaterialApp(
      title: 'PlanBreaker',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.white),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              WiseSaying(),    // 나중에 파이차트 부분이 구현완료 되면, if문으로 호출!
              Container(child: Center(child: Text('달성기록'))),
              Container(child: Center(child: Text('편지'))),
              Container(child: Center(child: Text('설정')))
            ],
          ),
          bottomNavigationBar: Bottom(),
        ),
      ),
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _signIn() async {
    setState(() => app.loading = true);
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    print(user);

    setState(() {
      app.loading = false;
      app.user = user;
    });

    return 'success';
  }
  /* 환경설정에서 구현!
  void _signOut() async{
    await googleSignIn.signOut();
    // await _auth.signOut();
    setState(() {
      app.user = null;
    });
  }
  */
}