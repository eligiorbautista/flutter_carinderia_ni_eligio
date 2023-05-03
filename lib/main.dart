import 'package:flutter/material.dart';

List<String> dishList = [
  "Pork Adobo",
  "Sinigang",
  "Menudo",
  "Sinampalukan",
  "Afritada",
  "Bistek",
  "Bulalo",
  "Kare-kare"
];

Map<String, double> priceMap = {
  "Pork Adobo": 60.0,
  "Sinigang": 70.0,
  "Menudo": 50.0,
  "Sinampalukan": 60.0,
  "Afritada": 50.0,
  "Bistek": 60.0,
  "Bulalo": 90.0,
  "Kare-kare": 120.0
};

List<String> orderList = [];
List<double> priceList = [];
List<int> qtyList = [];
double totalPrice = 0.0;
void main() {
  runApp(const CarinderiaApp());
}

class CarinderiaApp extends StatelessWidget {
  const CarinderiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropDownValue = dishList.first;
  final qtyController = TextEditingController();
  final paymentController = TextEditingController();
  double paymentChange = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Carinderia ni Eligio",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 110, 7),
      ),
      body: ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 5,
            shadowColor: Colors.black,
            child: ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text(orderList[index]),
                subtitle: Text("Qty: ${qtyList[index]}"),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      orderList.removeAt(index);
                      priceList.removeAt(index);
                      qtyList.removeAt(index);
                    });
                  },
                )),
          );
        },
      ),
      bottomNavigationBar: SizedBox(
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 110, 7)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.payments_sharp),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Pay",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            onPressed: () {
              computeTotalPrice();
              // PAY ORDER SHOW DIALOG
              showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (BuildContext? context, StateSetter setState) {
                      return AlertDialog(
                        title: const Text("Pay Order"),
                        content: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text("Total Amount To Pay: ₱ $totalPrice"),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: paymentController,
                                decoration: const InputDecoration(
                                    hintText: "Enter Payment"),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                computeTotalPrice();
                                paymentController.clear();
                                closeAlert();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 44, 7),
                                  padding: const EdgeInsets.all(8)),
                              child: const Text("Cancel")),
                          ElevatedButton(
                              onPressed: () {
                                if (paymentController.text.isNotEmpty) {
                                  computePayment();

                                  closeAlert();
                                  completeOrder();
                                  clearList();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 255, 106),
                                  padding: const EdgeInsets.all(8)),
                              child: const Text(
                                "Pay",
                                style: TextStyle(color: Colors.black),
                              )),
                        ],
                      );
                    });
                  });
            },
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          computeTotalPrice();
          // ADD ORDER SHOW DIALOG
          showDialog<Widget>(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext? context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text("Add Order"),
                    content: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SELECT PAGKAIN
                          Row(
                            children: const [
                              Text("Select a meal"),
                            ],
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: dropDownValue,
                            icon: const Icon(Icons.arrow_drop_down_sharp),
                            onChanged: (String? value) {
                              setState(() {
                                dropDownValue = value!;
                              });
                            },
                            items: dishList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          Row(
                            children: [
                              Text(
                                  "₱ ${priceMap[dropDownValue]} per serving/s"),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: qtyController,
                            decoration: const InputDecoration(hintText: "Qty"),
                          )
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            closeAlert();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 44, 7),
                              padding: const EdgeInsets.all(8)),
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            if (qtyController.text.isNotEmpty) {
                              addOrder();
                              closeAlert();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 255, 106),
                              padding: const EdgeInsets.all(8)),
                          child: const Text(
                            "Done",
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  );
                });
              });
        },
        backgroundColor: const Color.fromARGB(255, 255, 106, 7),
        label: const Text(
          "Add",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        icon: const Icon(Icons.add_circle_outlined),
      ),
    );
  }

  clearList() {
    setState(() {
      orderList.clear();
      priceList.clear();
    });
  }

  completeOrder() {
    // COMPLETE ORDER SHOW DIALOG
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext? context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Payment Successful"),
              content: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "THANK YOU",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Your payment has been recieved.",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Change: ₱ $paymentChange ",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  computeTotalPrice() {
    totalPrice = priceList.fold(0.0, (prev, curr) => prev + curr);
  }

  computePayment() {
    setState(() {
      paymentChange = double.parse(paymentController.text) - totalPrice;
      completeOrder();
    });
  }

  addOrder() {
    setState(() {
      orderList.add(dropDownValue);
      var totalPrice = int.parse(qtyController.text) *
          double.parse(priceMap[dropDownValue].toString());
      priceList.add(totalPrice);
      qtyList.add(int.parse(qtyController.text));
      qtyController.clear();
      computeTotalPrice();
    });
  }

  closeAlert() {
    Navigator.pop(context);
  }
}
