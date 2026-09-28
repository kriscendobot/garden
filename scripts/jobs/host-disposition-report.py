#!/usr/bin/env python3
"""Per-host job disposition report, read from journal2 commit subjects.

Usage:
  host-disposition-report.py [--repo DIR] [--ref REF] [--windows 24h,7d] [--now EPOCH]

Reads `git log <ref>` in a journal clone (default: the producer clone,
${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}, ref origin/journal2)
and prints a markdown report to stdout. Read-only: it never fetches, commits,
or pushes; fetch the clone first if you want a fresh view.

The commit-subject shapes are the source of truth:
  claim(<base>) <host>/<kind>-<id>
  tada(<base>) done <host>/<kind>-<id>
  terminal-failure: hint jobs/doin/<base>.md by <host> (...)
  reap-now: hint jobs/doin/<base>.md by <host> (transient handler kill)

Headline columns are raw event counts per host in the window. In-flight is the
current jobs/doin/ set at <ref>, keyed by each file's `claim.host`. The
per-kind table follows each claim in the window to its next disposition event
for the same base (before any re-claim), so a kind's completion rate is a
per-claim follow-through rate rather than an event ratio.
"""

import argparse
import collections
import os
import re
import subprocess
import sys
import time

CLAIM = re.compile(r"^claim\((?P<base>[^)]+)\) (?P<host>[^/\s]+)/(?P<kind>[a-z]+)-\d+$")
TADA = re.compile(r"^tada\((?P<base>[^)]+)\) done (?P<host>[^/\s]+)/")
TERM = re.compile(r"^terminal-failure: hint jobs/doin/(?P<base>.+)\.md by (?P<host>\S+)")
REAP = re.compile(r"^reap-now: hint jobs/doin/(?P<base>.+)\.md by (?P<host>\S+) \(transient handler kill\)")

UNITS = {"h": 3600, "d": 86400}


def parse_window(w):
    m = re.fullmatch(r"(\d+)([hd])", w)
    if not m:
        sys.exit(f"bad window {w!r}; use e.g. 6h, 24h, 7d")
    return w, int(m.group(1)) * UNITS[m.group(2)]


def git(repo, *args):
    return subprocess.run(["git", "-C", repo, *args], check=True,
                          capture_output=True, text=True).stdout


def load_events(repo, ref, since):
    out = git(repo, "log", ref, f"--since=@{since}", "--format=%ct%x09%s")
    events = []
    for line in out.splitlines():
        ts, _, subj = line.partition("\t")
        for kind, rx in (("claim", CLAIM), ("tada", TADA),
                         ("term", TERM), ("reap", REAP)):
            m = rx.match(subj)
            if m:
                events.append((int(ts), kind, m.groupdict()))
                break
    events.sort(key=lambda e: e[0])
    return events


def load_inflight(repo, ref):
    """Map host -> set of bases currently in jobs/doin/ claimed by that host."""
    inflight = collections.defaultdict(set)
    try:
        names = git(repo, "ls-tree", "--name-only", f"{ref}:jobs/doin").split()
    except subprocess.CalledProcessError:
        return inflight
    for name in names:
        if not name.endswith(".md"):
            continue
        body = git(repo, "show", f"{ref}:jobs/doin/{name}")
        m = re.search(r"^claim:\n(?:  .*\n)*?  host: (\S+)", body, re.M)
        if m:
            inflight[m.group(1)].add(name[:-3])
    return inflight


def pct(n, d):
    return f"{100.0 * n / d:.0f}%" if d else "n/a"


def summarize(events, start, inflight):
    per = collections.defaultdict(lambda: collections.Counter())
    kinds = collections.defaultdict(collections.Counter)
    for ts, kind, g in events:
        if ts < start:
            continue
        per[g["host"]][kind] += 1
        if kind == "claim":
            kinds[g["host"]][g["kind"]] += 1

    # Per-claim follow-through: the first disposition event for the same base
    # after the claim and before that base's next claim.
    follow = collections.defaultdict(collections.Counter)
    by_base = collections.defaultdict(list)
    for e in events:
        by_base[e[2]["base"]].append(e)
    for base, evs in by_base.items():
        for i, (ts, kind, g) in enumerate(evs):
            if kind != "claim" or ts < start:
                continue
            outcome = None
            for ts2, kind2, g2 in evs[i + 1:]:
                if kind2 == "claim":
                    outcome = "requeued"
                    break
                if kind2 in ("tada", "term", "reap"):
                    outcome = kind2
                    break
            if outcome is None:
                outcome = "inflight" if base in inflight.get(g["host"], ()) else "other"
            follow[(g["host"], g["kind"])][outcome] += 1
    return per, kinds, follow


def render(repo, ref, windows, now):
    longest = max(s for _, s in windows)
    events = load_events(repo, ref, now - longest)
    inflight = load_inflight(repo, ref)
    head = git(repo, "rev-parse", "--short=12", ref).strip()
    stamp = time.strftime("%Y-%m-%dT%H:%MZ", time.gmtime(now))
    out = [f"_Generated {stamp} from `{ref}` @ `{head}` by "
           "`scripts/jobs/host-disposition-report.py`._", ""]
    fleet = {}
    for label, secs in windows:
        per, kinds, follow = summarize(events, now - secs, inflight)
        hosts = sorted(set(per) | set(inflight))
        out += [f"## Last {label}", "",
                "| host | claims (by kind) | completions | terminal failures "
                "| transient kills | in-flight | completion rate |",
                "| --- | --- | --- | --- | --- | --- | --- |"]
        tot = collections.Counter()
        for h in hosts:
            c = per[h]
            kb = ", ".join(f"{k} {n}" for k, n in sorted(kinds[h].items()))
            out.append(f"| {h} | {c['claim']}{f' ({kb})' if kb else ''} | {c['tada']} "
                       f"| {c['term']} | {c['reap']} | {len(inflight.get(h, ()))} "
                       f"| **{pct(c['tada'], c['claim'])}** |")
            tot.update(c)
        out.append(f"| **fleet** | {tot['claim']} | {tot['tada']} | {tot['term']} "
                   f"| {tot['reap']} | {sum(len(v) for v in inflight.values())} "
                   f"| **{pct(tot['tada'], tot['claim'])}** |")
        out += ["", f"Per-claim follow-through, last {label} (each claim's next "
                "disposition for the same base; *requeued* = re-claimed with no "
                "tada/failure/kill in between, *other* = gone from the board "
                "without one of those events):", "",
                "| host / kind | claims | done | terminal | transient | requeued "
                "| other | in-flight | follow-through |",
                "| --- | --- | --- | --- | --- | --- | --- | --- | --- |"]
        for (h, k), f in sorted(follow.items()):
            n = sum(f.values())
            out.append(f"| {h} / {k} | {n} | {f['tada']} | {f['term']} | {f['reap']} "
                       f"| {f['requeued']} | {f['other']} | {f['inflight']} "
                       f"| {pct(f['tada'], n)} |")
        out.append("")
        fleet[label] = (per, tot)
    return "\n".join(out), fleet


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    state = os.environ.get("GARDEN_STATE",
                           os.path.join(os.environ.get("HOME", ""), ".garden-state"))
    ap.add_argument("--repo", default=os.environ.get(
        "GARDEN_PRODUCER_CLONE", os.path.join(state, "producer", "journal")))
    ap.add_argument("--ref", default="origin/journal2")
    ap.add_argument("--windows", default="24h,7d")
    ap.add_argument("--now", type=int, default=int(time.time()))
    a = ap.parse_args()
    windows = [parse_window(w) for w in a.windows.split(",")]
    text, _ = render(a.repo, a.ref, windows, a.now)
    print(text)


if __name__ == "__main__":
    main()
