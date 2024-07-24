import 'package:flutter/material.dart';

import 'package:timely/app_theme.dart';
import 'package:timely/reusables.dart';

class CancelSubmitRowMolecule extends StatelessWidget {
  final VoidCallback onSubmitPressed;
  final VoidCallback onCancelPressed;

  const CancelSubmitRowMolecule({
    super.key,
    required this.onSubmitPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButtonAtom(
              onPressed: onCancelPressed,
              text: "Cancel",
              color: Colors.red[800],
            ),
            TextButtonAtom(
              color: Colors.purple[800],
              onPressed: onSubmitPressed,
              text: "Submit",
            ),
          ],
        ),
      ],
    );
  }
}

class DismissibleEntryRowMolecule extends StatelessWidget {
  final Widget child;
  final Function(DismissDirection direction) onDismissed;
  final bool? cannotBeMarkedComplete;

  const DismissibleEntryRowMolecule({
    Key? key,
    required this.child,
    required this.onDismissed,
    this.cannotBeMarkedComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        return await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: direction == DismissDirection.startToEnd
                      ? const Text("Delete")
                      : const Text("Mark Complete"),
                  content: direction == DismissDirection.startToEnd
                      ? const Text('Are you sure you want to delete?')
                      : const Text(
                          'Are you sure you want to mark as completed?'),
                  actions: [
                    IconButton.filledTonal(
                      icon: const Icon(Icons.done),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.dangerous),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ],
                );
              },
            ) ??
            false;
      },
      onDismissed: (direction) => onDismissed(direction),
      child: child,
    );
  }
}

class NavigationRowMolecule extends StatelessWidget {
  final VoidCallback onPressedHome;
  final VoidCallback? onPressedAdd;
  final bool? hideAddButton;

  const NavigationRowMolecule(
      {Key? key,
      required this.onPressedHome,
      this.onPressedAdd,
      this.hideAddButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: hideAddButton == true
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.black12,
          onPressed: onPressedHome,
          child: const Icon(Icons.home),
        ),
        hideAddButton == true
            ? Container()
            : FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.black12,
                onPressed: onPressedAdd,
                child: const Icon(Icons.add),
              ),
      ],
    );
  }
}

class TextRowMolecule extends StatelessWidget {
  final List<String> texts;
  final Color? rowColor;
  final List<int> defaultAligned;
  final Map<int, double> customWidths;
  final Map<int, Color> colors; // New addition for custom colors
  final bool? bolded;
  final double? height;
  final double? minHeight;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const TextRowMolecule({
    Key? key,
    required this.texts,
    this.customWidths = const {},
    this.colors = const {}, // Initialize with an empty map
    this.bolded,
    this.height,
    this.rowColor,
    this.defaultAligned = const [],
    this.minHeight,
    this.padding,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: rowColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight ?? 0.0,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: Row(
            children: List.generate(
              texts.length,
              (index) {
                return customWidths.containsKey(index)
                    ? Container(
                        height: height,
                        color: colors.containsKey(index) ? colors[index] : null,
                        child: SizedBox(
                          width: customWidths[index],
                          child: defaultAligned.contains(index)
                              ? Row(
                                  children: [
                                    Text(
                                      texts[index],
                                      style: textStyle ??
                                          Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    texts[index],
                                    style: textStyle ??
                                        Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          height: height,
                          color:
                              colors.containsKey(index) ? colors[index] : null,
                          child: defaultAligned.contains(index)
                              ? Padding(
                                  padding: const EdgeInsets.all(AppSizes.p_8),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          texts[index],
                                          style: textStyle ??
                                              Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    texts[index],
                                    style: textStyle ??
                                        Theme.of(context)
                                            .textTheme
                                            .titleMedium!,
                                  ),
                                ),
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TitleWidgetRowMolecule extends StatelessWidget {
  final String title;
  final Widget widget;
  final bool? inverted;
  final bool? bolded;

  const TitleWidgetRowMolecule({
    super.key,
    required this.title,
    required this.widget,
    this.inverted,
    this.bolded,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontWeight: bolded == true ? FontWeight.bold : null,
            ),
      ),
      const SizedBox(
        width: 20,
      ),
      widget,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: inverted == null ? children : children.reversed.toList(),
    );
  }
}

class TitleWidgetColumnMolecule extends StatelessWidget {
  final String title;
  final Widget widget;
  final double spacing;
  final bool? inverted;
  final bool? bolded;

  const TitleWidgetColumnMolecule({
    Key? key,
    required this.title,
    required this.widget,
    this.spacing = 20,
    this.inverted,
    this.bolded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Center(
        child: Text(
          title,
          style: bolded == true
              ? AppTypography.boldStyle
              : AppTypography.regularStyle,
        ),
      ),
      SizedBox(height: spacing),
      widget,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: inverted == null ? children : children.reversed.toList(),
    );
  }
}
