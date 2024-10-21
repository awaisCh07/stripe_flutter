import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_project/payment.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<String> currencyList = <String>['PKR', 'USD', 'EUR', 'JPY', 'GBP', 'AED'];
  String selectedCurrency = 'PKR';

  bool hasPaid = false;

  void _resetForm() {
    amountController.clear();
    nameController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pinCodeController.clear();
    selectedCurrency = 'PKR';
  }

  Future<void> initPaymentSheet() async {
    try {
      final data = await createPaymentIntent(
        amount: (int.parse(amountController.text) * 100).toString(),
        currency: selectedCurrency,
        name: nameController.text,
        address: addressController.text,
        pin: pinCodeController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.light,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stripe Payment"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme, // Call the toggle theme function
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/image.webp",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                hasPaid
                    ? PaymentSuccessWidget(
                  amountController.text,
                  selectedCurrency,
                  onPayAgain: () {
                    setState(() {
                      hasPaid = false;
                      _resetForm();
                    });
                  },
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Information",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: "Amount",
                      controller: amountController,
                      hint: "Enter amount",
                      isNumber: true,
                    ),
                    SizedBox(height: 20),
                    _buildCurrencyDropdown(),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: "Full Name",
                      controller: nameController,
                      hint: "Enter your name",
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: "Address",
                      controller: addressController,
                      hint: "123 Main St",
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: "City",
                            controller: cityController,
                            hint: "City",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            label: "State",
                            controller: stateController,
                            hint: "State",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: "Country Code",
                            controller: countryController,
                            hint: "PK, US, UK",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            label: "Postal Code",
                            controller: pinCodeController,
                            hint: "123456",
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await initPaymentSheet();
                            try {
                              await Stripe.instance.presentPaymentSheet();
                              setState(() {
                                hasPaid = true;
                              });
                            } catch (e) {
                              print("Payment failed: $e");
                            }
                          }
                        },
                        child: Text("Proceed to Payment", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Currency",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: selectedCurrency,
      onChanged: (String? value) {
        setState(() {
          selectedCurrency = value!;
        });
      },
      items: currencyList.map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
    );
  }
}

class PaymentSuccessWidget extends StatelessWidget {
  final String amount;
  final String currency;
  final VoidCallback onPayAgain;

  PaymentSuccessWidget(this.amount, this.currency, {required this.onPayAgain});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Payment Successful!",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        SizedBox(height: 10),
        Text(
          "You've paid $amount $currency",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: onPayAgain,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Pay Again", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
