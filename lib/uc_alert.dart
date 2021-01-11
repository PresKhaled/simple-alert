/// UCAlert is a pre-defined types of alert that suits the most famous cases for displaying messages with icon.
///
/// [UCAlert] is an abbreviation for Under construction alert, using the first letter of project under construction.
/// You can use the widget [UCAlert] directly with the required parameters and the constructor will handle the rest.
/// ```dart
///   UCAlert(
///     originContext: context,
///     type: UCAlertType.warning
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
library uc_alert;

export 'src/uc_alert.dart';
export 'src/uc_alert_type.dart';
