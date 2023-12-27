import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:simple_alert/simple_alert.dart';

void main() {
  runApp(const SimpleAlertExample());
}

class SimpleAlertExample extends StatelessWidget {
  const SimpleAlertExample({super.key});

  @override
  Widget build(BuildContext context) {
    // First initialization contains [context].
    SimpleAlertPreferences(
      context: context,
      // duration: SimpleAlertDuration.day,
      icons: const SimpleAlertIcons(
        normal: FluentIcons.chat_24_regular,
        success: FluentIcons.checkmark_circle_24_regular,
        info: FluentIcons.info_24_regular,
        warning: FluentIcons.warning_24_regular,
        danger: FluentIcons.error_circle_24_regular,
      ),
    );

    return MaterialApp(
      title: 'SimpleAlert',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextStyle titleStyle = const TextStyle(fontSize: 18.0);
  final double spacing = 5.0;
  final List<SimpleAlertType> alertTypes = [
    SimpleAlertType.normal,
    SimpleAlertType.success,
    SimpleAlertType.info,
    SimpleAlertType.warning,
    SimpleAlertType.danger,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple alert'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Light theme',
                  style: titleStyle,
                ),
                Wrap(
                  spacing: spacing,
                  children: <Widget>[
                    // Alert types.
                    ...List.generate(
                      alertTypes.length,
                      (int index) => ElevatedButton(
                        onPressed: () => SimpleAlert(
                          context: context,
                          type: alertTypes[index],
                          brightness: Brightness.light,
                          title: 'Simple alert title',
                          description: 'Some words describe the work performed',
                          closeOnPress: false,
                          withClose: true,
                        ),
                        child: Text(
                          alertTypes[index].toString().split('.').last, // .toUpperCase(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Text(
                  'Dark theme',
                  style: titleStyle,
                ),
                Wrap(
                  spacing: spacing,
                  children: <Widget>[
                    // Alert types.
                    ...List.generate(
                      alertTypes.length,
                      (int index) => ElevatedButton(
                        onPressed: () => SimpleAlert(
                          context: context,
                          type: alertTypes[index],
                          brightness: Brightness.dark,
                          title: 'Simple alert title',
                          description: 'Some words describe the work performed',
                          closeOnPress: false,
                          withClose: true,
                        ),
                        child: Text(
                          alertTypes[index].toString().split('.').last,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Text(
                  'Other',
                  style: titleStyle,
                ),
                Wrap(
                  spacing: spacing,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => SimpleAlert(
                        context: context,
                        title: 'Simple alert title',
                        description: 'Some words describe the work performed',
                      ),
                      child: Text('Close on press'),
                    ),
                    ElevatedButton(
                      onPressed: () => SimpleAlert(
                        context: context,
                        title: 'Simple alert title',
                        description: 'Some words describe the work performed',
                        alignmentDirectional: AlignmentDirectional.topEnd,
                        withClose: true,
                        withProgressBar: true,
                      ),
                      child: Text('Progress bar (closeOnPress, topEnd)'),
                    ),
                    ElevatedButton(
                      onPressed: () => SimpleAlert(
                        context: context,
                        title: 'Simple alert title',
                        description: 'Some words describe the work performed',
                        alignmentDirectional: AlignmentDirectional.center,
                        closeOnPress: false,
                        withClose: true,
                        withProgressBar: true,
                      ),
                      child: Text('Progress bar (center)'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final ValueNotifier<bool> dataReceived = ValueNotifier(false);

                        Future.delayed(
                          const Duration(seconds: 5),
                          () {
                            dataReceived.value = true;
                          },
                        );

                        SimpleAlert(
                          context: context,
                          title: 'Simple alert title',
                          alignmentDirectional: AlignmentDirectional.bottomStart,
                          duration: SimpleAlertDuration.day,
                          removalSignal: dataReceived,
                        );
                      },
                      child: Text('Removal signal (bottomStart)'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final ValueNotifier<bool> dataReceived = ValueNotifier(false);

                        Future.delayed(
                          const Duration(seconds: 5),
                              () {
                            dataReceived.value = true;
                          },
                        );

                        SimpleAlert(
                          context: context,
                          title: 'Simple alert title',
                          alignmentDirectional: AlignmentDirectional.bottomCenter,
                          duration: SimpleAlertDuration.day,
                          removalSignal: dataReceived,
                        );
                      },
                      child: Text('Removal signal (bottomCenter)'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final ValueNotifier<bool> dataReceived = ValueNotifier(false);

                        Future.delayed(
                          const Duration(seconds: 5),
                          () {
                            dataReceived.value = true;
                          },
                        );

                        SimpleAlert.loading(
                          context: context,
                          title: 'Simple alert title',
                          type: SimpleAlertType.success,
                          removalSignal: dataReceived,
                        );
                      },
                      child: Text('Loading'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
