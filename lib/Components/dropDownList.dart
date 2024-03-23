import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    this.selectedItem,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: _selectedItem,
      itemBuilder: (BuildContext context) {
        return widget.items.map((item) {
          return PopupMenuItem<String>(
            value: item,
            textStyle: const TextStyle(
                color: Colors.blue
            ),
            height: 40,
            child: Text(item),
          );
        }).toList();
      },
      onSelected: (String value) {
        setState(() {
          _selectedItem = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      child: SizedBox(
        width: 150,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: CustomColors.lightGrey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedItem ?? widget.items.first,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
