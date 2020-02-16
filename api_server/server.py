#!/usr/bin/python3

print("Test")

from http.server import HTTPServer, BaseHTTPRequestHandler


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Hello, world!')


httpd = HTTPServer(('0.0.0.0', 80), SimpleHTTPRequestHandler)
httpd.serve_forever()
