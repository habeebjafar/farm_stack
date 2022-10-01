
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({ Key? key }) : super(key: key);

  launchWhatsApp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+2347056642288',
      text: "Hello there",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launchUrl(Uri.parse('$link'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help and Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Any problem or suggestions of improvement?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            
            ),
            Divider(
     
              thickness: 1,
            ),
            Text(
              'Please click on the Whatsapp Message or Email icon on this screen and send us message. We shall reply to you as soon as possible',
               style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 16
              ),
              ),
            Row(
            children: [
              ElevatedButton(
                
                onPressed: () async{
                  await  launchWhatsApp();

                }, 
                child: Row(
                  children:[
                    Icon(Icons.phone_android_sharp),
                    SizedBox(width:10),
                    Text('Message Us')
                  ]
                ),
                ),
                SizedBox(width:10),
                 ElevatedButton(
                
                onPressed: () async{
                  await _sendEmail();
                }, 
                child: Row(
                  children:[
                    Icon(Icons.email),
                    SizedBox(width:10),
                    Text('Send  Email')
                  ]
                )
                )

            ],
            )


          ],
        ),
      ),
      
    );
  }

    String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

   _sendEmail() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'jafars4ab@gmail.com',
      query: encodeQueryParameters(
          <String, String>{'subject': 'From Cattle App'}),
    );

    launchUrl(emailLaunchUri);
  }



    // _displaySnackBar(String message) {
  //   final snackBar = SnackBar(
  //     content: Text("$message"),
  //     // action: SnackBarAction(
  //     //   label: 'Undo',
  //     //   onPressed: () {
  //     //     // Some code to undo the change.
  //     //   },
  //     // ),
  //     duration: Duration(seconds: 3),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

}