import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  SearchField({
    @required this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      style: Theme.of(context).textTheme.body1!.copyWith(
            fontSize: 24.0,
          ),
      decoration: InputDecoration(
        hintText: 'Search',
      ),
      controller: controller,
      onChanged: (value) => onChanged!(value),
    );
  }
}
