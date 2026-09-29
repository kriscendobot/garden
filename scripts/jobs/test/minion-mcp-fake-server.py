#!/usr/bin/env python3
"""Fake Cognito token endpoint + streamable-HTTP MCP server for minion-mcp-test.sh.

POST /oauth2/token   client_credentials with Basic auth cid:sec -> a JWT-shaped token
POST /mcp            initialize / notifications/initialized / tools/list / tools/call
                     (SSE responses, like the real server)
DELETE /mcp          ends the session

Control file <state-dir>/control (state dir is argv[1]) holds one mode word per line, re-read per request:
  down        every /mcp request -> 503
  revoke      tokens issued before the mode was first seen are rejected (401)
  forget      every existing session -> 404
  expires=N   issued tokens report expires_in N
Counters are written to <state>/grants and <state>/inits.
"""
import base64, json, os, sys, threading, time, uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

STATE = sys.argv[1]
CONTROL = os.path.join(STATE, "control")
lock = threading.Lock()
tokens = {}          # token -> issue time
sessions = set()


def modes():
    try:
        return [l.strip() for l in open(CONTROL) if l.strip()]
    except OSError:
        return []


def revoked_at(m):
    """`revoke` rejects every token issued before the mode was first seen."""
    p = os.path.join(STATE, "revoked_at")
    if "revoke" not in m:
        return 0
    with lock:
        if not os.path.exists(p):
            open(p, "w").write(str(time.time()))
        return float(open(p).read())


def bump(name):
    p = os.path.join(STATE, name)
    with lock:
        n = int(open(p).read()) if os.path.exists(p) else 0
        open(p, "w").write(str(n + 1))


def b64(d):
    return base64.urlsafe_b64encode(json.dumps(d).encode()).decode().rstrip("=")


class H(BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def reply(self, code, body=b"", ctype="application/json", headers=None):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        for k, v in (headers or {}).items():
            self.send_header(k, v)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_DELETE(self):
        sessions.discard(self.headers.get("Mcp-Session-Id"))
        self.reply(200)

    def do_POST(self):
        body = self.rfile.read(int(self.headers.get("Content-Length") or 0))
        m = modes()
        if self.path == "/oauth2/token":
            if self.headers.get("Authorization") != "Basic " + base64.b64encode(b"cid:sec").decode():
                return self.reply(401, b'{"error":"invalid_client"}')
            exp_in = 3600
            for w in m:
                if w.startswith("expires="):
                    exp_in = int(w.split("=")[1])
            tok = b64({"alg": "none"}) + "." + b64({"exp": int(time.time()) + exp_in, "n": uuid.uuid4().hex}) + ".sig"
            with lock:
                tokens[tok] = time.time()
            bump("grants")
            return self.reply(200, json.dumps({"access_token": tok, "expires_in": exp_in, "token_type": "Bearer"}).encode())
        if "down" in m:
            return self.reply(503, b"down")
        auth = self.headers.get("Authorization", "")
        tok = auth[7:] if auth.startswith("Bearer ") else ""
        cutoff = revoked_at(m)
        with lock:
            valid = tok in tokens and tokens[tok] > cutoff
        if not valid:
            return self.reply(401, b'{"error":"invalid_token"}')
        msg = json.loads(body)
        sid = self.headers.get("Mcp-Session-Id")
        method = msg.get("method")
        if method != "initialize":
            if not sid or sid not in sessions or "forget" in m:
                if "forget" in m:
                    sessions.clear()
                    open(CONTROL, "w").write("\n".join(w for w in m if w != "forget"))
                return self.reply(404, b"no session")
        headers = {}
        if method == "initialize":
            sid = uuid.uuid4().hex
            sessions.add(sid)
            headers["Mcp-Session-Id"] = sid
            bump("inits")
            result = {"protocolVersion": "2025-06-18", "capabilities": {"tools": {}}, "serverInfo": {"name": "fake-minion", "version": "0"}}
        elif method == "tools/list":
            result = {"tools": [{"name": "status", "inputSchema": {"type": "object"}}, {"name": "list", "inputSchema": {"type": "object"}}]}
        elif method == "tools/call":
            result = {"content": [{"type": "text", "text": "guest holds 7 name(s)"}]}
        elif "id" not in msg:
            return self.reply(202)
        else:
            result = {}
        out = "event: message\ndata: " + json.dumps({"jsonrpc": "2.0", "id": msg.get("id"), "result": result}) + "\n\n"
        self.reply(200, out.encode(), "text/event-stream", headers)


srv = ThreadingHTTPServer(("127.0.0.1", 0), H)
open(os.path.join(STATE, "port"), "w").write(str(srv.server_address[1]))
srv.serve_forever()
