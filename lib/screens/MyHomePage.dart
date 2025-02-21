import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectlavage/screens/signin_screen.dart';
 // Assurez-vous que le fichier existe

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Interface',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.rochesterTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gouttes d'eau visibles en fond

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/image.jpeg',
                  width: 500,
                  height: 240,
                ),
                SizedBox(height: 20),
                Text(
                  'Aghsalni',
                  style: GoogleFonts.rochester(
                    fontSize: 64,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00BCD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 90, vertical: 20), // Plus large
                  ),
                  child: Text(
                    'Démarrer',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                SizedBox(height: 50),
                // Trois points gris (Loading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterDrop(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(

      ),
    );
  }
}
