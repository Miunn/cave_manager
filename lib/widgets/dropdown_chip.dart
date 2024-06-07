import 'package:flutter/material.dart';

class DropdownChip extends StatefulWidget {
  const DropdownChip(
      {super.key,
      required this.label,
      required this.items,
      required this.onChanged});

  final Widget label;
  final List<(String, Widget)> items;
  final Function(String?)? onChanged;

  @override
  State<DropdownChip> createState() => _DropdownChipState();
}

class _DropdownChipState extends State<DropdownChip> {
  (String, Widget)? selectedItem;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return FilterChip(
          label: selectedItem?.$2 ?? widget.label,
          onSelected: (bool value) {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          selected: selectedItem != null,
          // Delete icon is displayed when onDeleted is set
          // Set onDeleted to null to hide the icon when no element is selected
          onDeleted: (selectedItem != null)
              ? () {
                  setState(() {
                    selectedItem = null;
                  });
                  widget.onChanged?.call(null);
                }
              : null,
        );
      },
      menuChildren: [
        for (final (String, Widget) item in widget.items)
          MenuItemButton(
            child: item.$2,
            onPressed: () {
              setState(() {
                selectedItem = item;
              });
              widget.onChanged?.call(item.$1);
            },
          ),
      ],
    );
  }
}
