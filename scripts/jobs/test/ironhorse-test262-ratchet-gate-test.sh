#!/bin/bash
# ironhorse-test262-ratchet-gate-test.sh — validate the pinned-baseline comparator on
# synthetic fixtures: a throwaway git repo stands in for endo-but-for-bots (so the
# classifier fingerprint is computed for real), and tiny report.json files stand in for
# whole-corpus sweeps. No cargo, no network.
#
# Asserts:
#   A. identical measurement → pass (rc 0); --require-growth with no gain → fail (rc 1)
#   B. a lost pinned path → fail (rc 1), with the lost path's new disposition recorded
#   C. growth with zero loss → pass under --require-growth, gained listed
#   D. a classifier source change at the measured commit → incompatible (rc 2), diff informational only
#   E. an engine-only change (outside the classifier set) stays comparable
#   F. a changed run parameter (case-timeout) → incompatible
#   G. a category unknown to the pin → incompatible
#   H. fail-closed inputs → error (rc 3): incomplete sweep, unknown commit, tampered pin, inconsistent summary
#   I. pin from an in-tree baseline dir; --supersedes needs --note and records dropped paths
#   J. --record writes the same JSON the gate prints
#
# Usage: ironhorse-test262-ratchet-gate-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATE="$HERE/../ironhorse-test262-ratchet-gate.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

TR="$(mktemp -d "${TMPDIR:-/tmp}/ih262-gate-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
REPO="$TR/repo"
git_id=(-c user.name=test -c user.email=test@localhost)
git init -q "$REPO"
SRC=rust/engine/ironhorse-262
mkdir -p "$REPO/$SRC/src/bin" "$REPO/$SRC/scripts" "$REPO/rust/engine/ironhorse-vm"
for f in scripts/full-run.sh src/bin/endot_ih.rs src/report.rs src/xst.rs; do echo v1 > "$REPO/$SRC/$f"; done
echo vm1 > "$REPO/rust/engine/ironhorse-vm/lib.rs"
commit() { git -C "$REPO" add -A; git -C "$REPO" "${git_id[@]}" commit -q -m "$1"; git -C "$REPO" rev-parse HEAD; }
C1="$(commit base)"
echo vm2 > "$REPO/rust/engine/ironhorse-vm/lib.rs"; C2="$(commit engine-fix)"
echo v2 > "$REPO/$SRC/src/xst.rs"; C3="$(commit classifier-change)"

# mkreport <out> <endo-sha> <case-timeout|-> <completion> <path:category>...
mkreport() {
  local out="$1" sha="$2" ct="$3" completion="$4"; shift 4
  python3 - "$out" "$sha" "$ct" "$completion" "$@" <<'PY'
import json, sys
out, sha, ct, completion, *cases = sys.argv[1:]
rid = f"test262=t262pin;endo={sha};oracle=on;moddable=xspin;ses=none;cap=100"
if ct != "-":
    rid += f";case-timeout={ct}"
rid += ";scope=<all>"
cs, cat = [], {}
for spec in cases:
    p, c = spec.rsplit(":", 1)
    cs.append({"path": p, "category": c, "outcome": "covered" if c == "covered" else "run-skip",
               "reason": None if c == "covered" else f"why-{c}"})
    cat[c] = cat.get(c, 0) + 1
json.dump({"schema": "ironhorse-test262-report/1",
           "provenance": {"runner": "endot-ih", "test262_sha": "t262pin", "endo_sha": sha,
                          "oracle_mode": "on", "ses_mode": "none", "scope": "whole-corpus",
                          "completion": completion, "corpus_verified": True, "run_id": rid},
           "summary": {"total": len(cs), "by_category": cat}, "cases": cs}, open(out, "w"))
PY
}
BASE=(a.js:covered b.js:covered c.js:unsupported d.js:skipped)
mkreport "$TR/r0.json" "$C1" 60 complete "${BASE[@]}"
field() { python3 -c "import json,sys; r=json.load(open(sys.argv[1])); print(eval(sys.argv[2]))" "$@"; }
check() { # check <name> <report> [extra...] ; sets rc, writes $TR/<name>.json
  local name="$1" rep="$2"; shift 2
  set +e; "$GATE" check --pin "$TR/pin" --report "$rep" --project-git "$REPO" "$@" > "$TR/$name.json"; rc=$?; set -e
}

"$GATE" pin --from-report "$TR/r0.json" --project-git "$REPO" --out "$TR/pin" > /dev/null
[ "$(cat "$TR/pin/covered.txt")" = "$(printf 'a.js\nb.js')" ] && ok "pin writes byte-sorted covered.txt" || bad "pin covered.txt"

echo "A. identical measurement"
check a "$TR/r0.json"
[ $rc = 0 ] && [ "$(field "$TR/a.json" 'r["verdict"]')" = pass ] && ok "identical → pass rc 0" || bad "identical rc=$rc"
check a2 "$TR/r0.json" --require-growth
[ $rc = 1 ] && [ "$(field "$TR/a2.json" 'r["reasons"][0]')" = "no covered path gained" ] && ok "no growth → fail rc 1" || bad "no growth rc=$rc"

echo "B. lost path"
mkreport "$TR/rb.json" "$C2" 60 complete a.js:covered b.js:unsupported c.js:unsupported d.js:skipped
check b "$TR/rb.json"
[ $rc = 1 ] && [ "$(field "$TR/b.json" 'r["diff"]["lost"][0]["path"], r["diff"]["lost"][0]["reason"]')" = "('b.js', 'why-unsupported')" ] \
  && ok "lost → fail rc 1 with new disposition" || bad "lost rc=$rc"

echo "C. growth"
mkreport "$TR/rc.json" "$C2" 60 complete a.js:covered b.js:covered c.js:covered d.js:skipped
check c "$TR/rc.json" --require-growth
[ $rc = 0 ] && [ "$(field "$TR/c.json" 'r["diff"]["gained"], r["diff"]["lost_count"]')" = "(['c.js'], 0)" ] \
  && ok "growth, zero loss → pass" || bad "growth rc=$rc"

echo "D/E. classifier fingerprint"
mkreport "$TR/rd.json" "$C3" 60 complete a.js:covered b.js:covered c.js:covered d.js:skipped
check d "$TR/rd.json"
[ $rc = 2 ] && field "$TR/d.json" 'r["reasons"][0]' | grep -q 'src/xst.rs' \
  && [ "$(field "$TR/d.json" '"diff" in r, r["informational_diff"]["gained_count"]')" = "(False, 1)" ] \
  && ok "classifier change → incompatible rc 2, diff informational" || bad "classifier rc=$rc"
[ "$(field "$TR/c.json" 'r["measurement"]["classifier_fingerprint"] == json.load(open(sys.argv[1].replace("c.json","a.json")))["measurement"]["classifier_fingerprint"]')" = True ] \
  && ok "engine-only change keeps the fingerprint" || bad "engine-only fingerprint moved"

echo "F. run parameter"
mkreport "$TR/rf.json" "$C1" 120 complete "${BASE[@]}"
check f "$TR/rf.json"
[ $rc = 2 ] && field "$TR/f.json" 'r["reasons"]' | grep -q "case-timeout" && ok "case-timeout change → incompatible" || bad "run param rc=$rc"

echo "G. category vocabulary"
mkreport "$TR/rg.json" "$C1" 60 complete a.js:covered b.js:covered c.js:refused d.js:skipped
check g "$TR/rg.json"
[ $rc = 2 ] && field "$TR/g.json" 'r["reasons"]' | grep -q "refused" && ok "new category → incompatible" || bad "vocabulary rc=$rc"

echo "H. fail closed"
mkreport "$TR/rh1.json" "$C1" 60 partial "${BASE[@]}"
check h1 "$TR/rh1.json"
[ $rc = 3 ] && field "$TR/h1.json" 'r["verdict"]' | grep -qx error && ok "incomplete sweep → error rc 3" || bad "incomplete rc=$rc"
mkreport "$TR/rh2.json" 0123456789012345678901234567890123456789 60 complete "${BASE[@]}"
check h2 "$TR/rh2.json"
[ $rc = 3 ] && ok "unknown endo commit → error" || bad "unknown commit rc=$rc"
python3 -c "import json,sys; r=json.load(open(sys.argv[1])); r['summary']['by_category']['covered']=3; json.dump(r,open(sys.argv[2],'w'))" "$TR/r0.json" "$TR/rh3.json"
check h3 "$TR/rh3.json"
[ $rc = 3 ] && ok "summary/cases disagreement → error" || bad "summary rc=$rc"
cp -r "$TR/pin" "$TR/pin.good"; printf 'a.js\nb.js\nz.js\n' > "$TR/pin/covered.txt"
check h4 "$TR/r0.json"
[ $rc = 3 ] && field "$TR/h4.json" 'r["reasons"][0]' | grep -q "does not match pin.json" && ok "tampered pin → error" || bad "tampered rc=$rc"
rm -rf "$TR/pin"; mv "$TR/pin.good" "$TR/pin"
set +e; "$GATE" check --pin "$TR/pin" --report "$TR/nonexistent.json" --project-git "$REPO" > "$TR/h5.json"; rc=$?; set -e
[ $rc = 3 ] && ok "missing report → error" || bad "missing report rc=$rc"

echo "I. baseline-dir pin and reconciliation"
BD="$TR/refresh-x"; mkdir -p "$BD"
printf 'a.js\nb.js\nc.js\n' > "$BD/covered.txt"
python3 - "$BD/baseline.json" "$C1" <<'PY'
import json, sys
json.dump({"provenance": {"runner": "endot-ih", "test262_sha": "t262pin", "endo_sha": sys.argv[2],
                          "oracle_mode": "on", "ses_mode": "none", "scope": "whole-corpus",
                          "completion": "complete", "corpus_verified": True,
                          "run_id": f"test262=t262pin;endo={sys.argv[2]};oracle=on;moddable=xspin;ses=none;cap=100;scope=<all>"},
           "total_cases": 4, "totals_by_category": {"covered": 3, "ironhorse-failure": 0, "skipped": 1}},
          open(sys.argv[1], "w"))
PY
"$GATE" pin --from-baseline "$BD" --project-git "$REPO" --out "$TR/pin-old" > /dev/null && ok "pin from baseline dir" || bad "baseline-dir pin"
set +e; "$GATE" pin --from-report "$TR/r0.json" --project-git "$REPO" --out "$TR/pin-new" --supersedes "$TR/pin-old" > /dev/null 2>&1; rc=$?; set -e
[ $rc = 3 ] && ok "--supersedes without --note refused" || bad "supersedes no-note rc=$rc"
"$GATE" pin --from-report "$TR/r0.json" --project-git "$REPO" --out "$TR/pin-new" --supersedes "$TR/pin-old" --note "authorized: test" > /dev/null
[ "$(field "$TR/pin-new/pin.json" 'r["reconciliation"]["dropped_count"], r["reconciliation"]["dropped"][0]["path"], r["reconciliation"]["comparable"]')" = "(1, 'c.js', False)" ] \
  && ok "reconciliation records the dropped path" || bad "reconciliation record"

echo "J. --record"
"$GATE" check --pin "$TR/pin" --report "$TR/r0.json" --project-git "$REPO" --record "$TR/j-record.json" > "$TR/j-stdout.json"
cmp -s "$TR/j-record.json" "$TR/j-stdout.json" && ok "--record matches stdout" || bad "--record differs"

echo "PASS=$PASS FAIL=$FAIL"
[ "$FAIL" = 0 ]
