import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_generate/core/core.dart';

class DefaultHttpClientAdapter implements HttpClientAdapter {
  final HttpClient _client;

  DefaultHttpClientAdapter({HttpClient? client}) : _client = client ?? HttpClient();

  @override
  Future<HttpClientResponse> send({
    required Uri url,
    required String method,
    required Map<String, String> headers,
    Uint8List? body,
  }) async {
    final request = await _client.openUrl(method, url);

    headers.forEach((key, value) => request.headers.set(key, value));

    if (body != null) {
      request.add(body);
    }

    return await request.close();
  }

  @override
  Future<HttpClientResponse> get({required Uri url}) async {
    final request = await _client.getUrl(url);
    return await request.close();
  }
}
