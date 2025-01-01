import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:listar_flutter/models/model.dart';
import 'package:listar_flutter/utils/utils.dart';
import 'package:listar_flutter/widgets/widget.dart';

class Picker extends StatefulWidget {
  final PickerModel picker;

  const Picker({
    Key? key,
    required this.picker,
  }) : super(key: key);

  @override
  createState() {
    return _PickerState();
  }
}

class _PickerState extends State<Picker> {
  final _textPickerController = TextEditingController();

  String _keyword = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textPickerController.dispose();
    super.dispose();
  }

  ///On Filter Location
  void _onFilter(String text) {
    setState(() {
      _keyword = text;
    });
  }

  ///Build List
  Widget _buildList() {
    if (widget.picker.data.isEmpty) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.sentiment_satisfied),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                Translate.of(context).translate(
                  'can_not_found_data',
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      );
    }

    List data = widget.picker.data;

    ///Filter
    if (_keyword.isNotEmpty) {
      data = data.where(((item) {
        return item.title.toUpperCase().contains(_keyword.toUpperCase());
      })).toList();
    }

    ///Build List
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 8,
          ),
          child: AppTextInput(
            hintText: Translate.of(context).translate('search'),
            onChanged: _onFilter,
            onSubmitted: _onFilter,
            controller: _textPickerController,
            trailing: GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                _textPickerController.clear();
              },
              child: const Icon(Icons.clear),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final item = data[index];
              Widget? trailing;
              if (widget.picker.selected.contains(item)) {
                trailing = Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                );
              }

              return AppListTitle(
                title: item.title,
                trailing: trailing,
                border: item != data.last,
                onPressed: () {
                  Navigator.pop(context, item);
                },
              );
            },
            itemCount: data.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.picker.title ?? Translate.of(context).translate('picker'),
        ),
      ),
      body: SafeArea(
        child: _buildList(),
      ),
    );
  }
}
