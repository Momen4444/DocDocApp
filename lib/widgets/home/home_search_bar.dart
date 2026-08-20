import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

// search bar
class HomeSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const HomeSearchBar({super.key, required this.onSearch});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => widget.onSearch(value.trim()),
    );
  }

  void _clear() {
    _controller.clear();
    _debounce?.cancel();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.all(Radius.circular(14)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded,
                color: AppColors.textGrey, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  hintText: 'Search by name or email…',
                  hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  filled: false,
                ),
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (_, value, __) => value.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _clear,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.close_rounded,
                            color: AppColors.textGrey, size: 20),
                      ),
                    )
                  : const SizedBox(width: 14),
            ),
          ],
        ),
      ),
    );
  }
}
