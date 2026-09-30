import base64, json, os, subprocess, sys
env = dict(os.environ); env.update(json.loads(sys.argv[1]))
files = [("index.html","text/html; charset=utf-8"),("styles.css","text/css; charset=utf-8")]
content = [{"path":p,"contentType":t,"bytes":base64.b64encode(open("out/"+p,"rb").read()).decode()} for p,t in files]
proc = subprocess.Popen(["python3",os.path.join(os.environ.get("GARDEN_ROOT", os.path.expanduser("~")), "scripts/jobs/minion-mcp-bridge.py")],stdin=subprocess.PIPE,stdout=subprocess.PIPE,env=env,text=True)
def send(o): proc.stdin.write(json.dumps(o)+"\n"); proc.stdin.flush()
def recv(i):
    while True:
        line = proc.stdout.readline()
        if not line: raise SystemExit("bridge closed")
        m = json.loads(line)
        if m.get("id") == i: return m
send({"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"garden-book","version":"1"}}})
recv(1)
send({"jsonrpc":"2.0","method":"notifications/initialized"})
send({"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"publish","arguments":{"powers":"sites","content":content}}})
print(json.dumps(recv(2))[:2000])
proc.stdin.close(); proc.terminate()
