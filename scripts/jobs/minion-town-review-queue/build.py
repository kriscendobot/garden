#!/usr/bin/env python3
"""build.py: render the minion.town review-queue clip (a static snapshot).

Usage: build.py <out-dir> [--journal <journal-worktree>]

Joins queue.json (the curated ranking: unblocks, action, topics) with live state:
open PRs, CI per head (Actions runs API; the bot PAT cannot read check rollups),
the latest main commit and deploy, gauntlet panel trends from journal
panel-runs/, and parked minion.town jobs from journal jobs/plan/. Edges come from
stacked base branches, "depends on #N"-style PR body references (only the number
is kept), blocked_on gates on parked jobs, and queue.json deps. The page order is
a Kahn topological sort with the curated rank as the tie-break, so a blocker
never sorts below what it blocks (skills/pr-dependency-topo-sort, rank in place of
number). Writes index.html and styles.css, then runs a privacy scrub over the
output and exits 3 if anything matches.
"""
import heapq
import html
import json
import os
import re
import shutil
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = "kriscendobot/minion.town"
PR_URL = f"https://github.com/{REPO}/pull/"


def gh(path):
    out = subprocess.run(["gh", "api", path], capture_output=True, text=True, timeout=120)
    if out.returncode != 0:
        raise RuntimeError(f"gh api {path}: {out.stderr.strip()[:200]}")
    return json.loads(out.stdout)


def open_prs():
    fields = "number,title,isDraft,mergeable,baseRefName,headRefName,headRefOid,additions,deletions,changedFiles,body"
    out = subprocess.run(["gh", "pr", "list", "-R", REPO, "--state", "open", "--limit", "200", "--json", fields],
                         capture_output=True, text=True, timeout=180, check=True)
    return {p["number"]: p for p in json.loads(out.stdout)}


def ci_state(sha):
    try:
        runs = gh(f"repos/{REPO}/actions/runs?head_sha={sha}&per_page=50").get("workflow_runs", [])
    except RuntimeError as e:
        print(f"warn: CI unknown for {sha[:12]}: {e}", file=sys.stderr)
        return "unknown", []
    latest = {}
    for r in sorted(runs, key=lambda r: r["created_at"]):
        latest[r["name"]] = r
    if not latest:
        return "none", []
    pending = [n for n, r in latest.items() if r["status"] != "completed"]
    failed = [n for n, r in latest.items() if r["status"] == "completed" and r["conclusion"] not in ("success", "skipped", "neutral")]
    if failed:
        return "red", sorted(failed)
    if pending:
        return "pending", sorted(pending)
    return "green", []


def frontmatter(path):
    meta = {}
    with open(path, encoding="utf-8", errors="replace") as f:
        lines = f.read().split("\n")
    if not lines or lines[0] != "---":
        return meta
    for line in lines[1:]:
        if line == "---":
            break
        if ":" in line:
            k, v = line.split(":", 1)
            meta.setdefault(k.strip(), v.strip())
    return meta


def panel_trend(journal, n):
    d = os.path.join(journal, "panel-runs", f"kriscendobot-minion.town-{n}")
    if not os.path.isdir(d):
        return None
    runs = []
    for name in os.listdir(d):
        m = frontmatter(os.path.join(d, name))
        if m.get("disposition") == "interrupted" or not m.get("must_fix_total"):
            continue
        runs.append((os.path.getmtime(os.path.join(d, name)), int(m["must_fix_total"]), m.get("disposition", "")))
    runs.sort()
    if not runs:
        return None
    counts = [str(c) + ("+" if c >= 20 else "") for _, c, _ in runs]
    return {"rounds": len(runs), "counts": counts[-6:], "last": runs[-1][2]}


def plan_jobs(journal):
    d = os.path.join(journal, "jobs", "plan")
    jobs = {}
    for name in sorted(os.listdir(d)):
        p = os.path.join(d, name)
        with open(p, encoding="utf-8", errors="replace") as f:
            text = f.read()
        if not re.search(r"minion[.-]town", text, re.I):
            continue
        m = frontmatter(p)
        title = next((l[2:].strip() for l in text.split("\n") if l.startswith("# ")), "")
        jobs[name[:-3]] = {"gate": m.get("gate", ""), "blocked_on": m.get("blocked_on", ""),
                           "doomed": m.get("doomed") == "true", "title": title}
    return jobs


BODY_DEP = re.compile(r"(?:depends on|blocked (?:on|by)|stacked on|on top of|builds on|merge after|requires)\s+"
                      r"(?:https://github\.com/kriscendobot/minion\.town/pull/|#)(\d+)", re.I)


def edges_for(prs, plans, q):
    edges = {}
    heads = {p["headRefName"]: n for n, p in prs.items()}
    for n, p in prs.items():
        base = p["baseRefName"]
        parent = heads.get(base) or heads.get(re.sub(r"-[0-9a-f]{7,40}$", "", base))
        if parent and parent != n:
            edges[(f"pr:{parent}", f"pr:{n}")] = "stacked: based on its branch"
        for m in BODY_DEP.finditer(p.get("body") or ""):
            k = int(m.group(1))
            if k in prs and k != n:
                edges.setdefault((f"pr:{k}", f"pr:{n}"), "named as a dependency in the PR body")
    for base, j in plans.items():
        m = re.search(r"/pull/(\d+)$", j["blocked_on"])
        if m and int(m.group(1)) in prs:
            edges.setdefault((f"pr:{m.group(1)}", f"job:{base}"), "parked job's blocked_on gate")
    soft = set()
    for e in q["deps"]:
        edges[(e["from"], e["to"])] = e["why"]
        if e.get("soft"):
            soft.add((e["from"], e["to"]))
    return edges, soft


def topo(nodes, edges, rank):
    indeg = {n: 0 for n in nodes}
    succ = {n: [] for n in nodes}
    for (a, b) in edges:
        if a in indeg and b in indeg:
            succ[a].append(b)
            indeg[b] += 1
    heap = [(rank(n), n) for n in nodes if indeg[n] == 0]
    heapq.heapify(heap)
    out = []
    while heap:
        _, n = heapq.heappop(heap)
        out.append(n)
        for b in succ[n]:
            indeg[b] -= 1
            if indeg[b] == 0:
                heapq.heappush(heap, (rank(b), b))
    cycle = [n for n in nodes if n not in out]
    return out, cycle


def descendants(node, edges):
    succ = {}
    for (a, b) in edges:
        succ.setdefault(a, []).append(b)
    seen, stack = set(), [node]
    while stack:
        for b in succ.get(stack.pop(), []):
            if b not in seen:
                seen.add(b)
                stack.append(b)
    return seen


def esc(s):
    return html.escape(str(s), quote=True)


def label(node, prs, q):
    kind, key = node.split(":", 1)
    if kind == "pr":
        n = int(key)
        t = prs[n]["title"] if n in prs else "(not open)"
        return f'<a href="{PR_URL}{n}">#{n}</a> {esc(t)}'
    if kind == "job":
        return f"Parked job <code>{esc(key)}</code>"
    return esc(q["commands"].get(node, {}).get("title", key))


def state_cell(node, prs, ci):
    if not node.startswith("pr:"):
        return '<span class="pill">decision</span>'
    n = int(node[3:])
    if n not in prs:
        return '<span class="pill">not open</span>'
    p = prs[n]
    c, names = ci.get(n, ("none", []))
    bits = [f'<span class="pill {"draft" if p["isDraft"] else "ready"}">{"draft" if p["isDraft"] else "ready"}</span>',
            f'<span class="pill ci-{c}" title="{esc(", ".join(names))}">CI {c}</span>',
            f'<span class="pill">{esc(p["mergeable"].lower())}</span>',
            f'<span class="size">+{p["additions"]}/&minus;{p["deletions"]} · {p["changedFiles"]} files</span>']
    return " ".join(bits)


def render(q, prs, ci, plans, edges, soft, main, deploy, trends, generated):
    ranked = [r["id"] for r in q["ranked"]]
    rank_of = {n: i for i, n in enumerate(ranked)}
    hard = {e: w for e, w in edges.items() if e not in soft}
    order, cycle = topo(ranked, hard, lambda n: rank_of[n])
    rows = []
    for pos, node in enumerate(order, 1):
        r = q["ranked"][rank_of[node]]
        blockers = [a for (a, b) in hard if b == node]
        after = ", ".join(a.split(":", 1)[1] if a.startswith("job:") else ("#" + a[3:] if a.startswith("pr:") else "migration")
                          for a in blockers)
        down = len(descendants(node, edges))
        topics = "".join(f"<li>{esc(t)}</li>" for t in r.get("topics", []))
        trend = ""
        if node.startswith("pr:"):
            t = trends.get(int(node[3:]))
            if t:
                trend = (f'<p class="trend">Panel: {t["rounds"]} scored run(s), must-fix counts '
                         f'{" → ".join(t["counts"])}. ')
                if r.get("trend"):
                    trend += f"Reading: <b>{esc(r['trend'])}</b>."
                trend += "</p>"
        cmd = f'<pre><code>{esc(r["command"])}</code></pre>' if r.get("command") else ""
        rows.append(f"""<li class="item" id="{esc(node.replace(':', '-'))}">
<div class="head"><span class="rank">{pos}</span><h3>{label(node, prs, q)}</h3></div>
<p class="state">{state_cell(node, prs, ci)}</p>
<p><b>Unblocks:</b> {esc(r["unblocks"])} <span class="down">({down} downstream)</span></p>
{f'<p><b>After:</b> {esc(after)}</p>' if after else ''}
<p class="ask"><b>Your action:</b> {esc(r["action"])}</p>
{cmd}
{f'<p><b>Worth a reviewer&rsquo;s attention:</b></p><ul class="topics">{topics}</ul>' if topics else ''}
{trend}
</li>""")
    chain_edges = sorted({(a, b, w) for (a, b), w in edges.items() if a in rank_of or b in rank_of},
                         key=lambda e: (rank_of.get(e[0], 99), rank_of.get(e[1], 99)))
    def short(n):
        k, v = n.split(":", 1)
        return f"#{v}" if k == "pr" else (v if k == "job" else "accounts-store migration")
    chain = "".join(f"<li><b>{esc(short(a))}</b> → <b>{esc(short(b))}</b> <span class='why'>{esc(w)}</span></li>"
                    for a, b, w in chain_edges)
    plan_rows = []
    for base, j in plans.items():
        note = q["plan_notes"].get(base)
        gate = "doomed" if j["doomed"] else (j["gate"] or "parked")
        dec = esc(note["decision"]) if note else ("Retries exhausted: re-scope and re-post, or withdraw." if j["doomed"]
                                                 else "Parked behind go-ahead: promote, re-scope, or drop.")
        cmd = f'<pre><code>{esc(note["command"])}</code></pre>' if note and note.get("command") else ""
        plan_rows.append(f"<li><code>{esc(base)}</code> <span class='pill'>{esc(gate)}</span><br>{esc(j['title'])}<br><b>Decision:</b> {dec}{cmd}</li>")
    rest_nodes = [f"pr:{n}" for n in sorted(prs) if f"pr:{n}" not in rank_of]
    rest_order, rest_cycle = topo(rest_nodes, edges, lambda n: int(n[3:]))
    rest = "".join(f"<li>{label(n, prs, q)}<br>{state_cell(n, prs, ci)}</li>" for n in rest_order + rest_cycle)
    cycle_note = f'<p class="warn">Dependency cycle among {esc(", ".join(cycle))}; those rows are omitted until the registry is fixed.</p>' if cycle else ""
    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="color-scheme" content="light dark">
<title>minion.town review queue · {esc(generated[:10])}</title>
<link rel="stylesheet" href="styles.css">
</head>
<body>
<header>
<h1>minion.town review queue</h1>
<p class="lede">What to review, in the order that unblocks the most progress. A snapshot: it does not update. Ask the garden for a fresh one.</p>
<dl class="meta">
<dt>Generated</dt><dd>{esc(generated)}</dd>
<dt><code>main</code></dt><dd><code>{esc(main["sha"][:12])}</code> ({esc(main["date"])})</dd>
<dt>Last main deploy</dt><dd>{esc(deploy)}</dd>
<dt>Open PRs</dt><dd>{len(prs)}</dd>
</dl>
</header>
<main>
<section>
<h2>Ranked queue</h2>
{cycle_note}
<ol class="queue">
{''.join(rows)}
</ol>
</section>
<section>
<h2>The chain</h2>
<p>An arrow means the left item must land first. Stacked branches and parked-job gates are read live; the rest is curated.</p>
<ul class="chain">{chain}</ul>
</section>
<section>
<h2>Parked jobs waiting on you</h2>
<ul class="plans">{''.join(plan_rows)}</ul>
</section>
<section>
<h2>Everything else open</h2>
<details><summary>{len(rest_order) + len(rest_cycle)} PRs with no unblocking pressure today (dependency order)</summary>
<ul class="rest">{rest}</ul>
</details>
</section>
</main>
<footer><p>Built by the garden's review-queue script from GitHub state, CI runs, and the review panel's own records. Review hints are topics only.</p></footer>
</body>
</html>
"""


SCRUB = [
    ("GitHub token", r"gh[pousr]_[A-Za-z0-9]{20,}|github_pat_"),
    ("AWS key or ARN", r"AKIA[0-9A-Z]{12,}|arn:aws:"),
    ("12-digit account id", r"(?<![0-9a-f])\d{12}(?![0-9a-f])"),
    ("garden host name", r"garden-[0-9a-f]{8}|endolin|oros"),
    ("home path", r"/home/|/Users/"),
    ("email address", r"[\w.+-]+@[\w-]+\.[\w.]+"),
    ("IP address", r"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"),
    ("bearer or secret", r"(?i)bearer\s+[a-z0-9]|secret[_-]?(?:key|id)\s*[:=]|password\s*[:=]"),
    ("exploit wording", r"(?i)\bexploit|attack:|proof of concept|\bPoC\b"),
]


def scrub(out_dir):
    hits = []
    for name in sorted(os.listdir(out_dir)):
        with open(os.path.join(out_dir, name), encoding="utf-8") as f:
            text = f.read()
        for what, pat in SCRUB:
            for m in re.finditer(pat, text):
                hits.append(f"{name}: {what}: {m.group(0)!r}")
    return hits


def main():
    args = sys.argv[1:]
    if not args:
        sys.exit(__doc__)
    out_dir = args[0]
    journal = args[args.index("--journal") + 1] if "--journal" in args else os.path.join(
        os.environ.get("GARDEN_ROOT", os.path.expanduser("~")), "journal")
    with open(os.path.join(HERE, "queue.json"), encoding="utf-8") as f:
        q = json.load(f)
    prs = open_prs()
    ci = {n: ci_state(p["headRefOid"]) for n, p in prs.items()}
    c = gh(f"repos/{REPO}/commits/main")
    main_c = {"sha": c["sha"], "date": c["commit"]["committer"]["date"]}
    runs = gh(f"repos/{REPO}/actions/workflows/deploy.yml/runs?branch=main&per_page=1")["workflow_runs"]
    deploy = f'{runs[0]["conclusion"] or runs[0]["status"]} at {runs[0]["head_sha"][:12]} ({runs[0]["created_at"]})' if runs else "unknown"
    plans = plan_jobs(journal)
    trends = {n: t for n in prs if (t := panel_trend(journal, n))}
    edges, soft = edges_for(prs, plans, q)
    generated = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    os.makedirs(out_dir, exist_ok=True)
    with open(os.path.join(out_dir, "index.html"), "w", encoding="utf-8") as f:
        f.write(render(q, prs, ci, plans, edges, soft, main_c, deploy, trends, generated))
    shutil.copy(os.path.join(HERE, "styles.css"), os.path.join(out_dir, "styles.css"))
    hits = scrub(out_dir)
    if hits:
        print("privacy scrub FAILED:\n  " + "\n  ".join(hits), file=sys.stderr)
        sys.exit(3)
    print(json.dumps({"out": out_dir, "generated": generated, "main": main_c["sha"], "open_prs": len(prs),
                      "ranked": [r["id"] for r in q["ranked"]], "scrub": [w for w, _ in SCRUB]}))


if __name__ == "__main__":
    main()
