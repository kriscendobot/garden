#!/usr/bin/env python3
"""Render the compact journal progress entry for the Claude arc press."""

import json
import sys


def main():
    if len(sys.argv) != 2:
        raise SystemExit(f"usage: {sys.argv[0]} REPORT.json")
    with open(sys.argv[1], encoding="utf-8") as source:
        report = json.load(source)

    counts = report["counts"]
    locations = counts["locations"]
    outstanding = sum(
        locations.get(name, 0)
        for name in ("todo", "doin", "plan", "orch", "gauntlet", "absent")
    )
    failed = sorted(
        item["base"]
        for item in report["completions"]
        if item.get("orchestration_failed")
    )

    print("Claude-on-minion.town arc progress")
    print(f"window: {report['window']['since']} -> {report['window']['until']}")
    print(
        "counts: "
        f"{counts['roster']} roster; {counts['completions']} completed in-window; "
        f"{outstanding} outstanding; {counts['claims']} claimed in-window; "
        f"{counts['new_dooms']} new dooms"
    )

    print("non-tada roster:")
    active = [item for item in report["jobs"] if item["location"] != "tada"]
    if not active:
        print("- none")
    for item in sorted(active, key=lambda value: value["base"]):
        suffix = ""
        if "doom" in item:
            doom = item["doom"]
            suffix = f"; doom={doom['signature']} host={doom.get('host') or 'unknown'}"
        print(f"- {item['base']}: {item['location']}{suffix}")

    print("in-window completions:")
    if not report["completions"]:
        print("- none")
    for item in sorted(report["completions"], key=lambda value: value["base"]):
        suffix = "; orchestration_failed=true" if item.get("orchestration_failed") else ""
        print(f"- {item['base']}{suffix}")

    print("exceptions:")
    exceptions = []
    for item in sorted(report["doom_delta"], key=lambda value: value["base"]):
        exceptions.append(
            f"new doom {item['base']}: {item['signature']} "
            f"on {item.get('host') or 'unknown'}"
        )
    for item in sorted(report["stalled_claims"], key=lambda value: value["base"]):
        exceptions.append(
            f"stalled claim {item['base']}: overdue {item['overdue_s']}s "
            f"on {item.get('host') or 'unknown'}; requeues={item['requeue_cycles']}"
        )
    for base in sorted(report["absent_prior_roster"]):
        exceptions.append(f"absent prior-roster job {base}")
    for base in failed:
        exceptions.append(f"failed orchestration completion {base}")
    if not exceptions:
        print("- none (nominal)")
    else:
        for exception in exceptions:
            print(f"- {exception}; agent interpretation required")


if __name__ == "__main__":
    main()
