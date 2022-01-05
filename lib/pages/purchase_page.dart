import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:infinity_sweeper/api/purchase_api.dart';
import 'package:infinity_sweeper/models/ads/entitlement.dart';
import 'package:infinity_sweeper/models/providers/purchase_provider.dart';
import 'package:infinity_sweeper/widgets/paywall_widget.dart';
import 'package:provider/provider.dart';
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
    Entitlement entitlement =
        Provider.of<PurchaseProvider>(context, listen: false).entitlement;
    return Scaffold(
      appBar: AppBar(
        title: const Text('In App Purchase 1.0.8'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            entitlement == Entitlement.REMOVE_ADS
                ? const Text(
                    "Already buy",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                : isReady
                    ? (isFound
                        ? PayWallWidget(
                            packages: packages,
                            title: "Ugrade your plan",
                            description:
                                "Under to a new plan to enjoy more benefits",
                            onClickedPages: (package) async {
                              final ifSuccess =
                                  await PurchaseApi.purchasePackage(package);
                              ifSuccess
                                  ? print("SUCCESSSS")
                                  : print("NOT GOOOOOOD");
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
      print('DEBUG DEBUG OFFER: $offer');
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
