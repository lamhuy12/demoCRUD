import 'package:flutter/material.dart';

import 'db/database.dart';
import 'model/category.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SqliteApp());
}

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  int? selectedId;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: textController,
          ),
        ),
        body: FutureBuilder<List<Grocery>>(
          future: DatabaseHelper.instance.getGoceries(),
          builder: (BuildContext context, AsyncSnapshot<List<Grocery>> snapshot){
            //hasn't data
            if(!snapshot.hasData)
              {
                return Center(child: Text('Loading...'),);
              }
            //has data
            return snapshot.data!.isEmpty ? Center(child: Text('No Groceries in list'),)
            : ListView(
              children: snapshot.data!.map((grocery)
              {return Center(
                 child: Card(
                   color: selectedId == grocery.id
                   ? Colors.white70
                   : Colors.white,
                   child: ListTile(
                     onTap: () {
                       setState(() {
                         if(selectedId == null)
                           {
                             //
                             selectedId = grocery.id!;
                             //
                             textController.text = grocery.name;
                           }
                         else
                           {
                             //
                             selectedId = null;
                             //
                             textController.text = '';
                           }
                       });
                     },
                     onLongPress: () {
                       setState(() {
                         DatabaseHelper.instance.remove(grocery.id!);
                       });
                     },
                     title: Text(grocery.name),
                   ),
                 ),
               );}
              ).toList()
            );
          },
        ),
        floatingActionButton:  FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () async {
            selectedId != null
                ? await DatabaseHelper.instance.update(Grocery(id: selectedId, name: textController.text))
                : await DatabaseHelper.instance.add(Grocery(name: textController.text));
           setState(() {
             textController.clear();
           });
            },),
      ),
    );
  }
}





