import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_todo_app/models/Todo.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:word_generator/word_generator.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);

   final hubSubscription =
   Amplify.Hub.listen(HubChannel.Auth, (AuthHubEvent hubEvent) async {
     if (hubEvent.eventName == 'SIGNED_OUT') {
       try {
         await Amplify.DataStore.clear();
         safePrint('DataStore is cleared as the user has signed out.');
       } on DataStoreException catch (e) {
         safePrint('Failed to clear DataStore: $e');
       }
     }
   });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Home page'),
        actions: [
          IconButton(onPressed: (){
            final wordGenerator = WordGenerator();
            var word = wordGenerator.randomName();
            var words = wordGenerator.randomNouns(6).toList();
            final todo = Todo(
              name: word,
              description: "${words.elementAt(0)} ${words.elementAt(1)}"
                  " ${words.elementAt(2)} ${words.elementAt(3)} ${words.elementAt(4)}"
                  " ${words.elementAt(5)}",
            );
            Amplify.DataStore.save(todo);
          },
              icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Welcome to Home page'),
          Expanded(
              child: StreamBuilder<QuerySnapshot<Todo>>(
                stream: Amplify.DataStore.observeQuery(Todo.classType),
                builder: (context,snapshot){
                  if(snapshot.data == null){
                    print('snapshot.data == null====> ${snapshot.data}' );
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else{
                    print('snapshot.data != null====> ${snapshot.data!.items.length}' );
                    return ListView.builder(
                      itemCount: snapshot.data!.items.length,
                        itemBuilder: (context,index){
                        return ListTile(
                          title: Text(snapshot.data!.items[0].name),
                          subtitle: Text(snapshot.data!.items[index].description ?? ''),
                        );
                    });
                  }
                },
              ),
          ),
          SignOutButton()
        ],
      ),
    );
  }
}
