import pytest
import requests
import os

def setup_module():
    os.spawnl(os.P_DETACH, "pwd && python3.6 ./server.py")

def test_example():
    assert 2+3 == 5, "Should be 5"

def test_response200():
    resp = requests.get("http://127.0.0.1:80")
    assert resp.status_code == 200, "Status code should be 200 if server is running"
