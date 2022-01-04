import 'package:flutter/material.dart';
import 'package:purchases_flutter/package_wrapper.dart';

class PayWallWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPages;
  const PayWallWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.packages,
      required this.onClickedPages})
      : super(key: key);
  @override
  _PayWallWidgetState createState() => _PayWallWidgetState();
}

class _PayWallWidgetState extends State<PayWallWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.title),
            const SizedBox(height: 16),
            Text(widget.description),
            const SizedBox(height: 16),
            buildPackages(),
          ],
        ),
      ),
    );
  }

  Widget buildPackages() {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          final package = widget.packages[index];
          return buildPackage(context, package);
        });
  }

  Widget buildPackage(BuildContext context, Package package) {
    final product = package.product;
    return Card(
      color: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData.light(),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          title: Text(product.title),
          subtitle: Text(product.description),
          trailing: Text(product.priceString),
          onTap: () => widget.onClickedPages(package),
        ),
      ),
    );
  }
}
