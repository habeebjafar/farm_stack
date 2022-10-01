import 'package:farmapp/pages/paystack_payment._page.dart';
import 'package:flutter/material.dart';

class PremiumWidget {
  
    static activateDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "DISMISS",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () async {
                    
                    Navigator.pop(context);
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) =>  PaystackPaymentPage())
                     );
                  },
                  child: Text(
                    "Activate",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              title: Text("Activate Premium"),
              content: Text('''Pay once, get lifetime access! ₦(NGN)2500
               \n1. Remove Ads. \n2. Milk Report. \n3. Events Report. \n4. Cattle Details Report. \n5. Cash Flow Report. \n6. Export All Reports To PDF. \n7. Data Backup And Restore''')
              );
        });
  }
}