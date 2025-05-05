import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String version = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    // Test Firestore connection
    testFirestoreConnection();

    // Initialize Firestore query stream
    _notificationsStream = _firestore
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots();

    print("Firestore stream initialized");
  }





  void _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version; // Get app version
    });
  }
  // Firestore connection test method
  void testFirestoreConnection() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('notes')
          .orderBy('timestamp', descending: true)
          .get();
      print('Fetched ${snapshot.docs.length} documents.');
    } catch (e) {
      print('Firestore connection failed: $e');
    }
  }

  // Refresh method to trigger the Firestore stream refresh
  Future<void> _refreshData() async {
    setState(() {
      // Force the stream to re-fetch the data
      _notificationsStream = _firestore
          .collection('notes')
          .orderBy('timestamp', descending: true)
          .snapshots();
    });
  }

  // Method to launch the URL


  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);

    try {
      // Test with a very simple URL
      final result = await canLaunchUrl(uri);
      print("Can launch: $result");
      if (result) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("Cannot launch URL: $url");
      }
    } catch (e) {
      print("Error launching URL: $e");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Notifications",style: TextStyle(fontFamily: 'Parkinsans')),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.left_chevron, color: Colors.white),
        ),
      ),
      bottomNavigationBar: Container(

        padding: EdgeInsets.all(10), // Add some padding
        alignment: Alignment.center,
        height: 60, // Give it a fixed height
        // Optional: Background color
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent it from expanding
          children: [
            Text(version),
            Text("Made With ❤️ By Siddhant Adhikari"),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: Colors.teal,

        onRefresh: _refreshData,
        child: StreamBuilder<QuerySnapshot>(
          stream: _notificationsStream,
          builder: (context, snapshot) {
            print("Connection State: ${snapshot.connectionState}");
            print("Has Error: ${snapshot.hasError}");
            print("Has Data: ${snapshot.hasData}");

            if (snapshot.connectionState == ConnectionState.waiting) {
              print("Waiting for data...");
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print("Snapshot error: ${snapshot.error}");
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              print("No notifications available.");
              return Center(child: Text("No notifications available."));
            }

            final docs = snapshot.data!.docs;
            print("Fetched ${docs.length} notifications.");

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final title = doc['title'] ?? 'No title';
                final content = doc['content'] ?? 'No content';
                final timestamp = doc['timestamp'] as Timestamp?;
                final button = doc['button'] as bool? ?? false;
                final link = doc['link'] ?? '';
                final formattedTime = timestamp != null
                    ? DateFormat("MMM dd, yyyy • h:mm a").format(timestamp.toDate())
                    : 'No timestamp';

                print("Notification ${index + 1}: Title = $title, Content = $content, Timestamp = $formattedTime");

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          formattedTime,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 12),
                        // Show button if 'button' field is true
                        if (button)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Launch the URL if the link is available
                                  if (link.isNotEmpty) {
                                    _launchURL(link);
                                  } else {
                                    print("No link provided for this notification.");
                                  }
                                },
                                icon: Icon(Icons.keyboard_double_arrow_right_outlined, color: Colors.teal),
                              ),
                            ],
                          ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
