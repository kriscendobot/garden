#!/usr/bin/env python3
"""Send one fixed operation to the local broker and emit only its response body."""
import argparse
import base64
import json
import os
from pathlib import Path
import socket
import sys

parser = argparse.ArgumentParser()
parser.add_argument("--service", required=True)
parser.add_argument("--operation", required=True)
parser.add_argument("--authorized-by", required=True)
parser.add_argument("--body-file")
parser.add_argument("--status-file")
parser.add_argument("--timeout", type=int, default=60)
args = parser.parse_args()
body = Path(args.body_file).read_bytes() if args.body_file else b""
root = Path(os.environ.get("GARDEN_ROOT", Path(__file__).resolve().parents[2]))
state = Path(os.environ.get("GARDEN_STATE", root / ".garden-state"))
sock_path = os.environ.get("GARDEN_SECRET_BROKER_SOCKET", str(state / "secret-broker.sock"))
request = {"service": args.service, "operation": args.operation,
           "authorized_by": args.authorized_by, "body_b64": base64.b64encode(body).decode(),
           "timeout": args.timeout}
with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
    client.connect(sock_path)
    client.sendall(json.dumps(request, separators=(",", ":")).encode())
    client.shutdown(socket.SHUT_WR)
    response = json.loads(client.makefile("rb").read())
if args.status_file:
    Path(args.status_file).write_text(str(response.get("status", 0)) + "\n")
sys.stdout.buffer.write(base64.b64decode(response.get("body_b64", "")))
if not response.get("ok"):
    raise SystemExit(22 if response.get("status", 0) else 1)
