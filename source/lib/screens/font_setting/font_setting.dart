import 'package:flutter/material.dart';
import 'package:listar_flutter/blocs/bloc.dart';
import 'package:listar_flutter/configs/config.dart';
import 'package:listar_flutter/utils/utils.dart';
import 'package:listar_flutter/widgets/widget.dart';

class FontSetting extends StatefulWidget {
  const FontSetting({Key? key}) : super(key: key);

  @override
  createState() {
    return _FontSettingState();
  }
}

class _FontSettingState extends State<FontSetting> {
  String _currentFont = AppBloc.themeCubit.state.font;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On change Font
  void _onChange() {
    AppBloc.themeCubit.onChangeTheme(font: _currentFont);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('font'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  Widget? trailing;
                  final item = AppTheme.fontSupport[index];
                  if (item == _currentFont) {
                    trailing = Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    );
                  }
                  return AppListTitle(
                    title: item,
                    trailing: trailing,
                    onPressed: () {
                      setState(() {
                        _currentFont = item;
                      });
                    },
                    border: item != AppTheme.fontSupport.last,
                  );
                },
                itemCount: AppTheme.fontSupport.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                Translate.of(context).translate('apply'),
                mainAxisSize: MainAxisSize.max,
                onPressed: _onChange,
              ),
            )
          ],
        ),
      ),
    );
  }
}
