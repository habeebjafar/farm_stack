import 'package:farmapp/pages/newhomepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:farmapp/services/initiliaze_paystack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmapp/auth/paystackkeys.dart';
class PaystackPaymentPage extends StatefulWidget {
  const PaystackPaymentPage({ Key? key }) : super(key: key);

  @override
  State<PaystackPaymentPage> createState() => _PaystackPaymentPageState();
}

class _PaystackPaymentPageState extends State<PaystackPaymentPage> {
 bool isGeneratingCode = false;
    late PaystackPlugin paystackPlugin = PaystackPlugin();

  @override
  void initState() {
   paystackPlugin.initialize(
        
         publicKey: "$payKeys");
    chargeCard();
    super.initState();
  }



  Dialog successDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_box,
                color: Colors.orange,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Payment has successfully',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'been made',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Your payment has been successfully",
                style: TextStyle(fontSize: 13),
              ),
              Text("processed.", style: TextStyle(fontSize: 13)),
              TextButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewHomeScreen(),
                      ));
                },
                child: Text("Reload App"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return successDialog(context);
      },
    );
  }

  Dialog errorDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context);
      },
    );
  }

  chargeCard() async {
    setState(() {
      isGeneratingCode = !isGeneratingCode;
    });

    Map accessCode = await createAccessCode(
        //"sk_live_ff7998bc3beb8c344c82421d58c2bfd33e961fd2"
        "sk_test_8c3ada1bedbdf69f78b042862196b7b43a24d1d9"
        );

   

    Charge charge = Charge()
      ..amount = 250000
      ..accessCode = accessCode["data"]["access_code"]
      ..email = 'support@teacha.com.ng';
    CheckoutResponse response = await paystackPlugin.checkout(
      context,
      method:
          CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    if (response.status == true) {

      SharedPreferences _prefs = await SharedPreferences.getInstance();
      //bool _isSubscribed;
      _prefs.setInt("subscribed", 1);
      // _paystackPayment();

      _showDialog();
    } else {
      _showErrorDialog();
    }
     setState(() {
      isGeneratingCode = !isGeneratingCode;
    });
  }


  //   _paystackPayment() async{
  //   PaystackService service = PaystackService();
  //    var payStack = PayStack();
  //   payStack.paystackpayment = "500";
  //   var paystackData = await service.paystackPayment(payStack);
  //   var reponse = json.decode(paystackData.body);

  //   if(reponse['result'] == 'successful'){
  //     //print('paid suceesfully');
  //   }
  //   else{
  //     //print('paid failed');
  //   }
   

    
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(
          "Premium Activation",
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: TextButton(
              child: Text(
                isGeneratingCode ? "Processing.." : "Try again",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () => chargeCard(),
            ),
          )),
    );
  }



}