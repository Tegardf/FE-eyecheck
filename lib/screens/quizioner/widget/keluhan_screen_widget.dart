import 'package:eyecheckv2/controllers/classification_controlller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeluhanScreen extends StatelessWidget {
  final String keluhan;
  final int index;

  // final RadioController radioController = Get.put(RadioController());

  const KeluhanScreen({required this.keluhan, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              keluhan,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          GetBuilder<ClassificationController>(
            init: ClassificationController(),
            builder: (controller) {
              return Column(
                children: List.generate(
                  controller.choices.length,
                  (i) => RadioListTile(
                    title: Text(controller.choices[i]),
                    value:
                        controller.customValues[controller.choices[i]] ?? 0.0,
                    groupValue: controller.selectedValues[index],
                    onChanged: (value) {
                      controller.updateValue(index, value!);
                      Get.find<ClassificationController>()
                          .updateValueCF(index, value);
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
