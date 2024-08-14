import 'dart:io';

import 'package:easy_tv_live/setting_page.dart';
import 'package:easy_tv_live/subscribe/subscribe_page.dart';
import 'package:easy_tv_live/util/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:sp_util/sp_util.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';

import 'generated/l10n.dart';
import 'live_home_page.dart';
import 'router_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(375, 667),
    minimumSize: Size(300, 300 * 9 / 16),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: '极简TV',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  WakelockPlus.enable();
  LogUtil.init(isDebug: true, tag: 'EasyTV');
  await SpUtil.getInstance();
  fvp.registerWith(options: {
    'platforms': ['android', 'ios', 'windows', 'linux', 'macos'],
    'video.decoders': ['FFmpeg']
  });
  runApp(const MyApp());
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '极简TV',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Kaiti', useMaterial3: true),
      routes: {
        RouterKeys.subScribe: (BuildContext context) => const SubScribePage(),
        RouterKeys.setting: (BuildContext context) => const SettingPage()
      },
      locale: const Locale('zh', ''),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('zh', ''), ...S.delegate.supportedLocales],
      debugShowCheckedModeBanner: false,
      home: const LiveHomePage(),
      builder: EasyLoading.init(),
    );
  }
}
