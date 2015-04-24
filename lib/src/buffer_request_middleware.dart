// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library shelf_buffer_request.base;

import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';

class BufferRequestMiddleware {

  Middleware get middleware => _createHandler;

  Handler _createHandler(Handler innerHandler) {
    return (Request request) => _handle(request, innerHandler);
  }

  Future<Response> _handle(Request request, Handler innerHandler) {
    var bufferedRequest = new BufferedRequest(request);
    return innerHandler(bufferedRequest);
  }

}

class BufferedRequest implements Request {

  final Request _inner;

  BufferedRequest(this._inner);

  List<List<int>> _buffer = <List<int>>[];
  Completer<List<List<int>>> _completer = new Completer<List<List<int>>>();

  Stream<List<int>> read() {

    if (_completer.isCompleted == false) {
      _buffer = new List<List<int>>();
      var s = _inner.read();
      var s3 = new Stream.fromFuture(_bufferStream(s));
      return s3;
    }
    return new Stream.fromIterable(_buffer);

  }

  Future<List<List<int>>> _bufferStream(Stream s) {
    s.listen(
            (List<int> data) {
          _buffer.add(data);
        },
        onError: _completer.completeError,
        onDone: () {
          _completer.complete(_buffer);
        },
        cancelOnError: true);
    return _completer.future;
  }

  Map<String, Object> get context => _inner.context;

  String get method => _inner.method;

  Map<String, String> get headers => _inner.headers;

  String get handlerPath => _inner.handlerPath;

  String get protocolVersion => _inner.protocolVersion;

  Uri get requestedUri => _inner.requestedUri;

  Request change({Map<String, String> headers, Map<String, Object> context, String path}) => _inner.change(headers:headers, context:context, path:path);

  void hijack(HijackCallback callback) => _inner.hijack(callback);

  String get mimeType => _inner.mimeType;

  DateTime get ifModifiedSince => _inner.ifModifiedSince;

  bool get canHijack => _inner.canHijack;

  Encoding get encoding => _inner.encoding;

  int get contentLength => _inner.contentLength;

  Uri get url => _inner.url;

  Future<String> readAsString([Encoding encoding]) => _inner.readAsString(encoding);


}
