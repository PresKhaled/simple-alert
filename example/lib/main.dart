import 'package:example/screen_breakpoints.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:simple_alert/simple_alert.dart';

void main() {
  runApp(const SimpleAlertExample());
}

class SimpleAlertExample extends StatefulWidget {
  const SimpleAlertExample({super.key});

  @override
  State<SimpleAlertExample> createState() => _SimpleAlertExampleState();
}

class _SimpleAlertExampleState extends State<SimpleAlertExample>
    with ScreenBreakpoints {
  @override
  Widget build(BuildContext context) {
    // First initialization contains [context].
    SimpleAlertPreferences(
      context: context,
      // duration: SimpleAlertDuration.day,
      getWidth: () => super.getMainContentWidth(context),
      icons: const SimpleAlertIcons(
        normal: FluentIcons.chat_24_regular,
        success: FluentIcons.checkmark_circle_24_regular,
        info: FluentIcons.info_24_regular,
        warning: FluentIcons.warning_24_regular,
        danger: FluentIcons.error_circle_24_regular,
      ),
    ).setLocale('ar');

    return MaterialApp(
      title: 'SimpleAlert',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => SimpleAlertHost(child: child!),
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
      },
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ElevatedButton(
          onPressed: () {
            Navigator.popUntil(
              context,
              (route) => (route.settings.name == '/'),
            );
          },
          child: const Text('Close all'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Languages',
                  style: titleStyle,
                ),
                Wrap(
                  spacing: spacing,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        SimpleAlertPreferences().setLocale('ar');
                      },
                      child: const Text('Arabic'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SimpleAlertPreferences().setLocale('ur');
                      },
                      child: const Text('Urdu'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SimpleAlertPreferences().setLocale('tr');
                      },
                      child: const Text('Turkish'),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
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
                          duration: SimpleAlertDuration.long,
                          closeOnPress: false,
                          withClose: true,
                        ),
                        child: Text(
                          alertTypes[index]
                              .toString()
                              .split('.')
                              .last, // .toUpperCase(),
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
                          // animatedOpacityDuration: Duration(seconds: 3)
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
                      child: const Text('Close on press'),
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
                      child: const Text('Progress bar (closeOnPress, topEnd)'),
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
                      child: const Text('Progress bar (center)'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final ValueNotifier<bool> dataReceived =
                            ValueNotifier(false);

                        Future.delayed(
                          const Duration(seconds: 5),
                          () {
                            dataReceived.value = true;
                          },
                        );

                        SimpleAlert(
                          context: context,
                          title: 'Simple alert title',
                          alignmentDirectional:
                              AlignmentDirectional.bottomStart,
                          duration: SimpleAlertDuration.day,
                          removalSignal: dataReceived,
                        );
                      },
                      child: const Text('Removal signal (bottomStart)'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final ValueNotifier<bool> dataReceived =
                            ValueNotifier(false);

                        Future.delayed(
                          const Duration(seconds: 5),
                          () {
                            dataReceived.value = true;
                          },
                        );

                        SimpleAlert(
                          context: context,
                          title: 'Simple alert title',
                          alignmentDirectional:
                              AlignmentDirectional.bottomCenter,
                          duration: SimpleAlertDuration.day,
                          removalSignal: dataReceived,
                        );
                      },
                      child: const Text('Removal signal (bottomCenter)'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final ValueNotifier<bool> dataReceived =
                            ValueNotifier(false);

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
                      child: const Text('Loading'),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Text(
                  'BiDi & Stacking Features',
                  style: titleStyle,
                ),
                Wrap(
                  spacing: spacing,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => SimpleAlert(
                        context: context,
                        type: SimpleAlertType.success,
                        title: 'تم استيراد الكتاب بنجاح',
                        description:
                            'تم الحفظ في المسار: /storage/emulated/0/Books/Clean_Architecture.epub',
                        duration: SimpleAlertDuration.long,
                        withClose: true,
                        withProgressBar: true,
                      ),
                      child: const Text('BiDi File Path (مسار ملف)'),
                    ),
                    ElevatedButton(
                      onPressed: () => SimpleAlert(
                        context: context,
                        type: SimpleAlertType.info,
                        title: 'جاري فتح الكتاب',
                        description:
                            'الكتاب المحدد هو "Refactoring: Improving the Design of Existing Code".',
                        duration: SimpleAlertDuration.long,
                        withClose: true,
                      ),
                      child: const Text('Mixed Arabic/English Book'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        for (int i = 1; i <= 3; i++) {
                          Future.delayed(Duration(milliseconds: (i - 1) * 200), () {
                            SimpleAlert(
                              context: context,
                              type: alertTypes[(i - 1) % alertTypes.length],
                              title: 'تنبيه رقم $i متزامن',
                              description:
                                   'اسحب للإغلاق لمشاهدة انزلاق باقي التنبيهات بسلاسة',
                              alignmentDirectional:
                                  AlignmentDirectional.topCenter,
                              duration: SimpleAlertDuration.long,
                              withClose: true,
                              withProgressBar: true,
                            );
                          });
                        }
                      },
                      child: const Text('Stack 3 Simultaneous Alerts (انزلاق متزامن)'),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Text(
                  'Persistent Across Routes & Dialogs (الصمود عبر الصفحات)',
                  style: titleStyle,
                ),
                Wrap(
                  spacing: spacing,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        SimpleAlert(
                          context: context,
                          type: SimpleAlertType.success,
                          title: 'تنبيه مستمر عبر التنقل',
                          description:
                              'لاحظ بقاء هذا الإشعار في القمة رغم الانتقال لشاشة جديدة بالكامل!',
                          duration: SimpleAlertDuration.long,
                          withClose: true,
                          withProgressBar: true,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => Scaffold(
                              appBar: AppBar(title: const Text('صفحة جديدة')),
                              body: const Center(
                                child: Text('هذه صفحة جديدة، والإشعار بالأعلى يواصل العمل!'),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Push New Route (فتح صفحة جديدة)'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SimpleAlert(
                          context: context,
                          type: SimpleAlertType.warning,
                          title: 'تنبيه يطفو فوق النوافذ المنبثقة',
                          description: 'الإشعار يظهر بأعلى الـ Dialog دون أن يحجبه!',
                          duration: SimpleAlertDuration.long,
                          withClose: true,
                          withProgressBar: true,
                        );
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('نافذة منبثقة (Modal Dialog)'),
                            content: const Text('الإشعار يطفو بأعلى هذه النافذة بكل سلاسة.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('إغلاق'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Show Dialog (فتح نافذة منبثقة)'),
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
