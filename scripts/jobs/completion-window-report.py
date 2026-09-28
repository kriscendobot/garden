#!/usr/bin/env python3
"""Enumerate completed jobs (jobs/tada/ additions) landed in a time window.

Usage:
  completion-window-report.py --since ISO [--until ISO] [--repo DIR] [--ref REF]
                              [--format md|tsv|json] [--summary-chars N]

Reads `git log <ref>` in a journal clone (default: the producer clone,
${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}, ref origin/journal2).
Read-only: it never fetches, commits, or pushes; fetch the clone first if you
want a fresh view.

Ground truth is the commit that ADDED each `jobs/tada/**/<base>.md` file, so a
date-shard folder's boundary day is filtered by landing time, not folder name.
For each entry it prints the landing time, commit sha, base, tada path, the
report's first paragraph (every completion report leads with a plain-prose
headline), and the machine-stamped `## Cost` figures when present. The md and
tsv formats end with totals; json is one object per entry, for further
grouping by hand or by another tool.
"""

import argparse
import datetime
import json
import os
import re
import subprocess
import sys

COST = {
    "cost": re.compile(r"^- Cost: \$([0-9.]+)", re.M),
    "input": re.compile(r"^- Input: (\d+) tokens(?: \((\d+) cached reads\))?", re.M),
    "output": re.compile(r"^- Output: (\d+) tokens", re.M),
    "wall": re.compile(r"^- Wall-clock: (\d+)s", re.M),
}


def git(repo, *args, stdin=None):
    return subprocess.run(["git", "-C", repo, *args], check=True, input=stdin,
                          capture_output=True, text=True).stdout


def default_repo():
    state = os.environ.get("GARDEN_STATE") or os.path.join(
        os.environ.get("GARDEN_ROOT", os.path.expanduser("~")), ".garden-state")
    return os.environ.get("GARDEN_PRODUCER_CLONE") or os.path.join(state, "producer", "journal")


def iso_epoch(s):
    return int(datetime.datetime.fromisoformat(s.replace("Z", "+00:00")).timestamp())


def load_additions(repo, ref, since, until):
    out = git(repo, "log", ref, f"--since=@{since}", f"--until=@{until}",
              "--diff-filter=A", "--name-only", "--format=C%x09%H%x09%ct", "--",
              "jobs/tada/")
    entries, sha, ts = [], None, None
    for line in out.splitlines():
        if line.startswith("C\t"):
            _, sha, ts = line.split("\t")
        elif line.startswith("jobs/tada/") and line.endswith(".md"):
            entries.append({"sha": sha, "ts": int(ts), "path": line,
                            "base": os.path.basename(line)[:-3]})
    entries.sort(key=lambda e: e["ts"])
    return entries


TITLE_ONLY = re.compile(r"^(?:\*\*)?(?:[\w -]*\breport\b.*|.*:)(?:\*\*)?$", re.I)


def headline(body, limit):
    """First prose paragraph; a bare title line ("Completion report: X",
    "Final report:") is joined to the paragraph after it."""
    body = re.sub(r"^---\n.*?\n---\n", "", body, count=1, flags=re.S)
    body = body.split("<!-- garden-usage-begin", 1)[0]
    text = ""
    for para in re.split(r"\n\s*\n", body):
        para = " ".join(para.split())
        para = re.sub(r"^#+\s*", "", para)
        if not para or para.startswith("<!--"):
            continue
        text = f"{text} {para}".strip()
        if not (len(para) < 100 and TITLE_ONLY.match(para)):
            break
    return text if len(text) <= limit else text[:limit - 1] + "…"


def cost(body):
    c = {}
    m = COST["cost"].search(body)
    if m:
        c["usd"] = float(m.group(1))
    m = COST["input"].search(body)
    if m:
        c["input"] = int(m.group(1))
        c["cached"] = int(m.group(2) or 0)
    m = COST["output"].search(body)
    if m:
        c["output"] = int(m.group(1))
    m = COST["wall"].search(body)
    if m:
        c["wall_s"] = int(m.group(1))
    return c


def fill(repo, entries, limit):
    if not entries:
        return
    req = "".join(f"{e['sha']}:{e['path']}\n" for e in entries)
    raw = subprocess.run(["git", "-C", repo, "cat-file", "--batch"], check=True,
                         input=req.encode(), capture_output=True).stdout
    pos = 0
    for e in entries:
        nl = raw.index(b"\n", pos)
        hdr = raw[pos:nl].decode().split()
        pos = nl + 1
        if len(hdr) < 3 or hdr[1] == "missing":
            e["summary"], e["cost"] = "", {}
            continue
        size = int(hdr[2])
        body = raw[pos:pos + size].decode("utf-8", "replace")
        pos += size + 1
        e["summary"], e["cost"] = headline(body, limit), cost(body)


def totals(entries):
    t = {"n": len(entries), "bases": len({e["base"] for e in entries}),
         "costed": 0, "usd": 0.0, "input": 0, "cached": 0, "output": 0, "wall_s": 0}
    for e in entries:
        c = e["cost"]
        if "usd" in c:
            t["costed"] += 1
        for k in ("usd", "input", "cached", "output", "wall_s"):
            t[k] += c.get(k, 0)
    return t


def utc(ts):
    return datetime.datetime.fromtimestamp(ts, datetime.timezone.utc).strftime("%Y-%m-%dT%H:%MZ")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--since", required=True, help="ISO-8601 start, e.g. 2026-09-26T03:00:00Z")
    ap.add_argument("--until", help="ISO-8601 end (default: now)")
    ap.add_argument("--repo", default=default_repo())
    ap.add_argument("--ref", default="origin/journal2")
    ap.add_argument("--format", choices=("md", "tsv", "json"), default="md")
    ap.add_argument("--summary-chars", type=int, default=400)
    ap.add_argument("--link-base", default="https://github.com/kriscendobot/garden/blob/journal2/",
                    help="prefix for md links to tada paths ('' for repo-relative)")
    a = ap.parse_args()
    since = iso_epoch(a.since)
    until = iso_epoch(a.until) if a.until else int(datetime.datetime.now().timestamp())
    entries = load_additions(a.repo, a.ref, since, until)
    fill(a.repo, entries, a.summary_chars)
    t = totals(entries)
    if a.format == "json":
        for e in entries:
            print(json.dumps(e))
        return
    if a.format == "tsv":
        for e in entries:
            print("\t".join([utc(e["ts"]), e["sha"][:10], e["base"], e["path"],
                             f"{e['cost'].get('usd', 0):.2f}", e["summary"]]))
    else:
        print(f"# Completions {utc(since)} → {utc(until)}\n")
        print("| Landed (UTC) | Job | Result |\n| --- | --- | --- |")
        for e in entries:
            s = e["summary"].replace("|", "\\|")
            print(f"| {utc(e['ts'])} | [`{e['base']}`]({a.link_base}{e['path']}) | {s} |")
        print()
    print(f"{'# ' if a.format == 'tsv' else ''}Totals: {t['n']} completions "
          f"({t['bases']} distinct bases); cost-stamped {t['costed']}: "
          f"${t['usd']:.2f}, {t['input']} input + {t['cached']} cached-read + "
          f"{t['output']} output tokens, {t['wall_s'] / 3600:.1f}h wall-clock")


if __name__ == "__main__":
    sys.exit(main())
