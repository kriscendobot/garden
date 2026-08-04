#!/bin/bash
# cnf-backlog-triple-test.sh — the ordinal backlog measure (scripts/jobs/cnf-backlog-triple.py).
#
# Asserts, over committed fixtures and a throwaway git repo:
#   1. The --check fixtures pass (A/B/C: the triples, the realized floor).
#   2. THE HEADLINE: o< and a total-count delta DISAGREE — finishing one rank-1
#      planning job and replacing it with three rank-0 children lowers the
#      triple under o< while RAISING the count. That case is the entire
#      justification for the ordinal, so it is pinned here explicitly, not only
#      inside --check.
#   3. classification reasons: role -> rank, derived and never declared.
#   4. the --rev / --compare git path reads a board from a commit and reports
#      the o< verdict (exercised on a private temp repo, never the live journal).
#   5. rank is DERIVED: a `rank:`/`omega:` frontmatter field is ignored.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SCRIPT="$JOBS/cnf-backlog-triple.py"
FX="$HERE/fixtures/cnf"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
command -v python3 >/dev/null 2>&1 || { echo "cnf-triple-test: python3 absent, skipping"; exit 0; }
python3 -c 'import yaml' 2>/dev/null || true  # not required; the script line-scans

run() { python3 "$SCRIPT" "$@"; }

# --- 1. the committed fixtures ----------------------------------------------
if run --check >/tmp/cnf-check.$$ 2>&1; then ok "--check passes"; else bad "--check failed"; cat /tmp/cnf-check.$$; fi
rm -f /tmp/cnf-check.$$

# --- 2. the o< vs count DISAGREEMENT (the reason the ordinal exists) ---------
A="$(run --root "$FX/A" --slice total --json)"
B="$(run --root "$FX/B" --slice total --json)"
ta="$(echo "$A" | python3 -c 'import json,sys;print(tuple(json.load(sys.stdin)["total"]["triple"]))')"
tb="$(echo "$B" | python3 -c 'import json,sys;print(tuple(json.load(sys.stdin)["total"]["triple"]))')"
na="$(echo "$A" | python3 -c 'import json,sys;print(json.load(sys.stdin)["total"]["n"])')"
nb="$(echo "$B" | python3 -c 'import json,sys;print(json.load(sys.stdin)["total"]["n"])')"
[ "$ta" = "(1, 1, 2)" ] && ok "A triple (1,1,2)" || bad "A triple $ta"
[ "$tb" = "(1, 0, 5)" ] && ok "B triple (1,0,5)" || bad "B triple $tb"
# o< strictly down (B<A) AND count strictly up (nb>na): the disagreement.
python3 - "$ta" "$tb" "$na" "$nb" <<'PY' && ok "o< DOWN while count UP — ordinal earns its keep" || bad "no disagreement"
import ast,sys
ta,tb=ast.literal_eval(sys.argv[1]),ast.literal_eval(sys.argv[2])
na,nb=int(sys.argv[3]),int(sys.argv[4])
sys.exit(0 if (tb<ta and nb>na) else 1)
PY

# --- 3. classification reasons: role -> rank, first match wins --------------
J="$(run --root "$FX/A" --slice total --json)"
why() { echo "$J" | python3 -c "import json,sys;m={x['base']:x for x in json.load(sys.stdin)['total']['members']};print(m['$1']['rank'],m['$1']['why'])"; }
[ "$(why a-orchestrate-things)" = "2 R2: role orchestrator" ] && ok "orchestrator -> R2" || bad "orchestrator: $(why a-orchestrate-things)"
[ "$(why a-design-foo)"        = "1 R1: role designer" ]     && ok "designer -> R1"     || bad "designer: $(why a-design-foo)"
[ "$(why a-build-one)"         = "0 R0: builder" ]           && ok "builder -> R0"      || bad "builder: $(why a-build-one)"

# realized floor lifts a would-be-R0 parent that has spawned a child.
FW="$(run --root "$FX/C" --slice total --json | python3 -c "import json,sys;m={x['base']:x for x in json.load(sys.stdin)['total']['members']};print(m['c-parent-planning']['rank'],'floor' in m['c-parent-planning']['why'])")"
[ "$FW" = "1 True" ] && ok "realized floor lifts spawned parent to R1" || bad "floor: $FW"

# --- 4. the git --rev / --compare path on a PRIVATE temp repo ---------------
# The live journal shares the root repo; NEVER run git there. Build our own.
TR="$(mktemp -d "${TMPDIR:-/tmp}/cnf-git.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
git -C "$TR" init -q
git -C "$TR" config user.email t@t; git -C "$TR" config user.name t
mkdir -p "$TR/jobs/plan"
mk() { printf -- '---\nrole: %s\ngate: go-ahead\n---\n# %s\n' "$2" "$3" > "$TR/jobs/plan/$1.md"; }
# commit OLD: one R1 designer + two R0 builders  => (0,1,2), n=3
mk g-design designer "Design g"; mk g-b1 builder "Build 1"; mk g-b2 builder "Build 2"
git -C "$TR" add -A; git -C "$TR" commit -qm old; OLD="$(git -C "$TR" rev-parse HEAD)"
# commit NEW: designer finished, replaced by three R0 builders => (0,0,5), n=5
rm "$TR/jobs/plan/g-design.md"; mk g-c1 builder "Child 1"; mk g-c2 builder "Child 2"; mk g-c3 builder "Child 3"
git -C "$TR" add -A; git -C "$TR" commit -qm new; NEW="$(git -C "$TR" rev-parse HEAD)"
CMP="$(run --root "$TR" --compare "$OLD" "$NEW")"
echo "$CMP" | grep -q 'total: 5  o<  w + 2' && ok "--compare: total (0,0,5) o< (0,1,2)" || { bad "--compare verdict wrong"; echo "$CMP"; }
echo "$CMP" | grep -q 'count 3 -> 5 (+2)' && ok "--compare surfaces the +2 count delta" || bad "--compare count delta"
echo "$CMP" | grep -qi 'DISAGREE' && ok "--compare flags the o<-vs-count disagreement" || bad "--compare disagreement note"

# --- 5. rank is DERIVED, never declared: a rank:/omega: field is ignored -----
DR="$(mktemp -d "${TMPDIR:-/tmp}/cnf-derive.XXXXXX")"; mkdir -p "$DR/jobs/plan"
printf -- '---\nrole: builder\nrank: 2\nomega: 2\ngate: go-ahead\n---\n# a builder lying about its rank\n' > "$DR/jobs/plan/liar.md"
DJ="$(run --root "$DR" --slice total --json | python3 -c "import json,sys;m=json.load(sys.stdin)['total']['members'][0];print(m['rank'],m['why'])")"
[ "$DJ" = "0 R0: builder" ] && ok "declared rank:/omega: IGNORED — builder stays R0" || bad "declared rank leaked: $DJ"
rm -rf "$DR"

echo
echo "cnf-backlog-triple-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
