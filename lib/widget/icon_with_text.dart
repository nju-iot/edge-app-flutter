import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final String text;
  final Widget icon;
  final double iconSize;
  final Axis direction;
  /// icon padding
  final EdgeInsetsGeometry padding;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final TextDirection textDirection;

  const IconText(this.text,
      {Key key,
        this.icon,
        this.iconSize,
        this.direction = Axis.horizontal,
        this.style,
        this.maxLines,
        this.padding,
        this.textAlign,
        this.textDirection,
        this.overflow = TextOverflow.ellipsis})
      : assert(direction != null),
        assert(overflow != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _style = DefaultTextStyle.of(context).style.merge(style);
    return icon == null
        ? Text(text ?? '', style: _style)
        : text == null || text.isEmpty
        ? (padding == null ? icon : Padding(padding: padding, child: icon))
        : RichText(
      text: TextSpan(style: _style,
          children: [
            WidgetSpan(
                child: IconTheme(
                  data: IconThemeData(
                      size: iconSize ??
                          (_style == null || _style.fontSize == null
                              ? 16
                              : _style.fontSize + 1),
                      color: _style == null ? null : _style.color),
                  child: padding == null
                      ? icon
                      : Padding(
                    padding: padding,
                    child: icon,
                  ),
                )),
            TextSpan(
                text: direction == Axis.horizontal ? text : "\n$text"),
          ]),
      maxLines: maxLines,
      textDirection: textDirection,
      overflow: overflow ?? TextOverflow.clip,
      textAlign: textAlign ?? (direction == Axis.horizontal ? TextAlign.start : TextAlign.center),
    );
  }
}