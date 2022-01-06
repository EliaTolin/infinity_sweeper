import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinity_sweeper/api/purchase_api.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:infinity_sweeper/models/ads/entitlement.dart';
import 'package:infinity_sweeper/models/providers/purchase_provider.dart';
import 'package:infinity_sweeper/widgets/page_components/topbar_back_widget.dart';
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
    // Entitlement entitlement =
    //     Provider.of<PurchaseProvider>(context, listen: false).entitlement;
    Entitlement entitlement = Entitlement.proVersionAds;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TopBarBack(
        "Pro Version Ads",
        size,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                entitlement == Entitlement.proVersionAds
                    ? buildAlreadyPurchase()
                    : buildShowOfferings(),
                // entitlement == Entitlement.proVersionAds
                //     ? const Text(
                //         "Already buy",
                //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //       )
                //     : isReady
                //         ? (isFound
                //             ? PayWallWidget(
                //                 packages: packages,
                //                 title: "Ugrade your plan",
                //                 description:
                //                     "Under to a new plan to enjoy more benefits",
                //                 onClickedPages: (package) async {
                //                   final ifSuccess =
                //                       await PurchaseApi.purchasePackage(package);
                //                   ifSuccess
                //                       ? print("SUCCESSSS")
                //                       : print("NOT GOOOOOOD");
                //                 },
                //               )
                //             : const Text("not found"))
                //         : const Text("loading"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShowOfferings() {
    return Column(
      children: [
        buildCrown(),
        const SizedBox(height: 50),
        ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return PayWallWidget(
                package,
                context,
                index,
                (Package package) async {
                  final isSuccess = await PurchaseApi.purchasePackage(package);
                  isSuccess ? print("Good purchase") : print("Bad purchase");
                },
              );
            }),
      ],
    );
  }

  Widget buildCrown() {
    return ClayContainer(
      curveType: CurveType.concave,
      surfaceColor: StyleConstant.mainColor,
      parentColor: StyleConstant.mainColor,
      borderRadius: 100,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  "assets/crown-2.svg",
                  color: StyleConstant.listColors[0],
                  height: 200,
                ),
                SvgPicture.asset(
                  "assets/crown-2.svg",
                  color: StyleConstant.listColors[1],
                  height: 210,
                ),
                SvgPicture.asset(
                  "assets/crown-2.svg",
                  color: StyleConstant.listColors[2],
                  height: 220,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAlreadyPurchase() {
    return Column(
      children: <Widget>[
        buildCrown(),
        const SizedBox(height: 50),
        ClayContainer(
          curveType: CurveType.concave,
          surfaceColor: StyleConstant.mainColor,
          parentColor: StyleConstant.mainColor,
          customBorderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.all(25.0),
            child: AutoSizeText(
              "You are already Pro Gamer, you will never see ads again! ",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
