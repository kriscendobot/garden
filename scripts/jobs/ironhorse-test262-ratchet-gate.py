#!/usr/bin/env python3
"""ironhorse-test262-ratchet-gate.py: pinned-baseline comparator for the Ironhorse
test262 coverage ratchet (endojs/endo-but-for-bots, rust/engine/ironhorse-262).

Invoke through the ironhorse-test262-ratchet-gate.sh wrapper. Two subcommands:

  pin    Freeze a floor. Reads a complete whole-corpus measurement (a full-run
         report.json, or an in-tree baseline/refresh-<date>/ directory holding
         baseline.json + covered.txt) and writes <out>/pin.json plus a
         byte-sorted <out>/covered.txt. The pin records every property a later
         measurement must share to be comparable: corpus and oracle pins, run
         parameters, category vocabulary, case count, and a classifier
         fingerprint (git blob ids of the runner's verdict sources at the
         measured endo commit). --supersedes <old-pin> records, for a deliberate
         floor reconciliation, every old covered path the new floor drops, with
         its new disposition.

  check  Compare a measurement against a pin and print one JSON gate record.
         verdict  exit  meaning
         pass     0     comparable, zero pinned covered paths lost (and, with
                        --require-growth, at least one path gained)
         fail     1     comparable, but a pinned path was lost or nothing grew
         incompatible 2 not comparable to the pin (classifier, corpus, oracle,
                        run parameters, vocabulary, or case count differ). The
                        path diff is attached as `informational_diff` only.
         error    3     an input could not be read or is internally inconsistent

The gate fails closed: anything it cannot read or verify is `error` or
`incompatible`, never `pass`. It never touches the network and never writes
outside --out/--record.
"""

import argparse
import hashlib
import json
import os
import subprocess
import sys

PIN_SCHEMA = "ironhorse-test262-ratchet-pin/1"
GATE_SCHEMA = "ironhorse-test262-ratchet-gate/1"
REPORT_SCHEMAS = {"ironhorse-test262-report/1"}
DEFAULT_CLASSIFIER_PATHS = [
    "rust/engine/ironhorse-262/scripts/full-run.sh",
    "rust/engine/ironhorse-262/src/bin/endot_ih.rs",
    "rust/engine/ironhorse-262/src/report.rs",
    "rust/engine/ironhorse-262/src/xst.rs",
]
# Run parameters that may differ between comparable measurements: `endo` is the
# engine under test, the thing the ratchet exists to vary.
RUN_ID_FREE_KEYS = {"endo"}
COMPAT_PROVENANCE_KEYS = ["runner", "test262_sha", "oracle_mode", "ses_mode", "scope"]

EXIT = {"pass": 0, "fail": 1, "incompatible": 2, "error": 3}


class GateError(Exception):
    pass


def sort_paths(paths):
    return sorted(paths, key=lambda s: s.encode("utf-8"))


def sha256_lines(paths):
    h = hashlib.sha256()
    for p in paths:
        h.update(p.encode("utf-8") + b"\n")
    return h.hexdigest()


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def load_json(path, what):
    try:
        with open(path, "rb") as f:
            return json.load(f)
    except (OSError, ValueError) as e:
        raise GateError(f"cannot read {what} {path}: {e}")


def parse_run_id(run_id):
    out = {}
    if not isinstance(run_id, str) or not run_id:
        raise GateError("provenance.run_id missing")
    for part in run_id.split(";"):
        if "=" not in part:
            raise GateError(f"malformed run_id component {part!r}")
        k, v = part.split("=", 1)
        if k in out:
            raise GateError(f"duplicate run_id key {k!r}")
        out[k] = v
    return out


def require_complete(prov):
    problems = []
    if prov.get("completion") != "complete":
        problems.append(f"completion={prov.get('completion')!r}, want 'complete'")
    if prov.get("corpus_verified") is not True:
        problems.append("corpus_verified is not true")
    if prov.get("scope") != "whole-corpus":
        problems.append(f"scope={prov.get('scope')!r}, want 'whole-corpus'")
    if problems:
        raise GateError("measurement is not a complete verified whole-corpus sweep: " + "; ".join(problems))


def classifier_fingerprint(project_git, endo_sha, paths):
    """Git blob ids of `paths` at `endo_sha`, folded into one sha256."""
    if not project_git:
        raise GateError("--project-git is required to fingerprint the classifier")
    if not endo_sha:
        raise GateError("provenance.endo_sha missing; cannot fingerprint the classifier")
    r = subprocess.run(
        ["git", "-C", project_git, "rev-parse", "--verify", "--quiet", f"{endo_sha}^{{commit}}"],
        capture_output=True, text=True)
    if r.returncode != 0:
        raise GateError(f"commit {endo_sha} not present in {project_git}")
    blobs = {}
    for p in sorted(paths):
        r = subprocess.run(
            ["git", "-C", project_git, "rev-parse", "--verify", "--quiet", f"{endo_sha}:{p}"],
            capture_output=True, text=True)
        blobs[p] = r.stdout.strip() if r.returncode == 0 else "MISSING"
    h = hashlib.sha256()
    for p in sorted(blobs):
        h.update(f"{p}\0{blobs[p]}\n".encode("utf-8"))
    return {"endo_sha": endo_sha, "paths": sorted(paths), "blobs": blobs, "fingerprint": h.hexdigest()}


def read_report(path):
    """A full-run report.json -> normalized measurement."""
    r = load_json(path, "report")
    if not isinstance(r, dict):
        raise GateError(f"report {path} is not a JSON object")
    if r.get("schema") not in REPORT_SCHEMAS:
        raise GateError(f"unsupported report schema {r.get('schema')!r}")
    prov = r.get("provenance") or {}
    cases = r.get("cases")
    if not isinstance(cases, list):
        raise GateError("report.cases missing")
    by_path = {}
    for c in cases:
        p = c.get("path") if isinstance(c, dict) else None
        if not isinstance(p, str) or not p or "\n" in p:
            raise GateError(f"report case with bad path: {c!r}"[:300])
        if p in by_path:
            raise GateError(f"duplicate case path {p}")
        by_path[p] = {k: c.get(k) for k in ("category", "outcome", "reason")}
    by_category = {}
    for d in by_path.values():
        by_category[d["category"]] = by_category.get(d["category"], 0) + 1
    summary = (r.get("summary") or {}).get("by_category")
    if isinstance(summary, dict):
        nonzero = {k: v for k, v in summary.items() if v}
        if nonzero != by_category:
            raise GateError(f"report summary.by_category {nonzero} disagrees with its cases {by_category}")
    total = (r.get("summary") or {}).get("total")
    if total is not None and total != len(by_path):
        raise GateError(f"report summary.total {total} != {len(by_path)} cases")
    covered = sort_paths(p for p, d in by_path.items() if d["category"] == "covered")
    return {
        "source": {"kind": "report", "path": os.path.abspath(path), "sha256": sha256_file(path)},
        "provenance": prov,
        "total_cases": len(by_path),
        "by_category": dict(sorted(by_category.items())),
        "covered": covered,
        "cases": by_path,
    }


def read_baseline_dir(path):
    """An in-tree baseline/refresh-<date>/ (baseline.json + covered.txt) -> measurement."""
    b = load_json(os.path.join(path, "baseline.json"), "baseline")
    prov = b.get("provenance") or {}
    totals = b.get("totals_by_category")
    if not isinstance(totals, dict):
        raise GateError(f"{path}/baseline.json has no totals_by_category")
    cov_file = os.path.join(path, "covered.txt")
    try:
        with open(cov_file, "rb") as f:
            raw = f.read().decode("utf-8")
    except (OSError, UnicodeDecodeError) as e:
        raise GateError(f"cannot read {cov_file}: {e}")
    covered = [l for l in raw.split("\n") if l]
    if len(set(covered)) != len(covered):
        raise GateError(f"{cov_file} has duplicate paths")
    if totals.get("covered") != len(covered):
        raise GateError(f"{cov_file} has {len(covered)} paths but baseline.json says covered={totals.get('covered')}")
    total = b.get("total_cases")
    if total != sum(totals.values()):
        raise GateError(f"baseline total_cases {total} != sum of totals_by_category {sum(totals.values())}")
    return {
        "source": {"kind": "baseline-dir", "path": os.path.abspath(path),
                   "sha256": sha256_file(os.path.join(path, "baseline.json"))},
        "provenance": prov,
        "total_cases": total,
        "by_category": dict(sorted(totals.items())),
        "covered": sort_paths(covered),
        "cases": None,
    }


def read_measurement(args):
    if args.from_report:
        return read_report(args.from_report)
    return read_baseline_dir(args.from_baseline)


def compat_identity(m, classifier):
    prov = m["provenance"]
    return {
        "provenance": {k: prov.get(k) for k in COMPAT_PROVENANCE_KEYS},
        "run_params": {k: v for k, v in sorted(parse_run_id(prov.get("run_id")).items())
                       if k not in RUN_ID_FREE_KEYS},
        "categories": sorted(k for k, v in m["by_category"].items() if v is not None),
        "total_cases": m["total_cases"],
        "classifier": classifier["fingerprint"],
    }


def compare_compat(pin, m, classifier):
    """List every reason the measurement is not comparable to the pin."""
    want = pin["compat"]
    got = compat_identity(m, classifier)
    reasons = []
    for k in COMPAT_PROVENANCE_KEYS:
        if want["provenance"].get(k) != got["provenance"].get(k):
            reasons.append(f"provenance.{k}: pin {want['provenance'].get(k)!r} != measurement {got['provenance'].get(k)!r}")
    for k in sorted(set(want["run_params"]) | set(got["run_params"])):
        a, b = want["run_params"].get(k), got["run_params"].get(k)
        if a != b:
            reasons.append(f"run parameter {k}: pin {a!r} != measurement {b!r}")
    extra = sorted(c for c, n in m["by_category"].items() if n and c not in want["categories"])
    if extra:
        reasons.append(f"category vocabulary: measurement uses {extra}, unknown to the pin")
    if want["total_cases"] != got["total_cases"]:
        reasons.append(f"total cases: pin {want['total_cases']} != measurement {got['total_cases']}")
    if want["classifier"] != got["classifier"]:
        pb, mb = pin["classifier"]["blobs"], classifier["blobs"]
        changed = sorted(p for p in set(pb) | set(mb) if pb.get(p) != mb.get(p))
        reasons.append(f"classifier fingerprint differs (pin at {pin['classifier']['endo_sha'][:12]}, "
                       f"measurement at {classifier['endo_sha'][:12]}); changed: {changed}")
    return reasons


def diff_paths(pin_covered, m, limit):
    covered = set(m["covered"])
    pinned = set(pin_covered)
    lost = sort_paths(pinned - covered)
    gained = sort_paths(covered - pinned)
    by_reason = {}
    by_category = {}
    lost_detail = []
    for p in lost:
        d = (m["cases"] or {}).get(p) if m["cases"] is not None else None
        if d is None:
            d = {"category": "absent" if m["cases"] is not None else None, "outcome": None, "reason": None}
        key = f"{d['category']}:{d['reason']}"
        by_reason[key] = by_reason.get(key, 0) + 1
        by_category[d["category"]] = by_category.get(d["category"], 0) + 1
        lost_detail.append({"path": p, **d})
    return {
        "lost_count": len(lost),
        "gained_count": len(gained),
        "net": len(covered) - len(pinned),
        "lost_by_category": dict(sorted(by_category.items(), key=lambda kv: (-kv[1], str(kv[0])))),
        "lost_by_disposition": dict(sorted(by_reason.items(), key=lambda kv: (-kv[1], kv[0]))),
        "lost": lost_detail,
        "gained": gained[:limit],
        "gained_truncated": len(gained) > limit,
    }


def emit(record, out):
    text = json.dumps(record, indent=1, sort_keys=True) + "\n"
    if out:
        tmp = out + ".tmp"
        with open(tmp, "w") as f:
            f.write(text)
        os.replace(tmp, out)
    sys.stdout.write(text)


def cmd_pin(args):
    m = read_measurement(args)
    require_complete(m["provenance"])
    classifier = classifier_fingerprint(args.project_git, m["provenance"].get("endo_sha"),
                                        args.classifier_path or DEFAULT_CLASSIFIER_PATHS)
    pin = {
        "schema": PIN_SCHEMA,
        "label": args.label or os.path.basename(os.path.normpath(args.out)),
        "source": m["source"],
        "provenance": m["provenance"],
        "compat": compat_identity(m, classifier),
        "classifier": classifier,
        "by_category": m["by_category"],
        "covered": {"count": len(m["covered"]), "sha256": sha256_lines(m["covered"]), "file": "covered.txt"},
    }
    if args.supersedes:
        old = load_pin(args.supersedes)
        if not args.note:
            raise GateError("--supersedes requires --note naming the reconciliation and who authorized it")
        d = diff_paths(old["_covered"], m, args.list_limit)
        pin["reconciliation"] = {
            "supersedes": old["label"],
            "supersedes_covered_sha256": old["covered"]["sha256"],
            "note": args.note,
            "comparable": not compare_compat(old, m, classifier),
            "dropped_count": d["lost_count"],
            "dropped_by_category": d["lost_by_category"],
            "dropped_by_disposition": d["lost_by_disposition"],
            "dropped": d["lost"],
        }
    os.makedirs(args.out, exist_ok=True)
    with open(os.path.join(args.out, "covered.txt"), "w", encoding="utf-8") as f:
        f.write("".join(p + "\n" for p in m["covered"]))
    emit(pin, os.path.join(args.out, "pin.json"))
    return 0


def load_pin(pin_dir):
    pin = load_json(os.path.join(pin_dir, "pin.json"), "pin")
    if pin.get("schema") != PIN_SCHEMA:
        raise GateError(f"unsupported pin schema {pin.get('schema')!r}")
    cov_file = os.path.join(pin_dir, pin["covered"]["file"])
    try:
        with open(cov_file, "rb") as f:
            covered = [l for l in f.read().decode("utf-8").split("\n") if l]
    except (OSError, UnicodeDecodeError) as e:
        raise GateError(f"cannot read pinned {cov_file}: {e}")
    if covered != sort_paths(covered) or sha256_lines(covered) != pin["covered"]["sha256"] \
            or len(covered) != pin["covered"]["count"]:
        raise GateError(f"pinned {cov_file} does not match pin.json (count/sha256/byte order)")
    pin["_covered"] = covered
    return pin


def cmd_check(args):
    record = {"schema": GATE_SCHEMA, "pin": args.pin, "report": os.path.abspath(args.report),
              "require_growth": args.require_growth}
    try:
        pin = load_pin(args.pin)
        record["pin"] = {"label": pin["label"], "covered_count": pin["covered"]["count"],
                         "covered_sha256": pin["covered"]["sha256"],
                         "endo_sha": pin["provenance"].get("endo_sha")}
        m = read_report(args.report)
        require_complete(m["provenance"])
        classifier = classifier_fingerprint(args.project_git, m["provenance"].get("endo_sha"),
                                            pin["classifier"]["paths"])
    except GateError as e:
        record.update(verdict="error", reasons=[str(e)])
        emit(record, args.record)
        return EXIT["error"]
    record["measurement"] = {
        "endo_sha": m["provenance"].get("endo_sha"),
        "run_id": m["provenance"].get("run_id"),
        "report_sha256": m["source"]["sha256"],
        "total_cases": m["total_cases"],
        "by_category": m["by_category"],
        "covered_count": len(m["covered"]),
        "covered_sha256": sha256_lines(m["covered"]),
        "classifier_fingerprint": classifier["fingerprint"],
    }
    diff = diff_paths(pin["_covered"], m, args.list_limit)
    incompatible = compare_compat(pin, m, classifier)
    if incompatible:
        record.update(verdict="incompatible", reasons=incompatible, informational_diff=diff)
    else:
        reasons = []
        if diff["lost_count"]:
            reasons.append(f"{diff['lost_count']} pinned covered path(s) lost")
        if args.require_growth and diff["gained_count"] == 0:
            reasons.append("no covered path gained")
        record.update(verdict="fail" if reasons else "pass", reasons=reasons, diff=diff)
    emit(record, args.record)
    return EXIT[record["verdict"]]


def main(argv):
    ap = argparse.ArgumentParser(prog="ironhorse-test262-ratchet-gate.sh",
                                 description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("pin", help="freeze a floor into <out>/pin.json + covered.txt")
    src = p.add_mutually_exclusive_group(required=True)
    src.add_argument("--from-report", metavar="REPORT_JSON")
    src.add_argument("--from-baseline", metavar="BASELINE_DIR")
    p.add_argument("--project-git", required=True, metavar="DIR",
                   help="endo-but-for-bots checkout or bare repo containing provenance.endo_sha")
    p.add_argument("--out", required=True, metavar="PIN_DIR")
    p.add_argument("--label")
    p.add_argument("--classifier-path", action="append", metavar="REPO_PATH",
                   help="verdict source to fingerprint (repeatable; default: the ironhorse-262 runner set)")
    p.add_argument("--supersedes", metavar="OLD_PIN_DIR")
    p.add_argument("--note", help="reconciliation note (required with --supersedes)")
    p.add_argument("--list-limit", type=int, default=500)
    c = sub.add_parser("check", help="compare a report.json against a pin; print the gate record")
    c.add_argument("--pin", required=True, metavar="PIN_DIR")
    c.add_argument("--report", required=True, metavar="REPORT_JSON")
    c.add_argument("--project-git", required=True, metavar="DIR")
    c.add_argument("--require-growth", action="store_true")
    c.add_argument("--record", metavar="FILE", help="also write the gate record here")
    c.add_argument("--list-limit", type=int, default=500)
    args = ap.parse_args(argv)
    if args.cmd == "pin":
        try:
            return cmd_pin(args)
        except GateError as e:
            print(f"ironhorse-test262-ratchet-gate: pin: {e}", file=sys.stderr)
            return EXIT["error"]
    return cmd_check(args)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
