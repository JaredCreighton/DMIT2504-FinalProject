import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(AdventureQuestApp());
  retrieveEndings().then((endings) {
    print('Collected endings: $endings');
  });
}

class AnimatedAdventureButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const AnimatedAdventureButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  _AnimatedAdventureButtonState createState() =>
      _AnimatedAdventureButtonState();
}

class _AnimatedAdventureButtonState extends State<AnimatedAdventureButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.blue,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdventureQuestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdventureQuest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroductionView(),
    );
  }
}

Future<List<String>> retrieveEndings() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> collectedEndings =
        prefs.getStringList('collected_endings') ?? [];
    return collectedEndings;
  } catch (e) {
    // Handle error gracefully (e.g., log the error or provide a default value)
    print('Error retrieving endings: $e');
    return []; // Return a default value or handle the error as appropriate
  }
}

Future<void> addEnding(String ending) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> collectedEndings =
        prefs.getStringList('collected_endings') ?? [];
    collectedEndings.add(ending);
    await prefs.setStringList('collected_endings', collectedEndings);
  } catch (e) {
    // Handle error gracefully (e.g., log the error or show a snackbar)
    print('Error adding ending: $e');
  }
}

class IntroductionView extends StatefulWidget {
  @override
  _IntroductionViewState createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  String endingsInfo = '0/7 Endings'; // Initial value

  @override
  void initState() {
    super.initState();
    updateEndingsInfo(); // Fetch and update the endings information
  }

// Function to retrieve the number of endings achieved
  Future<void> updateEndingsInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> collectedEndings =
          prefs.getStringList('collected_endings') ?? [];
      setState(() {
        endingsInfo = '${collectedEndings.length}/7 Endings';
      });
    } catch (e) {
      // Handle error gracefully (e.g., log the error or show a snackbar)
      print('Error updating endings info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AdventureQuest: The Chronicles of Evermore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to AdventureQuest: The Chronicles of Evermore!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'In this thrilling interactive adventure, you will embark on a journey through the mystical kingdom of Evermore. Your choices will shape the destiny of the realm and determine the fate of its inhabitants. Are you ready to face the challenges that lie ahead?',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              endingsInfo, // Display the number of endings achieved
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            AnimatedAdventureButton(
              onPressed: () {
                // Navigate to the first chapter
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdventureQuestHome()),
                );
              },
              text: 'Begin your adventure',
            ),
          ],
        ),
      ),
    );
  }
}

class AdventureQuestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AdventureQuest: The Chronicles of Evermore'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chapter 1: The Call to Adventure',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'As you wander the quiet streets of your village, a mysterious figure approaches you with a message. He says that your village will be attacked soon and you must prepare',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 2 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chapter2()),
                );
              },
              child: Text('Accept the quest'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 2 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ending6()),
                );
              },
              child: Text('Ignore the prophecy'),
            ),
          ],
        ),
      ),
    );
  }
}

class Chapter2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter 2: The Trials of Valor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chapter 2: The Trials of Valor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'In order to prove your worthiness as the chosen hero, you must undergo a series of grueling trials. Will you face them head-on or seek alternative paths to victory?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 3 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chapter3()),
                );
              },
              child: Text('Face the trials head-on'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 3 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chapter3b()),
                );
              },
              child: Text('Seek alternative paths'),
            ),
          ],
        ),
      ),
    );
  }
}

class Chapter3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter 3: The Enigma of the Ancients'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chapter 3: The Enigma of the Ancients',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'As you make your way through the trails you eventully reach the end where a spirit awaits you',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 4 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chapter4()),
                );
              },
              child: Text('Greet the spirt'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 4 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ending9()),
                );
              },
              child: Text('Attack the spirt'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 4 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ending10()),
                );
              },
              child: Text('Run from the spirt'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class Chapter3b extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter 3: What about the Village'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chapter 3: What about the Village',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'you cant lave your village in the dust so you must choose what to do about the attack',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 4 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ending7()),
                );
              },
              child: Text('Prepare your village to fight'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 4 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ending8()),
                );
              },
              child: Text('Evacuate your village'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class Chapter4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter 4: The Battle for Evermore'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chapter 4: The Battle for Evermore',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'The spirt grants you the power to fight off the attack will you go alone or with your village',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 5 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ending1()),
                );
              },
              child: Text('Fight Alone'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Chapter 5 view
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ending2()),
                );
              },
              child: Text('Fight alongside the village'),
            ),
          ],
        ),
      ),
    );
  }
}

class Ending1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ending: A True Hero'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You take on the attack alone and manage to stop the attack but at the cost of your life. You are forever remembered as a Hero',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home screen
                addEnding('Ending: A True Hero');
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Return to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

// Define the other endings in a similar manner...

class Ending2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ending: True Victory'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You gather the village and take on the attack together and manage to fight of the attack your village is saved',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home screen
                addEnding('Ending: True Victory');
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Return to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class Ending6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ending: Village is destroyed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You ingnore the message and you village is destoryed in a battle',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home screen
                addEnding('Ending: Village is destroyed');
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Return to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class Ending7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ending: A bad fight'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'you perpare you village for battle however without haveing undergone the trails you are not strong enough to defeat your foes',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home screen
                addEnding('Ending: A bad fight');
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Return to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class Ending8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ending: A Quick Exit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You evacuate the villgers and you all make it safely out but your village is destroyed',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home screen
                addEnding('Ending: A Quick Exit');
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Return to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class Ending9 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ending: a fight the did not end well'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You attack the spirt only to be overwelmed by its power and you meet your demise',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home screen
                addEnding('Ending: a fight the did not end well');
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Return to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class Ending10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ending: Run'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You Run from the spirt. Your too ashemed to return to your village so you leave it to be destoyed',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home screen
                addEnding('Ending: Run');
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Return to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}




// Define the remaining endings similarly...

