import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<List<String>> items = List.generate(3, (_) => List.filled(3, ''));

  bool playerX = true;
  String? winner = "";

  void tappedItem(int col, int row) {
    if (items[col][row] != '') {
      return;
    }
    if(allFilled()){
      resetGame();
    }


    setState(() {
      items[col][row] = playerX ? 'X' : 'O';
      playerX = !playerX;
    });

    winner = winnerCheck();

    if (winner != null) {
      CustomAlert().show(context, winner!);
      resetGame();
    }
  }

  // if all are filled no one can move
  bool allFilled() {
    for (var row in items) {
      for (var cell in row) {
        if (cell == '') {
          return false;
        }
      }
    }
    return true;
  }

  // Resets the game state
  void resetGame() {
    setState(() {
      items = List.generate(3, (_) => List.filled(3, ''));
      playerX = true;
    });
  }

  String? winnerCheck() {
    for (int i = 0; i < 3; i++) {
      if (items[i][0] != '' &&
          items[i][0] == items[i][1] &&
          items[i][1] == items[i][2]) {
        return items[i][0];
      }
    }

    for (int i = 0; i < 3; i++) {
      if (items[0][i] != '' &&
          items[0][i] == items[1][i] &&
          items[1][i] == items[2][i]) {
        return items[0][i];
      }
    }

    if (items[0][0] != '' &&
        items[0][0] == items[1][1] &&
        items[1][1] == items[2][2]) {
      return items[0][0];
    }

    if (items[0][2] != '' &&
        items[0][2] == items[1][1] &&
        items[1][1] == items[2][0]) {
      return items[0][2];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "T I C T A C T O E",
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            playerX ? "X's Turn" : "O's Turn",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: playerX ? Colors.red : Colors.blue,
            ),
          ),
          const SizedBox(height: 15),

          // Game Box
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (col) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (row) {
                  return GestureDetector(
                    onTap: () => tappedItem(col, row),
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(4),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white54,
                            blurRadius: 1,
                            offset: Offset(2, 2),
                          ),
                        ],
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        items[col][row],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color:
                              items[col][row] == 'X'
                                  ? Colors.red
                                  : (items[col][row] == 'O'
                                      ? Colors.blue
                                      : Colors.black),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),

          const SizedBox(height: 13),

          // Reset Button
          SizedBox(
            width: 260,
            child: ElevatedButton(
              onPressed: resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3085FE),
                padding: const EdgeInsets.all(15),
              ),
              child: const Text('Reset', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAlert {
  show(BuildContext context, String winner) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Center(child: Text("Game Ended")),
          content: SizedBox(
            height: 20,
            child: Center(
              child: Text(
                "Winner is Player $winner",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: 260,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3085FE),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text('Ok', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }
}
