import 'package:flutter/material.dart';

class CustomFormTextField extends StatefulWidget {
  CustomFormTextField({
    this.onChange,
    this.hintText,
    super.key,
    required this.icon,
    this.obscureText = false,
  });

  String? hintText;
  IconData? icon;
  bool obscureText;
  Function(String)? onChange;

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  // متغير عشان نتحكم في الظهور والاخفاء
  bool _isObsecure = false;

  @override
  void initState() {
    super.initState();
    // بنخلي القيمة الابتدائية زي ما انت باعتها في الكونستركتور
    _isObsecure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObsecure,
      validator: (data) {
        if (data!.isEmpty) return 'field is required';
        return null; //لازم ترجع null لو مفيش ايرور
      },
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon, color: Colors.white),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObsecure = !_isObsecure;
                  });
                },
                icon: Icon(
                  _isObsecure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Color(0xa5ccd0cf), fontSize: 18),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}
