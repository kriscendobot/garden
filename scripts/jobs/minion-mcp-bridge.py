#!/usr/bin/env python3
"""minion-mcp-bridge.py: a stdio MCP server that relays to minion.town's
streamable-HTTP MCP endpoint, attaching a fresh OAuth bearer token to every request.

Every worker harness in the garden (claude -p, codex exec, kimi, opencode) can spawn
a stdio MCP server; they differ in how, or whether, they refresh a remote server's
bearer token. Codex reads `bearer_token_env_var` once at startup, and a Claude Code
headersHelper runs at connect time. A Cognito access token lives 3600s, while a
handler budget runs to 14339s. So one bridge gives every harness the same
reconnect behavior:

  * per request, the bearer comes from minion-mcp-token.sh (host-local 0600 cache,
    refreshed near expiry); the bridge keeps it in memory until 120s before its
    JWT `exp` and never sees the client secret;
  * HTTP 401 -> force a token refresh and retry the request once;
  * HTTP 404 on a request carrying an Mcp-Session-Id (the server forgot the session,
    e.g. across a server restart) -> replay the client's own `initialize` +
    `notifications/initialized` to open a new session, then retry once;
  * a transport failure answers the pending request with a JSON-RPC error, so the
    harness reports a failed tool call instead of hanging.

Usage:
  minion-mcp-bridge.py            stdio MCP server (what the harness spawns)
  minion-mcp-bridge.py --probe [--call TOOL]
                                  one-shot health check: initialize, tools/list,
                                  optionally one tools/call with {} arguments;
                                  prints a JSON summary (tool names, never a token)
                                  and exits 0 iff it all succeeded.

Environment: GARDEN_MINION_MCP_URL (default https://minion.town/mcp),
GARDEN_MINION_MCP_TOKEN_CMD (default: the sibling minion-mcp-token.sh),
GARDEN_MINION_MCP_REQUEST_TIMEOUT (seconds, default 600).
"""

import base64
import json
import os
import subprocess
import sys
import threading
import time
import urllib.error
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
URL = os.environ.get("GARDEN_MINION_MCP_URL", "https://minion.town/mcp")
TOKEN_CMD = os.environ.get("GARDEN_MINION_MCP_TOKEN_CMD", os.path.join(HERE, "minion-mcp-token.sh"))
TIMEOUT = float(os.environ.get("GARDEN_MINION_MCP_REQUEST_TIMEOUT", "600"))
MEMORY_MARGIN = 120
PROTOCOL = "2025-06-18"


def warn(msg):
    sys.stderr.write("minion-mcp-bridge: %s\n" % msg)
    sys.stderr.flush()


class TransportError(Exception):
    pass


class Bridge:
    def __init__(self, emit):
        self.emit = emit                 # called with each server->client message
        self.lock = threading.Lock()     # guards token + session state
        self.token = None
        self.token_exp = 0
        self.session = None
        self.protocol = None
        self.init_msg = None             # the client's initialize, kept for replay

    # --- credentials ----------------------------------------------------------
    def bearer(self, force=False):
        with self.lock:
            if not force and self.token and self.token_exp - time.time() > MEMORY_MARGIN:
                return self.token
            args = [TOKEN_CMD, "token"] + (["--force"] if force else [])
            try:
                out = subprocess.run(args, capture_output=True, text=True, timeout=120)
            except (OSError, subprocess.TimeoutExpired) as e:
                raise TransportError("token helper failed: %s" % e)
            tok = out.stdout.strip()
            if out.returncode != 0 or not tok:
                raise TransportError("token helper failed: %s" % out.stderr.strip()[-300:])
            self.token, self.token_exp = tok, jwt_exp(tok)
            return tok

    # --- one HTTP exchange ----------------------------------------------------
    def post(self, msg, token):
        headers = {
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
        }
        if self.session:
            headers["Mcp-Session-Id"] = self.session
        if self.protocol:
            headers["MCP-Protocol-Version"] = self.protocol
        req = urllib.request.Request(URL, data=json.dumps(msg).encode(), headers=headers, method="POST")
        try:
            resp = urllib.request.urlopen(req, timeout=TIMEOUT)
        except urllib.error.HTTPError as e:
            return e.code, None
        except (urllib.error.URLError, OSError) as e:
            raise TransportError("POST %s failed: %s" % (URL, e))
        sid = resp.headers.get("Mcp-Session-Id")
        if sid and msg.get("method") == "initialize":
            self.session = sid
        return resp.status, resp

    def relay(self, msg, replaying=False):
        """Send msg; forward every server message it yields to self.emit.
        Returns the list of messages emitted (used by probe/replay)."""
        token = self.bearer()
        status, resp = self.post(msg, token)
        if status == 401:
            warn("401 from server; refreshing token and retrying")
            status, resp = self.post(msg, self.bearer(force=True))
        if status == 404 and self.session and not replaying and msg.get("method") != "initialize":
            warn("session expired (404); re-initializing and retrying")
            self.reinitialize()
            status, resp = self.post(msg, self.bearer())
        if resp is None:
            raise TransportError("HTTP %s from %s" % (status, URL))
        return self.read(resp)

    def read(self, resp):
        out = []
        ctype = (resp.headers.get("Content-Type") or "").lower()
        with resp:
            if "text/event-stream" in ctype:
                data = []
                for raw in resp:
                    line = raw.decode("utf-8", "replace").rstrip("\r\n")
                    if line == "":
                        if data:
                            out.extend(self.deliver("\n".join(data)))
                            data = []
                    elif line.startswith("data:"):
                        data.append(line[5:].lstrip(" ") if line[5:6] == " " else line[5:])
                if data:
                    out.extend(self.deliver("\n".join(data)))
            else:
                body = resp.read().decode("utf-8", "replace").strip()
                if body:
                    out.extend(self.deliver(body))
        return out

    def deliver(self, text):
        try:
            parsed = json.loads(text)
        except ValueError:
            warn("dropping non-JSON server data")
            return []
        msgs = parsed if isinstance(parsed, list) else [parsed]
        for m in msgs:
            self.emit(m)
        return msgs

    def reinitialize(self):
        if not self.init_msg:
            raise TransportError("session expired before initialize was seen")
        self.session = None
        replay = dict(self.init_msg, id="bridge-reinit-%d" % int(time.time() * 1000))
        saved, self.emit = self.emit, (lambda m: None)   # the harness never asked for these
        try:
            self.relay(replay, replaying=True)
            self.relay({"jsonrpc": "2.0", "method": "notifications/initialized"}, replaying=True)
        finally:
            self.emit = saved

    # --- one client message ---------------------------------------------------
    def handle(self, msg):
        is_request = "method" in msg and "id" in msg
        if msg.get("method") == "initialize":
            self.init_msg = msg
            self.session = None
        try:
            got = self.relay(msg)
            if msg.get("method") == "initialize":
                for m in got:
                    if m.get("id") == msg.get("id") and isinstance(m.get("result"), dict):
                        self.protocol = m["result"].get("protocolVersion") or self.protocol
        except TransportError as e:
            warn(str(e))
            if is_request:
                self.emit({"jsonrpc": "2.0", "id": msg["id"],
                           "error": {"code": -32000, "message": "minion.town MCP unreachable: %s" % e}})

    def close(self):
        if not self.session or not self.token:
            return
        req = urllib.request.Request(URL, method="DELETE", headers={
            "Authorization": "Bearer " + self.token, "Mcp-Session-Id": self.session})
        try:
            urllib.request.urlopen(req, timeout=10).close()
        except Exception:  # best effort: the server also expires idle sessions
            pass


def jwt_exp(token):
    try:
        payload = token.split(".")[1]
        payload += "=" * (-len(payload) % 4)
        return float(json.loads(base64.urlsafe_b64decode(payload)).get("exp", 0))
    except Exception:
        return time.time() + 300   # opaque token: trust it briefly, then re-ask


def serve():
    out_lock = threading.Lock()

    def emit(m):
        with out_lock:
            sys.stdout.write(json.dumps(m, separators=(",", ":")) + "\n")
            sys.stdout.flush()

    bridge = Bridge(emit)
    workers = []
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except ValueError:
            warn("dropping non-JSON client line")
            continue
        batch = msg if isinstance(msg, list) else [msg]
        for m in batch:
            if not isinstance(m, dict):
                continue
            # initialize must finish before anything else can use its session; other
            # requests run concurrently so a long tools/call cannot block the next one.
            if m.get("method") == "initialize" or "id" not in m or "method" not in m:
                bridge.handle(m)
            else:
                t = threading.Thread(target=bridge.handle, args=(m,), daemon=True)
                t.start()
                workers.append(t)
        workers = [t for t in workers if t.is_alive()]
    for t in workers:
        t.join(timeout=TIMEOUT)
    bridge.close()


def probe(call=None):
    got = {}
    bridge = Bridge(lambda m: got.__setitem__(m.get("id"), m))
    summary = {"url": URL, "ok": False}
    try:
        bridge.handle({"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {
            "protocolVersion": PROTOCOL, "capabilities": {},
            "clientInfo": {"name": "garden-minion-mcp-probe", "version": "1"}}})
        init = got.get(1, {})
        if "result" not in init:
            summary["error"] = "initialize: %s" % init.get("error", "no response")
            return summary
        summary["server"] = init["result"].get("serverInfo", {})
        bridge.handle({"jsonrpc": "2.0", "method": "notifications/initialized"})
        bridge.handle({"jsonrpc": "2.0", "id": 2, "method": "tools/list"})
        tools = got.get(2, {})
        if "result" not in tools:
            summary["error"] = "tools/list: %s" % tools.get("error", "no response")
            return summary
        summary["tools"] = [t.get("name") for t in tools["result"].get("tools", [])]
        if call:
            bridge.handle({"jsonrpc": "2.0", "id": 3, "method": "tools/call",
                           "params": {"name": call, "arguments": {}}})
            res = got.get(3, {})
            if "result" not in res or res["result"].get("isError"):
                summary["error"] = "tools/call %s failed" % call
                return summary
            summary["called"] = call
        summary["ok"] = bool(summary["tools"])
        if not summary["ok"]:
            summary["error"] = "tools/list returned no tools"
        return summary
    finally:
        bridge.close()


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--probe":
        call = sys.argv[3] if len(sys.argv) > 3 and sys.argv[2] == "--call" else None
        s = probe(call)
        print(json.dumps(s))
        sys.exit(0 if s["ok"] else 1)
    serve()
