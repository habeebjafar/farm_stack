
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class PaymentTest extends StatefulWidget {
  const PaymentTest({ Key? key }) : super(key: key);

  @override
  State<PaymentTest> createState() => _PaymentTestState();
}



class _PaymentTestState extends State<PaymentTest> {



  List<PaymentItem> paymentItems = [];

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: '999.99',
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text("Google Pay"),
            GooglePayButton(
                  // onPressed: () => payPressed(address),
                  width: double.infinity,
                  paymentConfigurationAsset: 'gpay.json',
                  onPaymentResult: onGooglePayResult,
                  paymentItems: paymentItems,
                  height: 50,
                  style: GooglePayButtonStyle.black,
                  type: GooglePayButtonType.pay,
                  margin: const EdgeInsets.only(top: 15),
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          ],
        ),
        
      ),
    );
  }
}