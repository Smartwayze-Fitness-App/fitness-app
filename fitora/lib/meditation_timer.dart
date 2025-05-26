import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MeditationApp());
}

class MeditationApp extends StatelessWidget {
  const MeditationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MeditationScreen(),
    );
  }
}

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  MeditationScreenState createState() => MeditationScreenState();
}

class MeditationScreenState extends State<MeditationScreen> {
  int _secondsRemaining = 30;
  bool _isPlaying = false;
  bool _isSoundOn = true;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });

        if (_isSoundOn) {
          try {
            await _audioPlayer.play(
              AssetSource('sounds/beep.mp3'),
              volume: 1.0,
            );
          } catch (e) {
            debugPrint("Audio Error: $e");
          }
        }
      } else {
        await _audioPlayer.stop();
        _pauseTimer();
      }
    });

    setState(() {
      _isPlaying = true;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 30;
      _isPlaying = false;
    });
  }

  void _toggleSound() async {
    setState(() {
      _isSoundOn = !_isSoundOn;
    });

    if (!_isSoundOn) {
      await _audioPlayer.stop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = (30 - _secondsRemaining) / 30;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.green.shade900,
                          Colors.green.shade800,
                          Colors.green.shade700,
                        ],
                        radius: 0.85,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.lightGreenAccent.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (rect) {
                      return SweepGradient(
                        startAngle: 0.0,
                        endAngle: 3.14 * 2,
                        stops: [progress, progress],
                        center: Alignment.center,
                        colors: [
                          Colors.lightGreenAccent,
                          Colors.transparent,
                        ],
                      ).createShader(rect);
                    },
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                  Text(
                    "00:${_secondsRemaining.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isPlaying
                        ? _pauseTimer
                        : (_secondsRemaining == 0
                        ? _resetTimer
                        : _startTimer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      elevation: 6,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _toggleSound,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      elevation: 6,
                    ),
                    child: Icon(
                      _isSoundOn ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Inhale Peace, Exhale Stress",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
