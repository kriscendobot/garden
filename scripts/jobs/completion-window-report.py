#!/usr/bin/env python3
"""Report completions, or deterministically reconcile an arc roster.

Without selectors this preserves the original completion-list report. With any
``--select-*`` option, JSON becomes a single arc report containing current board
locations, claim/completion deltas, doom signatures, stalled claims, and members
of the prior-window roster now absent without a completion.
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
BOARD_PATH = re.compile(
    r"^jobs/(?:(todo|doin|plan|orch|gauntlet)/([^/]+)|tada/(?:.*/)?([^/]+))\.md$")
FIELD = re.compile(r"^([A-Za-z0-9_-]+):\s*(.*?)\s*$", re.M)
LONG_ROLES = {"builder", "web-builder", "fixer", "shepherd", "conductor",
              "review", "panel", "botanist"}


def git(repo, *args):
    return subprocess.run(["git", "-C", repo, *args], check=True,
                          capture_output=True, text=True).stdout


def default_repo():
    state = os.environ.get("GARDEN_STATE") or os.path.join(
        os.environ.get("GARDEN_ROOT", os.path.expanduser("~")), ".garden-state")
    return os.environ.get("GARDEN_PRODUCER_CLONE") or os.path.join(state, "producer", "journal")


def iso_epoch(value):
    return int(datetime.datetime.fromisoformat(value.replace("Z", "+00:00")).timestamp())


def utc(stamp):
    return datetime.datetime.fromtimestamp(stamp, datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def field(body, name):
    for key, value in FIELD.findall(body):
        if key == name:
            return value.strip("\"'")
    return ""


def parse_board_path(path):
    match = BOARD_PATH.match(path)
    if not match:
        return None
    return match.group(1) or "tada", match.group(2) or match.group(3)


def cat_objects(repo, requests):
    """Read [(key, object-ish)] in one cat-file process."""
    if not requests:
        return {}
    raw = subprocess.run(
        ["git", "-C", repo, "cat-file", "--batch"], check=True,
        input="".join(f"{obj}\n" for _, obj in requests).encode(),
        capture_output=True).stdout
    result, pos = {}, 0
    for key, _obj in requests:
        nl = raw.index(b"\n", pos)
        header = raw[pos:nl].decode().split()
        pos = nl + 1
        if len(header) < 3 or header[1] == "missing":
            result[key] = ""
            continue
        size = int(header[2])
        result[key] = raw[pos:pos + size].decode("utf-8", "replace")
        pos += size + 1
    return result


def tree_jobs(repo, ref):
    if not ref:
        return {}
    requests = []
    for path in git(repo, "ls-tree", "-r", "--name-only", ref, "--", "jobs").splitlines():
        if parse_board_path(path):
            requests.append((path, f"{ref}:{path}"))
    bodies = cat_objects(repo, requests)
    jobs = {}
    for path, body in bodies.items():
        location, base = parse_board_path(path)
        record = {"base": base, "location": location, "path": path, "body": body}
        if base not in jobs or location != "tada":
            jobs[base] = record
    return jobs


def history_events(repo, ref, since, until):
    out = git(repo, "log", ref, f"--since=@{since}", f"--until=@{until}",
              "--format=C%x09%H%x09%ct", "--name-status", "--", "jobs")
    events, sha, stamp = [], None, None
    for line in out.splitlines():
        if line.startswith("C\t"):
            _, sha, stamp = line.split("\t")
            stamp = int(stamp)
            continue
        cols = line.split("\t")
        if not sha or len(cols) < 2:
            continue
        status, target = cols[0], cols[-1]
        parsed = parse_board_path(target)
        if not parsed:
            continue
        location, base = parsed
        kind = None
        if (status.startswith("A") or status.startswith("R")) and location == "doin":
            kind = "claim"
        elif (status.startswith("A") or status.startswith("R")) and location == "tada":
            kind = "completion"
        elif (status.startswith("A") or status.startswith("R")) and location == "plan":
            kind = "plan"
        if kind:
            events.append({"kind": kind, "base": base, "sha": sha, "ts": stamp,
                           "path": target})
    requests = [((event["sha"], event["path"]), f'{event["sha"]}:{event["path"]}')
                for event in events]
    bodies = cat_objects(repo, requests)
    for event in events:
        event["body"] = bodies.get((event["sha"], event["path"]), "")
    events.sort(key=lambda item: (item["ts"], item["sha"], item["path"]))
    return events


def fixed_match(base, body, args):
    return (base in args.select_base or
            any(base.startswith(prefix) for prefix in args.select_prefix) or
            field(body, "arc") in args.select_arc or
            any(text in body for text in args.select_text))


def select_roster(documents, args, expansion_bodies=()):
    """Select fixed matches and close over explicit job/parent references."""
    by_base = {}
    for base, body in documents:
        by_base.setdefault(base, []).append(body)
    selected = {base for base, bodies in by_base.items()
                if any(fixed_match(base, body, args) for body in bodies)}
    selected.update(base for base in args.select_orchestration if base in by_base)
    for base, bodies in by_base.items():
        if any(field(body, "orchestrated_by") in args.select_orchestration or
               field(body, "gauntlet") in args.select_orchestration for body in bodies):
            selected.add(base)

    if args.expand_job_references:
        frontier = list(expansion_bodies)
        changed = True
        while changed:
            changed = False
            selected_text = "\n".join(frontier)
            frontier = []
            named = set(re.findall(r"(?<![A-Za-z0-9_.-])([A-Za-z0-9][A-Za-z0-9_.-]+)",
                                   selected_text)) & set(by_base)
            for base, bodies in by_base.items():
                if base in selected:
                    continue
                parent = any(field(body, "gauntlet") in selected or
                             field(body, "orchestrated_by") in selected for body in bodies)
                if base in named or parent:
                    selected.add(base)
                    frontier.extend(bodies)
                    changed = True
    return selected


TITLE_ONLY = re.compile(r"^(?:\*\*)?(?:[\w -]*\breport\b.*|.*:)(?:\*\*)?$", re.I)


def headline(body, limit):
    body = re.sub(r"^---\n.*?\n---\n", "", body, count=1, flags=re.S)
    body = body.split("<!-- garden-usage-begin", 1)[0]
    text = ""
    for para in re.split(r"\n\s*\n", body):
        para = re.sub(r"^#+\s*", "", " ".join(para.split()))
        if not para or para.startswith("<!--"):
            continue
        text = f"{text} {para}".strip()
        if not (len(para) < 100 and TITLE_ONLY.match(para)):
            break
    return text if len(text) <= limit else text[:limit - 1] + "…"


def parse_cost(body):
    result = {}
    match = COST["cost"].search(body)
    if match:
        result["usd"] = float(match.group(1))
    match = COST["input"].search(body)
    if match:
        result["input"], result["cached"] = int(match.group(1)), int(match.group(2) or 0)
    match = COST["output"].search(body)
    if match:
        result["output"] = int(match.group(1))
    match = COST["wall"].search(body)
    if match:
        result["wall_s"] = int(match.group(1))
    return result


def totals(entries):
    result = {"n": len(entries), "bases": len({item["base"] for item in entries}),
              "costed": 0, "usd": 0.0, "input": 0, "cached": 0,
              "output": 0, "wall_s": 0}
    for entry in entries:
        values = entry["cost"]
        result["costed"] += int("usd" in values)
        for key in ("usd", "input", "cached", "output", "wall_s"):
            result[key] += values.get(key, 0)
    return result


def handler_budget(body):
    explicit = field(body, "handler-timeout")
    if explicit.isdigit() and int(explicit) > 0:
        return int(explicit)
    role = field(body, "handler-budget-role") or field(body, "role")
    stage = field(body, "gauntlet_stage")
    if not field(body, "handler-budget-role"):
        role = {"panel": "panel", "clean": "shepherd", "fix": "shepherd"}.get(stage, role)
    return 7200 if role in LONG_ROLES else 2400


def event_json(event):
    item = {key: event[key] for key in ("base", "sha", "path")}
    item["at"] = utc(event["ts"])
    if event["kind"] == "completion":
        item["orchestration_failed"] = field(event["body"], "orchestration-failed") == "true"
    return item


def schedule_window(repo, ref, name):
    path = f"schedules/{name}.md"
    stamps = []
    for commit in git(repo, "log", "--format=%H", ref, "--", path).splitlines():
        try:
            stamp = field(git(repo, "show", f"{commit}:{path}"), "last_dispatched")
        except subprocess.CalledProcessError as error:
            # 128: the path is absent at a deletion commit.  Anything else (the
            # fleet wrapper's 124 timeout) must fail loudly: skipping it would
            # silently slide the window back to older dispatch stamps.
            if error.returncode != 128:
                raise
            continue
        if stamp and stamp not in stamps:
            stamps.append(stamp)
        if len(stamps) == 2:
            break
    if len(stamps) < 2:
        raise ValueError(f"schedule {name!r} has fewer than two dispatch stamps")
    return iso_epoch(stamps[1]), iso_epoch(stamps[0])


def arc_report(repo, ref, since, until, args):
    current = tree_jobs(repo, ref)
    prior_ref = git(repo, "rev-list", "-1", f"--before=@{since}", ref).strip()
    prior = tree_jobs(repo, prior_ref)
    events = history_events(repo, ref, since, until)
    documents = ([(base, record["body"]) for base, record in current.items()] +
                 [(base, record["body"]) for base, record in prior.items()] +
                 [(event["base"], event["body"]) for event in events])
    # Reference expansion starts from this window plus live fixed matches.  It
    # deliberately does not start from every historical press report: doing so
    # turns explicit mentions like "out of scope" into an ever-growing roster.
    # The latest prior completion press bridges work already open at the boundary.
    expansion_bodies = [event["body"] for event in events
                        if fixed_match(event["base"], event["body"], args)]
    expansion_bodies += [record["body"] for record in current.values()
                         if record["location"] != "tada" and
                         fixed_match(record["base"], record["body"], args)]
    expansion_bodies += [record["body"] for record in prior.values()
                         if record["location"] != "tada" and
                         fixed_match(record["base"], record["body"], args)]
    previous_presses = [record for base, record in prior.items()
                        if base.startswith("claude-on-minion-town-completion-press-")]
    if previous_presses:
        expansion_bodies.append(max(previous_presses, key=lambda item: item["base"])["body"])
    roster = select_roster(documents, args, expansion_bodies)

    jobs = []
    for base in sorted(roster):
        record = current.get(base)
        item = {"base": base, "location": record["location"] if record else "absent",
                "path": record["path"] if record else None}
        if record and record["location"] == "plan" and field(record["body"], "doomed") == "true":
            item["doom"] = {"signature": field(record["body"], "doom_signature") or "unknown",
                            "host": field(record["body"], "doomed_on") or None,
                            "at": field(record["body"], "doomed_at") or None}
        jobs.append(item)

    claims = [event_json(event) for event in events
              if event["kind"] == "claim" and event["base"] in roster]
    completions = [event_json(event) for event in events
                   if event["kind"] == "completion" and event["base"] in roster]
    completion_bases = {event["base"] for event in events if event["kind"] == "completion"}
    absent = sorted(base for base, record in prior.items()
                    if record["location"] != "orch" and base in roster and base not in current
                    and base not in completion_bases)
    dooms = [dict(base=item["base"], **item["doom"]) for item in jobs if "doom" in item]
    doom_delta = []
    for event in events:
        if (event["kind"] == "plan" and event["base"] in roster and
                field(event["body"], "doomed") == "true"):
            doom_delta.append({"base": event["base"],
                               "signature": field(event["body"], "doom_signature") or "unknown",
                               "host": field(event["body"], "doomed_on") or None,
                               "at": field(event["body"], "doomed_at") or utc(event["ts"])})

    stalled = []
    for base in sorted(roster):
        record = current.get(base)
        if not record or record["location"] != "doin":
            continue
        try:
            work = git(repo, "show", f"{ref}:work/{base}")
        except subprocess.CalledProcessError:
            work = ""
        claimed = field(work, "claimed_at") or field(record["body"], "claimed_at")
        if not claimed:
            continue
        claimed_epoch = iso_epoch(claimed)
        budget, age = handler_budget(record["body"]), max(0, until - claimed_epoch)
        if age > budget:
            stalled.append({"base": base, "claimed_at": utc(claimed_epoch),
                            "age_s": age, "handler_timeout_s": budget,
                            "overdue_s": age - budget, "host": field(work, "host") or None,
                            "requeue_cycles": int(field(record["body"], "requeue_cycles") or 0)})

    location_counts = {name: sum(item["location"] == name for item in jobs)
                       for name in ("todo", "doin", "plan", "orch", "gauntlet",
                                    "tada", "absent")}
    return {
        "schema": 1,
        "window": {"since": utc(since), "until": utc(until),
                   "prior_ref": prior_ref or None, "current_ref": ref},
        "selectors": {"bases": args.select_base, "prefixes": args.select_prefix,
                      "arcs": args.select_arc, "orchestrations": args.select_orchestration,
                      "text": args.select_text,
                      "expand_job_references": args.expand_job_references},
        "counts": {"roster": len(roster), "locations": location_counts,
                   "claims": len(claims), "completions": len(completions),
                   "current_dooms": len(dooms), "new_dooms": len(doom_delta),
                   "stalled_claims": len(stalled), "absent_prior_roster": len(absent)},
        "jobs": jobs, "claims": claims, "completions": completions,
        "dooms": dooms, "doom_delta": doom_delta,
        "stalled_claims": stalled, "absent_prior_roster": absent,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--since", help="ISO-8601 window start")
    parser.add_argument("--until", help="ISO-8601 window end (default: now)")
    parser.add_argument("--schedule", metavar="NAME",
                        help="derive since/until from the two latest distinct dispatch stamps")
    parser.add_argument("--repo", default=default_repo())
    parser.add_argument("--ref", default="origin/journal2")
    parser.add_argument("--format", choices=("md", "tsv", "json"), default="md")
    parser.add_argument("--summary-chars", type=int, default=400)
    parser.add_argument("--link-base", default="https://github.com/kriscendobot/garden/blob/journal2/")
    parser.add_argument("--select-base", action="append", default=[], metavar="BASE")
    parser.add_argument("--select-prefix", action="append", default=[], metavar="PREFIX")
    parser.add_argument("--select-arc", action="append", default=[], metavar="ARC")
    parser.add_argument("--select-orchestration", action="append", default=[], metavar="BASE")
    parser.add_argument("--select-text", action="append", default=[], metavar="LITERAL")
    parser.add_argument("--expand-job-references", action="store_true")
    args = parser.parse_args()
    if args.schedule and (args.since or args.until):
        parser.error("--schedule cannot be combined with --since/--until")
    if args.schedule:
        try:
            since, until = schedule_window(args.repo, args.ref, args.schedule)
        except ValueError as error:
            parser.error(str(error))
    else:
        if not args.since:
            parser.error("one of --since or --schedule is required")
        since = iso_epoch(args.since)
        until = iso_epoch(args.until) if args.until else int(datetime.datetime.now().timestamp())
    selected = any((args.select_base, args.select_prefix, args.select_arc,
                    args.select_orchestration, args.select_text))
    if selected:
        if args.format != "json":
            parser.error("arc selectors require --format json")
        print(json.dumps(arc_report(args.repo, args.ref, since, until, args),
                         sort_keys=True, indent=2))
        return 0

    entries = []
    for event in history_events(args.repo, args.ref, since, until):
        if event["kind"] != "completion":
            continue
        body = event["body"]
        entries.append({"sha": event["sha"], "ts": event["ts"], "path": event["path"],
                        "base": event["base"], "summary": headline(body, args.summary_chars),
                        "cost": parse_cost(body)})
    summary = totals(entries)
    if args.format == "json":
        for entry in entries:
            print(json.dumps(entry))
        return 0
    if args.format == "tsv":
        for entry in entries:
            print("\t".join([utc(entry["ts"]), entry["sha"][:10], entry["base"],
                             entry["path"], f'{entry["cost"].get("usd", 0):.2f}',
                             entry["summary"]]))
    else:
        print(f"# Completions {utc(since)} → {utc(until)}\n")
        print("| Landed (UTC) | Job | Result |\n| --- | --- | --- |")
        for entry in entries:
            text = entry["summary"].replace("|", "\\|")
            print(f'| {utc(entry["ts"])} | [`{entry["base"]}`]({args.link_base}{entry["path"]}) | {text} |')
        print()
    prefix = "# " if args.format == "tsv" else ""
    print(f"{prefix}Totals: {summary['n']} completions ({summary['bases']} distinct bases); "
          f"cost-stamped {summary['costed']}: ${summary['usd']:.2f}, "
          f"{summary['input']} input + {summary['cached']} cached-read + "
          f"{summary['output']} output tokens, {summary['wall_s'] / 3600:.1f}h wall-clock")
    return 0


if __name__ == "__main__":
    sys.exit(main())
