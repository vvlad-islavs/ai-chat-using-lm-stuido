import 'dart:io';

import 'package:flutter/services.dart';

abstract class HttpClientAdapter {
  Future<HttpClientResponse> send({
    required Uri url,
    required String method,
    required Map<String, String> headers,
    Uint8List? body,
  });

  Future<HttpClientResponse> get({
    required Uri url,
  });
}