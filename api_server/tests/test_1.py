import pytest
import requests
import subprocess

server_p = None

def setup_module():
    server_p = subprocess.Popen(["pwd", "&&", "python3", "./server.py"])

def teardown_module():
    server_p.communicate()

def test_example():
    assert 2+3 == 5, "Should be 5"

def test_response200():
    resp = requests.get("http://127.0.0.1:80")
    assert resp.status_code == 200, "Status code should be 200 if server is running"
