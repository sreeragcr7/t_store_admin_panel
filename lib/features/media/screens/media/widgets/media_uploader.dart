import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/features/media/screens/media/widgets/folder_dropdown.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/device/device_utility.dart';
// import 'package:universal_html/html.dart' as html;

class MediaUploader extends StatelessWidget {
  const MediaUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;
    return Obx(
      () =>
          controller.showImagesUploaderSection.value
              ? Column(
                children: [
                  //Drag & Drop Area
                  TRoundedContainer(
                    height: 250,
                    showBorder: true,
                    borderColor: TColors.borderPrimary,
                    backgroundColor: TColors.primaryBackground,
                    padding: EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              //Drop zone
                              DropzoneView(
                                mime: const ['image/jpeg', 'image/png'],
                                cursor: CursorType.Default,
                                operation: DragOperation.copy,
                                onLoaded: () => print('Zone loaded'),
                                onError: (ev) => print('Zone error: $ev'),
                                onHover: () => print('Zone hovered'),
                                onLeave: () => print('Zone left'),
                                onCreated: (ctrl) => controller.dropzoneController = ctrl,
                                onDropInvalid: (ev) => print('Zone invalid MIME: $ev'),
                                onDropFiles: (ev) => print('Zone drop multiple: $ev'),

                                onDropFile: (DropzoneFileInterface ev) async {
                                  // Retrieve file data as Uint8List
                                  final bytes = await controller.dropzoneController.getFileData(ev);

                                  // Extract file metadata
                                  final filename = await controller.dropzoneController.getFilename(ev);
                                  final mimeType = await controller.dropzoneController.getFileMIME(ev);

                                  final image = ImageModel(
                                    url: '',
                                    folder: '',
                                    filename: filename,
                                    contentType: mimeType,
                                    localImageToDisplay: Uint8List.fromList(bytes),
                                  );
                                  controller.selectedImagesToUpload.add(image);
                                },
                              ),

                              //Drop zone content
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(TImages.defaultImageIcon, width: 50, height: 50),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  Text('Drag and Drop Images here'),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  OutlinedButton(
                                    onPressed: () => controller.selectLocalImages(),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: TColors.darkGrey), // removes outline
                                    ),
                                    child: const Text('Select Images'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  //Heading & Locally Selected Images
                  if (controller.selectedImagesToUpload.isNotEmpty)
                    TRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Heading
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Folders Dropdown
                              Row(
                                children: [
                                  Text('Select Folder', style: Theme.of(context).textTheme.headlineSmall),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  MediaFolderDropdown(
                                    onChanged: (MediaCategory? newValue) {
                                      if (newValue != null) {
                                        controller.selectedPath.value = newValue;
                                      }
                                    },
                                  ),
                                ],
                              ),

                              //Upload & Remove buttons
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => controller.selectedImagesToUpload.clear(),
                                    child: const Text('Remove All'),
                                  ),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  TDeviceUtils.isMobileScreen(context)
                                      ? const SizedBox.shrink()
                                      : SizedBox(
                                        width: TSizes.buttonWidth,
                                        child: ElevatedButton(
                                          onPressed: () => controller.uploadImageConfirmation(),
                                          child: const Text('Upload'),
                                        ),
                                      ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),

                          //Locally selected Images
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: TSizes.spaceBtwItems / 2,
                            runSpacing: TSizes.spaceBtwItems / 2,
                            children:
                                controller.selectedImagesToUpload
                                    .where((image) => image.localImageToDisplay != null)
                                    .map(
                                      (element) => TRoundedImage(
                                        width: 90,
                                        height: 90,
                                        padding: TSizes.sm,
                                        imageType: ImageType.memory,
                                        memoryImage: element.localImageToDisplay,
                                        backgroundColor: TColors.primaryBackground,
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),

                          //Upload Btn for Mobile
                          TDeviceUtils.isMobileScreen(context)
                              ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => controller.uploadImageConfirmation(),
                                  child: const Text('Upload'),
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              )
              : const SizedBox.shrink(),
    );
  }
}
