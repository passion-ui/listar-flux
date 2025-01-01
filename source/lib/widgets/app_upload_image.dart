import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listar_flutter/blocs/bloc.dart';
import 'package:listar_flutter/models/model.dart';

enum UploadImageType { circle, square }

class AppUploadImage extends StatefulWidget {
  final String? title;
  final ImageModel? image;
  final Function(ImageModel) onChange;
  final UploadImageType type;

  const AppUploadImage({
    Key? key,
    this.title,
    this.image,
    required this.onChange,
    this.type = UploadImageType.square,
  }) : super(key: key);

  @override
  createState() {
    return _AppUploadImageState();
  }
}

class _AppUploadImageState extends State<AppUploadImage> {
  final _picker = ImagePicker();

  File? _file;
  double? _percent;
  bool _completed = false;
  bool showAction = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _uploadImage() async {
    if (showAction) {
      setState(() {
        showAction = false;
      });
      return;
    }
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return;
      if (!mounted) return;
      setState(() {
        _completed = true;
        _file = File(pickedFile.path);
      });
      widget.onChange(ImageModel(
        id: DateTime.now().millisecondsSinceEpoch,
        image: pickedFile.path,
      ));
    } catch (e) {
      AppBloc.messageCubit.onShow(e.toString());
    }
  }

  Widget? _buildContent() {
    if (widget.image != null && _file == null) return null;

    switch (widget.type) {
      case UploadImageType.circle:
        if (_file == null) {
          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Icon(
              Icons.add,
              size: 18,
              color: Colors.white,
            ),
          );
        }

        if (_completed) {
          return Icon(
            Icons.check_circle,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          );
        }

        return Container();
      default:
        if (_file == null) {
          Widget title = Container();
          if (widget.title != null) {
            title = Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.title!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title,
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }

        if (_completed) {
          return Container(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.check_circle,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        if (_percent != null && _percent! < 100) {
          return Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
              ),
              child: LinearProgressIndicator(
                value: _percent,
                backgroundColor: Theme.of(context).cardColor,
              ),
            ),
          );
        }

        return Container(
          alignment: Alignment.bottomLeft,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
            ),
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).cardColor,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    DecorationImage? decorationImage;
    BorderType borderType = BorderType.RRect;
    Widget circle = Container();

    if (widget.image != null) {
      decorationImage = DecorationImage(
        image: AssetImage(
          widget.image!.image,
        ),
        fit: BoxFit.cover,
      );
    }
    if (_file != null) {
      decorationImage = DecorationImage(
        image: FileImage(
          _file!,
        ),
        fit: BoxFit.cover,
      );
    }

    BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      image: decorationImage,
    );

    if (widget.type == UploadImageType.circle) {
      borderType = BorderType.Circle;
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        image: decorationImage,
      );
      if (_percent != null && _percent! < 100) {
        circle = CircularProgressIndicator(
          value: _percent,
          backgroundColor: Theme.of(context).cardColor,
        );
      } else if (_file != null && !_completed) {
        circle = const CircularProgressIndicator();
      }
    }

    return InkWell(
      onTap: _uploadImage,
      child: Stack(
        children: [
          DottedBorder(
            borderType: borderType,
            radius: const Radius.circular(8),
            color: Theme.of(context).colorScheme.primary,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: decoration,
              alignment: Alignment.center,
              child: _buildContent(),
            ),
          ),
          Positioned.fill(child: circle),
        ],
      ),
    );
  }
}
