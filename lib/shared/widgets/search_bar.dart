import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/insets.dart';
import '../../core/theme/typography.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  final Duration debounceDuration;
  final Duration throttleDuration;

  const SearchBar({
    Key? key,
    required this.onChanged,
    this.hintText = 'Search...',
    this.debounceDuration = const Duration(milliseconds: 400),
    this.throttleDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Timer? _throttle;
  String _lastValue = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _throttle?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    if (_throttle?.isActive ?? false) return;
    _throttle = Timer(widget.throttleDuration, () {});
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      if (value != _lastValue) {
        widget.onChanged(value);
        _lastValue = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
      child: Row(
        children: [

          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onTextChanged,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                isDense: true,
                prefixIcon:  Icon(Icons.search,),
                suffixIcon: _controller.text.isNotEmpty ? IconButton(
                  onPressed: () {
                    _controller.clear();
                    _onTextChanged('');
                    setState(() {});
                  },
                  icon: Icon(Icons.close,),
                ) : null
              ),
            ),
          ),
        ],
      ),
    );
  }
} 