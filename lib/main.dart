import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  dynamic uri;
  // uri = await getInitialLink();
  // uri ??= await getInitialUri();
  runApp(MyApp(initialRoute: uri));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialRoute});
  final dynamic initialRoute;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String route = "/";

  @override
  void initState() {
    // listenShareMediaFiles(context);
    super.initState();
    initMethodChannel();
    // initUnilink(context);
    // uriLinkStream.listen((Uri? uri) {
    //   Fluttertoast.showToast(msg: "Uri $uri");
    //   if (!mounted) return;
    //   handleNFC(uri);
    // }, onError: (err) {
    //   Fluttertoast.showToast(msg: 'Error: $err');
    // });
  }

  void initMethodChannel() async {
    MethodChannel channel = const MethodChannel("com.example.flutter_app/nfc");
    try {
      final res = await channel.invokeMethod("handleNFC");
      Fluttertoast.showToast(msg: 'CHANNEL: $res');
      handleNFC(res);
    } catch (e) {
      Fluttertoast.showToast(msg: 'CHANNEL ERROR: $e');
      handleNFC(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: route,
      routes: {
        "/": (context) => MyHomePage(
            title: 'Flutter Demo Home Page', arg: widget.initialRoute),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  void initUnilink(BuildContext context) async {
    dynamic initialLink;
    try {
      initialLink = await getInitialLink();
      initialLink ??= await getInitialUri();
    } on PlatformException {
      initialLink = null;
    } on FormatException {
      initialLink = null;
    }
    Fluttertoast.showToast(msg: "Uri $initialLink");
    if (initialLink != null) {
      handleNFC(initialLink);
    }
  }

  void handleNFC(dynamic uri) {
    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => MyHomePage(title: "NFC", arg: uri)));
    }
  }

  void listenShareMediaFiles(BuildContext context) {
    // For sharing images coming from outside the app
    // while the app is in the memory

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    ReceiveSharingIntent.getTextStreamAsUri().listen((value) {
      navigate(context, value);
    }, onError: (err) {
      debugPrint("$err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialTextAsUri().then((value) {
      navigate(context, value);
    });
  }

  void navigate(BuildContext context, dynamic value) {
    if (value != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => MyHomePage(title: "NFC", arg: value)));
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.arg});

  final String title;
  final dynamic arg;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${widget.arg}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
