import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harithakarma/Screens/Homeuser/profile.dart';
import 'package:harithakarma/Shared/format_timestamp.dart';
import 'package:harithakarma/database.dart';
import 'package:harithakarma/models/user.dart';
import 'package:harithakarma/service/auth.dart';
import 'package:harithakarma/Screens/Auth/login.dart';
import 'package:harithakarma/main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: homeSideDrawer(),
      appBar: AppBar(
        title: Text('Home user'),
        backgroundColor: Color.fromARGB(255, 23, 75, 7),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: DatabaseService()
                .getcollectionhistoryreference()
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("status", isEqualTo: "arriving today")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text("Collection agent:" +
                            documentSnapshot['collector_name']),
                        subtitle: Text("Status:" + documentSnapshot['status']),
                      ),
                    );
                  },
                );
              } else {
                return Text("Next collection details not available");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Text("Collection history"),
          StreamBuilder(
            stream: DatabaseService()
                .getcollectionhistoryreference()
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("status", isEqualTo: "collected")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    print(formatTimestamp(documentSnapshot['datetime']));
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ExpansionTileCard(
                        title: Text("Collected by:" +
                            documentSnapshot['collector_name']),
                        subtitle: Text("Date:" +
                            formatTimestamp(documentSnapshot['datetime'])),
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// return ListView.builder(
//   scrollDirection: Axis.vertical,
//   shrinkWrap: true,
//   itemCount: streamSnapshot.data!.docs.length,
//   itemBuilder: (context, index) {
//     final DocumentSnapshot documentSnapshot =
//         streamSnapshot.data!.docs[index];
//     return Padding(
//       padding: const EdgeInsets.all(1.0),
//       child: Card(
//         child: Column(children: [
//           Text("Field agent name:" +
//               documentSnapshot['collector_name']),
//           Text("Status:" + documentSnapshot['status'])
//         ]),
//       ),
//     );
//   },
// );
class homeSideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'HarithaKarma',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 23, 75, 7),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashbord'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => homeProfile()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('utype');
              AuthService().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
