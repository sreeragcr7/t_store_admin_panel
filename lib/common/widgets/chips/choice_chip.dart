import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';

class TChoiceChip extends StatelessWidget {
  const TChoiceChip({super.key, required this.text, required this.selected, this.onSelected});

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor = THelperFunctions.getColor(text) != null;
    return Theme(
      //Use a transparent canvas color to match the existing styling
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        //Use this function to get Colors as a chip
        avatar:
            isColor
                ? TCircularContainer(width: 50, height: 50, backgroundColor: THelperFunctions.getColor(text)!)
                : null,
        selected: selected,
        onSelected: onSelected,
        backgroundColor: isColor ? THelperFunctions.getColor(text)! : null,
        labelStyle: TextStyle(color: selected ? TColors.white : null),
        shape: isColor ? const CircleBorder() : null,
        label: isColor ? const SizedBox() : Text(text),
        padding: isColor ? const EdgeInsets.all(0) : null,
        labelPadding: isColor ? const EdgeInsets.all(0) : null,
      ),
    );
  }
}
