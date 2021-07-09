/// ZeroAlert is a pre-defined types of alert that suits the most famous cases for displaying messages with icon.
///
/// [ZeroAlert] is an abbreviation for Under construction alert, using the first letter of project under construction.
/// You can use the widget [ZeroAlert] directly with the required parameters and the constructor will handle the rest.
/// ```dart
///   ZeroAlert(
///     originContext: context,
///     type: ZeroAlertType.warning
///     icon: Icon(Icons.warning),
///     title: Text(
///       'No internet connection!',
///       style: TextStyle(
///         fontSize: 16,
///         color: Colors.white
///     ),
///     subTitle: Text(
//        'No internet connection!',
//        style: TextStyle(
//          fontSize: 16,
//          color: Colors.white
//        )
///     )
///   )
/// ```
library zero_alert;

export 'src/zalert_brightness.dart';
export 'src/zalert_duration.dart';
export 'src/zalert_shape.dart';
export 'src/zalert_type.dart';
export 'src/zero_alert.dart';
