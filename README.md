# shelf_buffer_request

A middleware for shelf that buffers the request so its body can be read multiple times.

## Usage

A simple usage example:

    main() {

      Handler handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(bufferRequests())
      .addMiddleware(readBodyMiddleware)
      .addMiddleware(readBodyMiddleware)
      .addMiddleware(readBodyMiddleware)
      .addHandler((request) => new Response.ok("Got it!"));

      io.serve(handler, InternetAddress.ANY_IP_V4, 1234).then((server) {
        print('Serving at http://${server.address.host}:${server.port}');
      });

    }

    Handler readBodyMiddleware(Handler innerHandler) {
      return (Request request) async {
        var body = await request.read().toList();
        print("The body size was ${body.length}");
        return innerHandler(request);
      };
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/jonaskello/shelf_buffer_request/issues
