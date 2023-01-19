import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomizedAppBar extends StatelessWidget implements PreferredSizeWidget{
  final AutoSizeText title;
  final List<Widget>? actions;
  final Widget? leading;
  final TabBar?  bottom;

  const CustomizedAppBar({
    super.key,
    required this.title,
    required this.actions,
    this.leading, this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: leading,
      actions: actions,
      titleTextStyle: Theme.of(context)
          .textTheme
          .headline1
          ?.copyWith(fontWeight: FontWeight.bold),
      title: title,
      bottom: bottom,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  @override
  Size get preferredSize =>  Size.fromHeight(bottom!=null? 96: kToolbarHeight);

}
