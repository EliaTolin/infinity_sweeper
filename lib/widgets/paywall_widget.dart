import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/constants/style_constant.dart';
import 'package:purchases_flutter/package_wrapper.dart';

class PayWallWidget extends StatefulWidget {
  final BuildContext context;
  final Package package;
  final int index;
  final ValueChanged<Package> onClickedPages;
  const PayWallWidget(
      this.package, this.context, this.index, this.onClickedPages,
      {Key? key})
      : super(key: key);
  @override
  _PayWallWidgetState createState() => _PayWallWidgetState();
}

class _PayWallWidgetState extends State<PayWallWidget> {
  @override
  Widget build(BuildContext context) {
    final product = widget.package.product;
    return ClayContainer(
      curveType: CurveType.concave,
      surfaceColor: StyleConstant.mainColor,
      parentColor: StyleConstant.mainColor,
      customBorderRadius: BorderRadius.circular(12),
      child: Theme(
        data: ThemeData.light(),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          title: AutoSizeText(
            product.title,
            maxLines: 1,
            style: TextStyle(
              color: StyleConstant.listColors[widget.index],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: AutoSizeText(
            product.description,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: AutoSizeText(
            product.priceString,
            maxLines: 1,
            style: TextStyle(
              color: StyleConstant.listColors[widget.index],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => widget.onClickedPages(widget.package),
        ),
      ),
    );
  }
}
