import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final random = Random();
  String s1 = '';
  String s2 = '';
  String s3 = '';
  String s4 = '';
  String s5 = '';
  String tooSoon = '';
  String startTimer = '';
  late Timer timer;
  int seconds = 0;

  void startTimer1() {
    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    if (timer.isActive) {
      timer.cancel();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String getFormattedTime(int milliseconds) {
    double seconds = milliseconds / 500;
    return seconds.toStringAsFixed(3); // Format seconds with 3 decimal places
  }

  @override
  Widget build(BuildContext context) {
    int randomNumber = random.nextInt(3) + 1;
    return GestureDetector(
      onTap: () => s1 == 'N'
          ? setState(() {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Too Soon!!')));
            })
          : startTimer == ''
              ? {
                  setState(() {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      setState(() {
                        seconds = 0;
                        s1 = 'N';
                      });
                    });
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        s2 = 'N';
                      });
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        s3 = 'N';
                      });
                    });
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        s4 = 'N';
                      });
                    });
                    Future.delayed(const Duration(seconds: 4), () {
                      setState(() {
                        s5 = 'N';
                      });
                    }).then((value) =>
                        Future.delayed(Duration(seconds: randomNumber), () {
                          setState(() {
                            startTimer1();
                            s1 = '';
                            startTimer = 'N';
                          });
                        }));
                  })
                }
              : {
                  setState(() {
                    timer.cancel();
                    s1 = '';
                    s2 = '';
                    s3 = '';
                    s4 = '';
                    s5 = '';
                    tooSoon = '';
                    startTimer = '';
                  })
                },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark),
          title: const Text('F1 Reaction Test'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            startTimer == ''
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      s1 == ''
                          ? const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                              ],
                            )
                          : const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      s2 == ''
                          ? const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                              ],
                            )
                          : const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      s3 == ''
                          ? const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                              ],
                            )
                          : const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      s4 == ''
                          ? const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                              ],
                            )
                          : const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      s5 == ''
                          ? const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                              ],
                            )
                          : const Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black54,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
            Center(child: Text('${getFormattedTime(seconds)} seconds')),
                  const SizedBox(height: 40,),

            Center(
                child: Text(s1 == ''
                    ? 'Tap any where to start'
                    : 'Tap any where to stop',style: const TextStyle(color: Colors.grey),))
          ],
        ),
      ),
    );
  }
}
