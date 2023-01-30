import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyAppPage());
}

class MyAppPage extends StatelessWidget {
  const MyAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechStarted = false;
  String _lastWord = '';
  Duration timer = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechStarted = await _speechToText.initialize();
    setState(() {});
  }

//to start the speech listening
  void _startListening() async {
    debugPrint(timer.inSeconds.toString());
    await _speechToText.listen(
        onResult: _onSpeechResult, listenFor: const Duration(minutes: 5));
    setState(() {});
  }

//can't
  bool? cantRecognize() {
    _speechToText.hasRecognized;
  }

//Stop the speech listening
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWord = result.recognizedWords;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(backgroundColor: Colors.deepOrange.shade500)),
      home: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Speech to Text",
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    _speechToText.isListening
                        ? _lastWord
                        : _speechStarted
                            ? 'Tap the microphone to start listening...'
                            : 'Speech not available',
                    style: const TextStyle(fontSize: 35),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          repeat: true,
          showTwoGlows: true,
          glowColor: Colors.deepOrange.shade500,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 2000),
          animate: _speechToText.isNotListening ? false : true,
          endRadius: 50,
          child: GestureDetector(
            onTap:
                _speechToText.isNotListening ? _startListening : _stopListening,
            child: CircleAvatar(
              backgroundColor: Colors.deepOrange.shade500,
              maxRadius: 30,
              child: Icon(
                _speechToText.isNotListening
                    ? Icons.mic_off_rounded
                    : Icons.mic_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
