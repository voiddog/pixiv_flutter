///
/// ┏┛ ┻━━━━━┛ ┻┓
/// ┃　　　　　　 ┃
/// ┃　　　━　　　┃
/// ┃　┳┛　  ┗┳　┃
/// ┃　　　　　　 ┃
/// ┃　　　┻　　　┃
/// ┃　　　　　　 ┃
/// ┗━┓　　　┏━━━┛
/// * ┃　　　┃   神兽保佑
/// * ┃　　　┃   代码无BUG！
/// * ┃　　　┗━━━━━━━━━┓
/// * ┃　　　　　　　    ┣┓
/// * ┃　　　　         ┏┛
/// * ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
/// * * ┃ ┫ ┫   ┃ ┫ ┫
/// * * ┗━┻━┛   ┗━┻━┛
/// 支持渐变的 raise button
/// @author qigengxin
/// @since 2019-01-21 11:06
///
import 'package:flutter/material.dart';

class RaisedGradientButton extends MaterialButton {
  /// default button background
  final Gradient gradient;

  /// disable button background
  final Gradient disableGradient;

  /// the color that shadow display
  final Color shadowColor;

  RaisedGradientButton(
      {Key key,
      @required VoidCallback onPressed,
      ButtonTextTheme textTheme,
      Color textColor,
      Color disabledTextColor,
      Color color,
      Color disabledColor,
      this.gradient,
      this.disableGradient,
      this.shadowColor,
      Color highlightColor,
      Color splashColor,
      Brightness colorBrightness,
      double elevation,
      double highlightElevation,
      double disabledElevation,
      EdgeInsetsGeometry padding,
      ShapeBorder shape,
      Duration animationDuration,
      Widget child})
      : assert(elevation == null || elevation >= 0.0),
        assert(highlightElevation == null || highlightElevation >= 0.0),
        assert(disabledElevation == null || disabledElevation >= 0.0),
        super(
          key: key,
          onPressed: onPressed,
          textTheme: textTheme,
          textColor: textColor,
          disabledTextColor: disabledTextColor,
          color: color,
          disabledColor: disabledColor,
          highlightColor: highlightColor,
          splashColor: splashColor,
          colorBrightness: colorBrightness,
          elevation: elevation,
          highlightElevation: highlightElevation,
          disabledElevation: disabledElevation,
          padding: padding,
          animationDuration: animationDuration,
          shape: shape,
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonThemeData buttonTheme = ButtonTheme.of(context);

    return _RawRaisedGradientButton(
      onPressed: onPressed,
      fillColor: buttonTheme.getFillColor(this),
      fillGradient: enabled ? gradient : disableGradient,
      shadowColor: shadowColor,
      textStyle: theme.textTheme.button.copyWith(color: buttonTheme.getTextColor(this)),
      highlightColor: buttonTheme.getHighlightColor(this),
      splashColor: buttonTheme.getSplashColor(this),
      elevation: buttonTheme.getElevation(this),
      highlightElevation: buttonTheme.getHighlightElevation(this),
      disabledElevation: buttonTheme.getDisabledElevation(this),
      padding: buttonTheme.getPadding(this),
      constraints: buttonTheme.getConstraints(this),
      shape: buttonTheme.getShape(this),
      animationDuration: buttonTheme.getAnimationDuration(this),
      child: child,
    );
  }
}

class _RawRaisedGradientButton extends StatefulWidget {
  /// Called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled, see [enabled].
  final VoidCallback onPressed;

  /// Defines the default text style, with [Material.textStyle], for the
  /// button's [child].
  final TextStyle textStyle;

  /// default button background
  final Gradient fillGradient;

  /// the color that shadow display
  final Color shadowColor;

  /// The shape of the button's [Material].
  ///
  /// The button's highlight and splash are clipped to this shape. If the
  /// button has an elevation, then its drop shadow is defined by this shape.
  final ShapeBorder shape;

  /// The color of the button's [Material].
  final Color fillColor;

  /// The highlight color for the button's [InkWell].
  final Color highlightColor;

  /// The splash color for the button's [InkWell].
  final Color splashColor;

  /// The elevation for the button's [Material] when the button
  /// is [enabled] but not pressed.
  ///
  /// Defaults to 2.0.
  ///
  /// See also:
  ///
  ///  * [highlightElevation], the default elevation.
  ///  * [disabledElevation], the elevation when the button is disabled.
  final double elevation;

  /// The elevation for the button's [Material] when the button
  /// is [enabled] and pressed.
  ///
  /// Defaults to 8.0.
  ///
  /// See also:
  ///
  ///  * [elevation], the default elevation.
  ///  * [disabledElevation], the elevation when the button is disabled.
  final double highlightElevation;

  /// The elevation for the button's [Material] when the button
  /// is not [enabled].
  ///
  /// Defaults to 0.0.
  ///
  ///  * [elevation], the default elevation.
  ///  * [highlightElevation], the elevation when the button is pressed.
  final double disabledElevation;

  /// The internal padding for the button's [child].
  final EdgeInsetsGeometry padding;

  /// Defines the button's size.
  ///
  /// Typically used to constrain the button's minimum size.
  final BoxConstraints constraints;

  /// Defines the duration of animated changes for [shape] and [elevation].
  ///
  /// The default value is [kThemeChangeDuration].
  final Duration animationDuration;

  /// Typically the button's label.
  final Widget child;

  /// Whether the button is enabled or disabled.
  ///
  /// Buttons are disabled by default. To enable a button, set its [onPressed]
  /// property to a non-null value.
  bool get enabled => onPressed != null;

  /// {@macro flutter.widgets.Clip}
  final Clip clipBehavior;

  _RawRaisedGradientButton({
    Key key,
    @required this.onPressed,
    this.textStyle,
    this.fillColor,
    this.fillGradient,
    this.shadowColor,
    this.shape,
    this.highlightColor,
    this.splashColor,
    this.elevation = 2.0,
    this.highlightElevation = 8.0,
    this.disabledElevation = 0.0,
    this.padding = EdgeInsets.zero,
    this.constraints = const BoxConstraints(minHeight: 88.0, minWidth: 36.0),
    this.animationDuration = kThemeChangeDuration,
    this.clipBehavior = Clip.none,
    this.child,
  })  : assert(fillColor != null || fillGradient != null),
        assert(clipBehavior != null);

  @override
  __RawRaisedGradientButtonState createState() =>
      __RawRaisedGradientButtonState();
}

class __RawRaisedGradientButtonState extends State<_RawRaisedGradientButton> {
  bool _highlight = false;

  void _handleHighlightChanged(bool value) {
    setState(() {
      _highlight = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double elevation = widget.enabled
        ? (_highlight ? widget.highlightElevation : widget.elevation)
        : widget.disabledElevation;

    Widget content = Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      shape: widget.shape,
      animationDuration: widget.animationDuration,
      clipBehavior: widget.clipBehavior,
      child: InkWell(
        onHighlightChanged: _handleHighlightChanged,
        splashColor: widget.splashColor,
        highlightColor: widget.highlightColor,
        onTap: widget.onPressed,
        customBorder: widget.shape,
        child: Container(
          padding: widget.padding,
          child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.fillGradient != null) {
      content = ClipPath(
        clipper: ShapeBorderClipper(shape: widget.shape),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: widget.fillGradient,
          ),
          child: content,
        ),
      );
    }

    final Widget result = ConstrainedBox(
      constraints: widget.constraints,
      child: Material(
        elevation: elevation,
        color: (widget.fillGradient == null ? widget.fillColor : null) ?? Colors.transparent,
        shadowColor: widget.shadowColor ?? const Color(0xFF000000),
        type: MaterialType.button,
        shape: widget.shape,
        animationDuration: widget.animationDuration,
        clipBehavior: widget.clipBehavior,
        child: content,
      ),
    );
    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: result,
    );
  }
}
