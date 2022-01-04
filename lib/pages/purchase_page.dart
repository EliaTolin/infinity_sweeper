import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:infinity_sweeper/api/purchase_api.dart';
import 'package:infinity_sweeper/widgets/paywall_widget.dart';
import 'package:purchases_flutter/object_wrappers.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  bool isReady = false;
  bool isFound = false;
  List<Package> packages = [];

  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In App Purchase 1.0.8'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isReady
                ? (isFound
                    ? PayWallWidget(
                        packages: packages,
                        title: "Ugrade your plan",
                        description:
                            "Under to a new plan to enjoy more benefits",
                        onClickedPages: (package) async {
                          await PurchaseApi.purchasePackage(package);
                          Navigator.pop(context);
                        },
                      )
                    : const Text("not found"))
                : const Text("loading"),
          ],
        ),
      ),
    );
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers();
    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No plans found"),
        ),
      );
      setState(() {
        isReady = true;
        isFound = false;
      });
    } else {
      final offer = offerings.first;
      print('Offer: $offer');
      packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
      setState(() {
        isReady = true;
        isFound = true;
      });
    }
  }
}
