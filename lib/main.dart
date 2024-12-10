import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'tabsPage.dart';
import 'memoPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      navigatorObservers: [observer],
      // home: const MemoPage(), // 메모장 호출
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          
        },
      ),
    );
  }
}

class FirebaseApp extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const FirebaseApp({
    super.key,
    required this.analytics,
    required this.observer,
  });

  @override
  State<StatefulWidget> createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  late final FirebaseAnalytics? analytics;
  late final FirebaseAnalyticsObserver? observer;
  String _message = '';

  @override
  void initState() {
    super.initState();
    analytics = widget.analytics;
    observer = widget.observer;
  }

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    try {
      await widget.analytics.logEvent(
        name: 'test_event',
        parameters: {
          'string': 'hello flutter',
          'int': 100,
        },
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      setMessage('Analytics Success');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendAnalyticsEvent,
              child: const Text('테스트'),
            ),
            Text(
              _message,
              style: const TextStyle(color: Colors.blueAccent),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.tab),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            settings: const RouteSettings(name: '/tab'),
            builder: (BuildContext context) {
              return TabsPage(observer!);
            }
          ));
        },
      ),
    );
  }
}