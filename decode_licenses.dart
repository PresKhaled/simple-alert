import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart' show debugPrint;

import 'lib/oss_licenses.g.dart';

void main() async {
  debugPrint('Acquiring licenses...');
  final handle = await OssLicenses.acquire();

  final list = handle.licenses
      .map((l) => {
            'name': l.name,
            'version': l.version,
            'licenseText': l.licenseText,
            'licenseSummary': l.licenseSummary,
            'repositoryUrl': l.repositoryUrl,
            'description': l.description,
          })
      .toList();

  final jsonStr = const JsonEncoder.withIndent('  ').convert(list);

  final outFile = File('D:/Mobile/simple_alert/oss_licenses.json');
  if (!await outFile.parent.exists()) {
    await outFile.parent.create(recursive: true);
  }

  await outFile.writeAsString(jsonStr);

  handle.close();
  debugPrint('Licenses successfully decoded and saved to: ${outFile.path}');
}
