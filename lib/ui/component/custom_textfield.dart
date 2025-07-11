import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String label;
  final bool expand;
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const CustomTextfield({
    required this.onSaved,
    required this.label,
    this.expand = false,
    required this.initialValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        expand ? Expanded(child: renderTextFormField()) : renderTextFormField(),
      ],
    );
  }

  Widget renderTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: const Color.fromARGB(255, 241, 240, 240),
      ),
     //TextFormField안에 들어가 있는 값을 변수로 저장하는 역할
      onSaved: onSaved,
      //검증 할 때 로직
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해주세요';
        }
        if (val.length > 500) {
          return '500자 이하의 글자를 입력해주세요.';
        }
        return null;
      },
      maxLines: expand ? null : 1,
      minLines: expand ? null : 1,
      expands: expand,
      initialValue: initialValue,
      cursorColor: Colors.grey,
    );
  }
}
