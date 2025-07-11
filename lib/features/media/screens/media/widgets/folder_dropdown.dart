import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/state_manager.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';

class MediaFolderDropdown extends StatelessWidget {
  const MediaFolderDropdown({super.key, this.onChanged});

  final void Function(MediaCategory?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;
    return Obx(
      () => SizedBox(
        width: 140,
        child: DropdownButtonFormField(
          isExpanded: false,
          value: controller.selectedPath.value,
          onChanged: onChanged,
          items:
              MediaCategory.values
                  .map((category) => DropdownMenuItem(value: category, child: Text(category.name.capitalize.toString())))
                  .toList(),
        ),
      ),
    );
  }
}
