import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';

class CupertinoPickerAtom extends StatelessWidget {
  final double itemExtent;
  final List<String> elements;
  final int initialItemIndex;
  final FixedExtentScrollController? scrollController;
  final Size size;
  final ValueChanged<int>? onSelectedItemChanged;
  final Color? containerColor;
  final Color? selectionOverlayColor;
  final bool? horizontal;

  const CupertinoPickerAtom({
    super.key,
    required this.itemExtent,
    required this.onSelectedItemChanged,
    required this.elements,
    required this.initialItemIndex,
    required this.size,
    this.containerColor,
    this.selectionOverlayColor,
    this.horizontal,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: containerColor,
      width: size.width,
      height: size.height,
      child: RotatedBox(
        quarterTurns: horizontal == true ? 3 : 0,
        child: CupertinoPicker(
          scrollController: scrollController ??
              FixedExtentScrollController(initialItem: initialItemIndex),
          itemExtent: itemExtent,
          onSelectedItemChanged: onSelectedItemChanged,
          selectionOverlay: selectionOverlayColor != null
              ? Container(
                  color: selectionOverlayColor,
                )
              : RotatedBox(
                  quarterTurns: horizontal == true ? 1 : 0,
                  child: const CupertinoPickerDefaultSelectionOverlay(),
                ),
          children: elements
              .map(
                (e) => Center(
                  child: RotatedBox(
                    quarterTurns: horizontal == true ? 1 : 0,
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              )
              .toList(), // Pass down the color to the picker
        ),
      ),
    );
  }
}

class TextFormFieldAtom extends StatelessWidget {
  final String? initialValue;
  final Function(String value) onChanged;
  final String hintText;
  final TextCapitalization? textCapitalization;
  final bool? isTextArea;

  const TextFormFieldAtom({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.hintText,
    this.textCapitalization = TextCapitalization.sentences,
    this.isTextArea,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintStyle: Theme.of(context).textTheme.titleSmall,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.r_8),
          ),
        ),
        filled: true,
        fillColor: Colors.grey[800],
        hintText: hintText,
      ),
      maxLines: isTextArea == true ? 5 : 1,
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}
