import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        color: TColors.primary,

        // -- if [size.isFinite: is not true ] Error --> Read README.md file at [DESIGN ERROR] # 1
        child: Stack(
          children: [
            // -- Background custom shape
            Positioned(
              top: -100,
              right: -150,
              child: TCircularContainer(backgroundColor: Color.fromRGBO(255, 255, 255, 0.1)),
            ),
            Positioned(
              top: 100,
              right: -200,
              child: TCircularContainer(backgroundColor: Color.fromRGBO(255, 255, 255, 0.1)),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
