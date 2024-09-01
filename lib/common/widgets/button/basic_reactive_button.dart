import 'package:ewallet/common/bloc/button/button_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/button/button_state.dart';

class BasicReactiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Widget? content;
  final Color backgroundColor;
  final Color textColor;

  const BasicReactiveButton({
    required this.onPressed,
    this.title = '',
    this.height,
    this.content,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        if (state is ButtonLoadingState) {
          return _loading();
        }
        return _initial();
      }
    );
  }

  Widget _loading() {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 50),
        backgroundColor: backgroundColor,
      ),
      child: Container(
        height: height ?? 50,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: textColor)
      )
    );
  }

  Widget _initial() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 50),
        backgroundColor: backgroundColor,
      ),
      child: content ?? Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w400
        ),
      )
    );
  }
}
