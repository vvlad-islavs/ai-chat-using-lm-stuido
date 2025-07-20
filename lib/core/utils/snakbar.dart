import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class SnackBarManager {
  SnackBarManager._();

  // Обеспечивает возмонжность управлять и создавать максимум один экземпляр.
  static final SnackBarManager _instance = SnackBarManager._();

  //TODO: придумать как получать context вне вызова метода show(), как вариант использовать глобальный ключ всего приложения, но пока что не работает
  late final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;
  bool _isInitialized = false;

  //TODO: придумать как получать context вне вызова метода show(), как вариант использовать глобальный ключ всего приложения, но пока что не работает
  // Нужно только для инициализации контекста
  /// Инициализация — вызывать в [main()], передав key
  static void init(GlobalKey<ScaffoldMessengerState> key) {
    if (!_instance._isInitialized) {
      _instance._scaffoldMessengerKey = key;
      _instance._isInitialized = true;
    }
  }

  //TODO: вынести в метод для возможности их редактирования в зависимости от ситуации.
  // Параметры снэкбара
  bool _isExpanded = false;
  double _topOffset = 48;

  // Последнее сообщение
  static String _message = '';

  OverlayEntry? _overlayEntry;
  Timer? _timer;
  final GlobalKey<_SnackBarWidgetState> _snackBarKey = GlobalKey<_SnackBarWidgetState>();

  /// Устнавливает параметры отображения уведомления.
  static void setParams({bool isExpanded = false, double topOffset = 48}) =>
      _instance._setParams(isExpanded: isExpanded, topOffset: topOffset);

  void _setParams({required bool isExpanded, required double topOffset}) {
    _isExpanded = isExpanded;
    _topOffset = topOffset;
  }

  /// Возвращает последнее выведенное сообщение.
  static String get lastMessage => _instance._lastMessage;

  String get _lastMessage => _message;

  /// Флаг, активен ли снэкбар в данный момент.
  static bool get iShowing => _instance._iShowing;

  bool get _iShowing => _timer?.isActive ?? false;

  /// Закрывает активный снэбар.
  static Future<void> close() async => _instance._close();

  Future<void> _close() async => _removeSnackBar();

  /// Открывает снэкбар.
  static void show(BuildContext context, String message, {Duration duration = const Duration(seconds: 5)}) =>
      _instance._show(context: context, message: message, duration: duration);

  void _show(
      {required BuildContext context, required String message, Duration duration = const Duration(seconds: 5)}) async {
    if (_instance._isInitialized) {
      _message = message;
      await _removeSnackBar();

      _overlayEntry = _createOverlayEntry(message);

      _timer = Timer(duration, _removeSnackBar);
      Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    } else {
      log('Менеджер не был инициализирован.', name: 'SnackBarManager');
    }
  }

  Future<void> _removeSnackBar() async {
    if (_overlayEntry != null) {
      await _snackBarKey.currentState?.dismiss();
      _overlayEntry?.remove();
      _overlayEntry = null;
      _timer?.cancel();
      await Future.delayed(const Duration(milliseconds: 10));
    } else {
      _timer?.cancel();
    }
  }

  OverlayEntry _createOverlayEntry(String message) => OverlayEntry(
        builder: (context) => Positioned(
          bottom: null,
          top: _topOffset,
          left: 16,
          right: 16,
          child: _SnackBarWidget(
            isExpanded: _isExpanded,
            closeSnackBar: _removeSnackBar,
            key: _snackBarKey,
            message: message,
            globalKey: _snackBarKey,
            topOffset: _topOffset,
          ),
        ),
      );
}

class _SnackBarWidget extends StatefulWidget {
  final double topOffset;
  final String message;
  final bool isExpanded;
  final GlobalKey<_SnackBarWidgetState> globalKey;
  final Function() closeSnackBar;

  const _SnackBarWidget({
    super.key,
    required this.message,
    required this.topOffset,
    required this.globalKey,
    required this.closeSnackBar,
    required this.isExpanded,
  });

  @override
  State<_SnackBarWidget> createState() => _SnackBarWidgetState();
}

class _SnackBarWidgetState extends State<_SnackBarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Offset startOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: GestureDetector(
          onVerticalDragStart: (details) {
            startOffset = details.globalPosition;
          },
          onVerticalDragEnd: (details) {
            if (startOffset.dy > details.localPosition.dy + widget.topOffset) {
              widget.closeSnackBar();
            }
          },
          child: SlideTransition(
            position: _slideAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  spacing: 8,
                  mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: widget.isExpanded ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            color: Colors.grey.shade100,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 36,
                        width: 36,
                        child: ElevatedButton(
                          iconAlignment: IconAlignment.start,
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
                            fixedSize: WidgetStatePropertyAll(Size(20, 20)),
                            iconSize: WidgetStatePropertyAll(20),
                            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                            foregroundColor: WidgetStatePropertyAll(Colors.transparent),
                            shadowColor: WidgetStatePropertyAll(Colors.transparent),
                          ),
                          onPressed: widget.closeSnackBar,
                          child: Center(
                            child: Icon(
                              color: Colors.grey.shade100,
                              Icons.close,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
