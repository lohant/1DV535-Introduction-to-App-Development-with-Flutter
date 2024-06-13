import 'package:flutter/material.dart'; // Importerar Flutter Material-paketet

// Main-funtionen.
void main() {
  runApp(MyApp()); // runApp är den inbyggda Flutter-funktionen som initierar appen.
}

// MyApp är en stateless class, den har alltså inget tillstånd som kan ändras.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp är en inbyggd class i Flutter med basfunktioner.
    return MaterialApp(
      title: 'To-Do List', // Specificerar appens titel.
      debugShowCheckedModeBanner: false, // Tar bort debug-banner.
      home: TodoList(), // Specificerar appens startsida.
    );
  }
}

// TodoList är en stateful widget eftersom den håller states som kan ändras.
class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

// State classen som hör till TodoList. Här hålls statet och uppdateringar görs.
class _TodoListState extends State<TodoList> {
  // Lista innehållandes de initiala sakerna.
  var _todos = [
    'Handla mat', 
    'Färdigställa app-projekt', 
    'Anmäla mig till nya kurser',
    ];
  
  TextEditingController _controller = TextEditingController(); // TextEditingController kontrollerar och hanterar input.

  @override
  Widget build(BuildContext context) {
    // Scaffold är en layout-struktur som ger standardappfält, body och andra UI-element.
    return Scaffold(
      // AppBar innehåller en titel högst upp.
      appBar: AppBar(
        title: const Text('Anton\'s to-do list'), // Specificerar titeln.
      ),
      body: Padding( // Lägger till mellanrum.
        padding: const EdgeInsets.all(16.0),
        // Column är en layout-widget som placerar underliggande element (children) vertikalt.
        child: Column(
          // Children är en lista av widgets som ska visas vertikalt.
          children: [
            // TextField är en inmatningsruta för input från användaren.
            TextField(
              controller: _controller, // Kopplar input-fältet till controller.
              // Stylar input-fältet.
              decoration: const InputDecoration(
                labelText: 'Add or edit item', // Beskrivande text tillhörande input-fältet.
                border: OutlineInputBorder(), // Specificerar en outline-border kring input-fältet.
              ),
              onTap: () {},
            ),
            const SizedBox(height: 10), // Lägger till mellanrum mellan widgets.
            // FloatingActionButton lägger till text till listan.
            FloatingActionButton.extended(
              // onPressed exekveras när knappen trycks.
              onPressed: () {
                // setState meddelar att statet har ändrats och att UI behöver uppdateras.
                setState(() {
                  // Kontrollerar att input-fältet inte är tomt.
                  if (_controller.text.isNotEmpty) {
                    // Lägger till texten från input-fältet till listan.
                    _todos.add(_controller.text);
                    // Renar input-fältet.
                    _controller.clear();
                  }
                });
              },
              // Anger knappens text.
              label: const Text('Add item'),
              // Anger knappens ikon.
              icon: const Icon(Icons.add),
              backgroundColor: Colors.lightBlueAccent, // Anger knappens bakgrundsfärg.
            ),
            const SizedBox(height: 20), // Lägger till mellanrum.
            // Fyller ut resterande plats med ListView.
            Expanded(
              // ListView.builder skapar underliggande element (childern) vid behov.
              child: ListView.builder(
                itemCount: _todos.length, // Antal saker i listan.
                // itemBuilder skapar varje sak/rad i listan.
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.fiber_manual_record, color: Colors.grey, size: 10), // Ikon före varje list-text.
                    // The title property displays the text of the to-do item.
                    title: Text(_todos[index]), // Texten.
                    // onTap specificerar vad som händer när man trycker på en rad.
                    onTap: () {
                      // Flyttar texten från raden till input-fältet och tar bort den från listan.
                      setState(() {
                        _controller.text = _todos[index]; // Sätter input-fältets text till den tryckta radens text.
                        _todos.removeAt(index); // Tar bort den tryckta raden från listan.
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
