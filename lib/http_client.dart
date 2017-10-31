// Copyright (c) 2017, Jonah Williams. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library http_client;

import 'dart:async';
import 'dart:html';

import 'package:js/js.dart';

import 'src/xml_http_request.dart';

/// A Stream-based interface for `XMLHttpRequest`.
class HttpClient {
  const HttpClient();

  /// GET [url].
  ///
  /// Returns a single subscription [Stream] which will emit a single event
  /// before closing.  The request is not performed until the stream is
  /// listened to.
  Stream<String> get(
    String url, {
    Map<String, String> headers,
    num timeout,
  }) =>
      _makeRequest(url, 'GET', headers: headers, timeout: timeout);

  /// POST [data] to [url].
  ///
  /// Returns a single subscription [Stream] which will emit a single event
  /// before closing.  The request is not performed until the stream is
  /// listened to.
  ///
  /// [data] should either be a String value or an object with the
  /// appropriate String value.  For JSON data, it is necessary to encode the
  /// value first.
  Stream<String> post(
    String url,
    Object data, {
    Map<String, String> headers,
    num timeout,
  }) =>
      _makeRequest(url, 'POST', data: data, headers: headers, timeout: timeout);

  Stream<String> _makeRequest(
    String url,
    String method, {
    Object data,
    Map<String, String> headers,
    num timeout,
  }) {
    var request = new XMLHttpRequest()..open(method, url);
    var onCancel = () {
      if (request.status != 4) {
        request.abort();
      }
    };
    var onListen = () {
      if (data == null) {
        request.send();
      } else {
        request.send(data.toString());
      }
    };
    var controller = new StreamController<String>(
      onCancel: onCancel,
      onListen: onListen,
    );
    // add headers if provided.
    if (headers != null) {
      for (var key in headers.keys) {
        request.setRequestHeader(key, headers[key]);
      }
    }
    // add a timeout value if provided.
    if (timeout != null) {
      request.timeout = timeout;
    }
    request.onreadystatechange = allowInterop((Event _) {
      if (request.readyState == 4) {
        if (request.status == 200) {
          controller
            ..add(request.responseText)
            ..close();
        } else {
          controller
            ..addError(new Exception('${request.status} ${request.statusText}'))
            ..close();
        }
      }
    });

    return controller.stream;
  }
}
