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

class MenuWidget {
  final Function(String) onUpdateCategory;
  final Function(String) onDeleteCategory;

  MenuWidget({required this.onUpdateCategory, required this.onDeleteCategory});

  void categoryActionMenu(BuildContext context, String category) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset target = overlay.localToGlobal(Offset.zero);
    TextEditingController newCategoryId = TextEditingController();

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width, 0, MediaQuery.of(context).size.width, 0),

      items: [
        const PopupMenuItem(
          value: 'update',
          child: Text('Update'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    ).then((value) {
      if (value == 'update') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update $category'),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: newCategoryId,
                      decoration: const InputDecoration(labelText: 'New Category ID'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (newCategoryId.text.isNotEmpty) {
                      onUpdateCategory(newCategoryId.text);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      } else if (value == 'delete') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Deleting $category'),
              content: Text("Are you sure you want to delete $category ?\nThis category will be temporarily removed"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    onDeleteCategory(category);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
      }
    });
  }
}



