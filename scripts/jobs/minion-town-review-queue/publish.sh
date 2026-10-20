#!/usr/bin/env bash
# publish.sh — build and publish the minion.town review-queue clip.
#
#   publish.sh [--pet-name minion-town-review-queue-<x>] [--out DIR] [--no-build]
#   publish.sh --unpublish <clip-hash-or-url>
#
# Per skills/minion-town-clip-publishing: static files only, an inert powers pet
# name (an empty writeText, never "sites" or "@agent"), published through the stdio
# MCP bridge, then every file is fetched with curl and cmp'd against the local copy.
# Needs this host's minion.town MCP credential (requires: aws on the fleet).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
garden="$(cd "$here/../../.." && pwd)"
pet="minion-town-review-queue-inert"
out="${GARDEN_ROOT:-$HOME}/scratch/minion-town-review-queue-$(date -u +%Y%m%dT%H%M%SZ)"
build=1 unpublish=""
while [ $# -gt 0 ]; do
  case "$1" in
    --pet-name) pet="$2"; shift 2 ;;
    --out) out="$2"; shift 2 ;;
    --no-build) build=0; shift ;;
    --unpublish) unpublish="$2"; shift 2 ;;
    *) echo "usage: $0 [--pet-name minion-town-review-queue-*] [--out DIR] [--no-build] | --unpublish HASH" >&2; exit 2 ;;
  esac
done
case "$pet" in minion-town-review-queue-*) ;; *) echo "refusing pet name '$pet' (must be minion-town-review-queue-*)" >&2; exit 2 ;; esac

# shellcheck source=/dev/null
source "$garden/scripts/jobs/minion-mcp-lib.sh"
env_json="$(minion_mcp_env_json)"

if [ -z "$unpublish" ]; then
  [ "$build" = 1 ] && python3 -I "$here/build.py" "$out" --journal "${GARDEN_ROOT:-$HOME}/journal" >&2
  [ -f "$out/index.html" ] && [ -f "$out/styles.css" ] || { echo "no built clip in $out" >&2; exit 1; }
fi

result="$(MODE="${unpublish:+unpublish}" TARGET="$unpublish" PET="$pet" OUT="$out" ENV_JSON="$env_json" \
  BRIDGE="$garden/scripts/jobs/minion-mcp-bridge.py" python3 -I - <<'PY'
import base64, json, os, re, subprocess, sys
env = dict(os.environ); env.update(json.loads(os.environ["ENV_JSON"]))
p = subprocess.Popen([sys.executable, "-I", os.environ["BRIDGE"]], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True, env=env)
seq = [0]
def rpc(method, params=None, notify=False):
    msg = {"jsonrpc": "2.0", "method": method}
    if params is not None: msg["params"] = params
    if not notify:
        seq[0] += 1; msg["id"] = seq[0]
    p.stdin.write(json.dumps(msg) + "\n"); p.stdin.flush()
    if notify: return None
    while True:
        line = p.stdout.readline()
        if not line: sys.exit("bridge closed")
        r = json.loads(line)
        if r.get("id") == msg["id"]:
            if "error" in r: sys.exit(f"{method}: {r['error']}")
            return r["result"]
def call(name, args):
    r = rpc("tools/call", {"name": name, "arguments": args})
    text = "".join(c.get("text", "") for c in r.get("content", []))
    if r.get("isError"): sys.exit(f"{name}: {text[:500]}")
    return text
rpc("initialize", {"protocolVersion": "2025-06-18", "capabilities": {}, "clientInfo": {"name": "review-queue-publisher", "version": "1"}})
rpc("notifications/initialized", notify=True)
if os.environ.get("MODE") == "unpublish":
    tools = {t["name"]: t for t in rpc("tools/list")["tools"]}
    req = tools["unpublish"]["inputSchema"].get("required") or list(tools["unpublish"]["inputSchema"].get("properties", {}))
    target = os.environ["TARGET"]
    m = re.search(r"([a-z0-9]{16,})\.ocap\.site", target)
    print(call("unpublish", {req[0]: m.group(1) if m else target}))
    sys.exit(0)
tools = {t["name"]: t for t in rpc("tools/list")["tools"]}
wt = tools["writeText"]["inputSchema"].get("properties", {})
name_key = next((k for k in ("petName", "name", "path") if k in wt), list(wt)[0])
text_key = next((k for k in ("text", "content", "value") if k in wt), list(wt)[1])
call("writeText", {name_key: os.environ["PET"], text_key: ""})
out = os.environ["OUT"]
content = []
for f, ct in (("index.html", "text/html; charset=utf-8"), ("styles.css", "text/css; charset=utf-8")):
    with open(os.path.join(out, f), "rb") as fh:
        content.append({"path": f, "contentType": ct, "bytes": base64.b64encode(fh.read()).decode()})
text = call("publish", {"powers": os.environ["PET"], "content": content})
m = re.search(r"https://[a-z0-9]+\.ocap\.site/?", text)
if not m: sys.exit(f"publish returned no URL: {text[:500]}")
print(m.group(0).rstrip("/") + "/")
PY
)"
if [ -n "$unpublish" ]; then echo "$result"; exit 0; fi

url="$result"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
for f in index.html styles.css; do
  path="$f"; [ "$f" = index.html ] && path=""
  curl -fsS --max-time 60 "$url$path" -o "$tmp/$f"
  cmp "$tmp/$f" "$out/$f"
done
echo "published and verified: $url (pet name $pet, files in $out)" >&2
echo "$url"
