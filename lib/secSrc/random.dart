import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  List<TextEditingController> controllers = [];
  final random = Random();
  bool isRandom = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers list with empty controllers
    controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark),
        title: const Text('Random'),
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
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: controllers.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    TextFormField(
                      controller: controllers[index],
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Type here',
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              controllers.removeAt(index);
                            });
                          },
                          child: const Icon(Icons.delete_forever_outlined),
                        ),
                      ),
                    ),
                  ],
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () => {
                        setState(() {
                          controllers.add(TextEditingController());
                        })
                      },
                  icon: const Icon(Icons.add)),
              IconButton(
                  onPressed: () => {
                        setState(() {
                          controllers.removeLast();
                        })
                      },
                  icon: const Icon(Icons.remove))
            ],
          ),
          isRandom == false
              ? Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        int randomNumber = random.nextInt(controllers.length);

                        isRandom = true;
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            isRandom = false;
                            openDialog(controllers[randomNumber].text);
                          });
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white54,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Random'),
                  ),
                )
              : const Column(
                  children: [
                    SpinKitChasingDots(
                      color: Colors.amberAccent,
                      size: 50.0,
                    ),
                    
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'getting the winner...',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Future openDialog(String string) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Center(child: Text('Congratuations 🎉 🎉',style: TextStyle(fontSize: 13),)),
            content: SelectableText(string,style: const TextStyle(fontWeight: FontWeight.bold),),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 5.0, color: Colors.transparent),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
            ],
          ));
}
