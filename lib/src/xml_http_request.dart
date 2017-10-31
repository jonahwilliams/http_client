// Copyright (c) 2017, Jonah Williams. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library xml_http_request;

import 'package:js/js.dart';
import 'dart:html';

typedef void ReadyCallback(Event event);

@JS()
class XMLHttpRequest {
  external factory XMLHttpRequest();

  external set onreadystatechange(ReadyCallback callback);
  external ReadyCallback get onreadystatechange;

  external int get readyState;

  external int get status;

  external set timeout(num value);

  external String get statusText;

  external String get responseText;

  external void open(String method, String url, [bool isSync = false]);

  external void send([String value]);

  external void abort();

  external void setRequestHeader(String name, String value);
}
