import pytest
import requests
import subprocess
import time

server_p = None

def setup_module():
    server_p = subprocess.Popen(["/usr/local/bin/python3", "/tmp/api_server/server.py"])
    time.sleep(2)

def test_example():
    assert 2+3 == 5, "Should be 5"

def test_response200():
    resp = requests.get("http://127.0.0.1:80")
    print("Response data: %s" % resp.content)
    assert resp.status_code == 200, "Status code should be 200 if server is running"
