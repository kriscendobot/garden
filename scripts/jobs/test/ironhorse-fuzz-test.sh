#!/bin/bash
# ironhorse-fuzz-test.sh — validate the continuous Ironhorse fuzz service on throwaway
# fixtures, with NO GitHub, NO cargo, NO real fuzzing. Every heavy dependency is a seam
# (runner / minimizer / reproducer / project-sha / pr-state), stubbed deterministically;
# the dedup identity, the durable persistence, the standing-PR lifecycle + rollover, the
# untrusted-data handling, and the idempotent replay all run FOR REAL against a throwaway
# journal (mirrors pages-watcher-test.sh).
#
# Asserts:
#   A. leader/drain gating — ExecCondition on the unit + a draining marker skips the tick (no job)
#   B. one reproduced finding → exactly one repair job + one durable finding marker + persisted artifact
#   C. repeat-finding dedup — the SAME crash on the next tick posts NO duplicate (journal marker)
#   D. restart/resume — a fresh state dir but a surviving journal marker still dedups (host-loss safe)
#   E. two DISTINCT findings → two distinct repair jobs + two markers
#   F. a crash that does NOT reproduce (reproducer says flake) → no job, no marker
#   G. bounded artifact — an input over the byte cap → marker recorded with base64 OMITTED, job still posted
#   H. standing-PR adoption — every repair job targets the SAME marker_base + branch (one standing PR)
#   I. post-merge rollover — a MERGED standing PR bumps the generation; the next finding targets gen 2
#   J. first-run init — standing.md is created on a virgin journal
#   K. untrusted-data — raw crash bytes never appear in the repair job body (only sha256 + base64 + path)
#
# Usage: ironhorse-fuzz-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SYSD="$(cd "$JOBS/../systemd" && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-ironhorse-fuzz-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

seed_bare() {  # seed_bare <bare-path>
  local bare="$1" seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/plan jobs/todo jobs/doin jobs/tada jobs/index work ironhorse-fuzz
    for d in jobs/plan jobs/todo jobs/doin jobs/tada jobs/index work ironhorse-fuzz; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}

jput() {  # jput <bare> <journal2-path> <content-file>  — commit a file into the journal
  local bare="$1" path="$2" src="$3" w; w="$(mktemp -d "$TR/jput.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$bare" "$w" 2>/dev/null
  mkdir -p "$w/$(dirname "$path")"; cp "$src" "$w/$path"
  git -C "$w" add -A; git -C "$w" "${git_id[@]}" commit -q -m "seed $path" >/dev/null
  git -C "$w" push -q origin "$BRANCH"; rm -rf "$w"
}

jfile() {  # jfile <bare> <journal2-path>  — cat a journal file (empty if absent)
  local bare="$1" path="$2" w; w="$(mktemp -d "$TR/jf.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$bare" "$w" 2>/dev/null
  cat "$w/$path" 2>/dev/null || true; rm -rf "$w"
}

board_has() {  # board_has <bare> <base>
  local v; v="$(mktemp -d "$TR/bv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  local rc=1 s
  for s in plan todo doin tada; do [ -e "$v/jobs/$s/$2.md" ] && rc=0; done
  rm -rf "$v"; return $rc
}
todo_count() {  # todo_count <bare> — repair jobs in todo (excludes .gitkeep)
  local v n; v="$(mktemp -d "$TR/tc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/todo" 2>/dev/null | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}
job_body() {  # job_body <bare> <base>
  local v out; v="$(mktemp -d "$TR/jb.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  out="$(cat "$v/jobs/todo/$2.md" 2>/dev/null || true)"; rm -rf "$v"; printf '%s' "$out"
}
finding_ids() {  # finding_ids <bare> — list recorded finding ids
  local v; v="$(mktemp -d "$TR/fi.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  ls -1 "$v/ironhorse-fuzz/findings" 2>/dev/null | grep '\.md$' | grep -v '.gitkeep' | sed 's/\.md$//' || true
  rm -rf "$v"
}

# --- seams (deterministic stubs) --------------------------------------------
mk_stubs() {
  RUNNER="$TR/stub-runner.sh"; cat > "$RUNNER" <<'EOF'
#!/bin/bash
# runner <target> <corpus-dir> <artifacts-dir> <seconds>
target="$1"; arts="$3"
src="$STUB_SEED_ROOT/$target"
dropped=0
if [ -d "$src" ]; then
  for f in "$src"/*; do
    [ -f "$f" ] || continue
    cp "$f" "$arts/crash-$(basename "$f")"; dropped=1
  done
fi
[ "$dropped" = 1 ] && exit 77 || exit 0
EOF
  MINIMIZER="$TR/stub-min.sh"; cat > "$MINIMIZER" <<'EOF'
#!/bin/bash
# minimizer <target> <in> <out> — identity (stable id = sha256(target\0 rawbytes))
cp "$2" "$3"
EOF
  REPRODUCER="$TR/stub-repro.sh"; cat > "$REPRODUCER" <<'EOF'
#!/bin/bash
# reproducer <target> <in> — exit per STUB_REPRO_RC (default 0 = reproduces)
exit "${STUB_REPRO_RC:-0}"
EOF
  SHACMD="$TR/stub-sha.sh"; cat > "$SHACMD" <<'EOF'
#!/bin/bash
echo "${STUB_SHA:-cd6e55513ca6618755ee9455809a8ead7c9227a4}"
EOF
  PRSTATE="$TR/stub-prstate.sh"; cat > "$PRSTATE" <<'EOF'
#!/bin/bash
# args: repo marker author [--number]
if [ "${4:-}" = "--number" ]; then echo "${STUB_PR_NUMBER:-0}"; else echo "${STUB_PR_STATE:-NONE}"; fi
EOF
  chmod +x "$RUNNER" "$MINIMIZER" "$REPRODUCER" "$SHACMD" "$PRSTATE"
}
mk_stubs

# run_svc <state> <bare> <seed-root> [extra env KEY=VAL ...]
run_svc() {
  local state="$1" bare="$2" seedroot="$3"; shift 3
  env -i HOME="$HOME" PATH="$PATH" \
      GARDEN_TEST=1 \
      GARDEN_STATE="$state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN="testhost" GARDEN_LEADER="testhost" \
      GARDEN_IRONHORSE_FUZZ_STATE="$state/ihf" \
      STUB_SEED_ROOT="$seedroot" \
      GARDEN_IRONHORSE_FUZZ_RUNNER="$RUNNER" \
      GARDEN_IRONHORSE_FUZZ_MINIMIZER="$MINIMIZER" \
      GARDEN_IRONHORSE_FUZZ_REPRODUCER="$REPRODUCER" \
      GARDEN_IRONHORSE_FUZZ_SHA_CMD="$SHACMD" \
      GARDEN_IRONHORSE_FUZZ_PR_STATE="$PRSTATE" \
      GARDEN_IRONHORSE_FUZZ_POST="$JOBS/post-job.sh" \
      GARDEN_IRONHORSE_FUZZ_TARGETS="parser bytecode_decoder" \
      GARDEN_IRONHORSE_FUZZ_SECS=1 \
      GARDEN_BACKOFF_BASE_MS=0 \
      "$@" \
      "$JOBS/ironhorse-fuzz.sh" >"$TR/last.log" 2>&1
}

# ============================================================================
hr; echo "A — leader/drain gating"; hr
grep -q 'ExecCondition=.*is-main-host.sh' "$SYSD/garden-ironhorse-fuzz.service" \
  && ok "unit carries the leader-only is-main-host.sh ExecCondition" \
  || bad "unit missing leader ExecCondition"
grep -q 'MemoryMax' "$SYSD/garden-ironhorse-fuzz.service" \
  && ok "unit carries resource bounds (MemoryMax)" || bad "unit missing resource bounds"
BARE_A="$TR/a.git"; seed_bare "$BARE_A"
SEED_A="$TR/seed-a"; mkdir -p "$SEED_A/parser"; printf 'CRASHBYTES-A' > "$SEED_A/parser/c1"
mkdir -p "$TR/state-a/ihf"
: > "$TR/state-a/draining"   # GARDEN_DRAINING_MARKER default = $GARDEN_STATE/draining
run_svc "$TR/state-a" "$BARE_A" "$SEED_A"
[ "$(todo_count "$BARE_A")" -eq 0 ] && ok "drain marker → no job posted" || bad "posted despite drain"
grep -q 'fleet draining' "$TR/last.log" && ok "logged the drain skip" || bad "no drain-skip log"

# ============================================================================
hr; echo "B — one reproduced finding → one repair job + marker + durable artifact"; hr
BARE_B="$TR/b.git"; seed_bare "$BARE_B"
SEED_B="$TR/seed-b"; mkdir -p "$SEED_B/parser"; printf 'HELLO-CRASH-B' > "$SEED_B/parser/c1"
run_svc "$TR/state-b" "$BARE_B" "$SEED_B"
[ "$(todo_count "$BARE_B")" -eq 1 ] && ok "exactly one repair job" || { bad "expected 1 job, got $(todo_count "$BARE_B")"; cat "$TR/last.log"; }
fid_b="$(finding_ids "$BARE_B" | head -n1)"
[ -n "$fid_b" ] && ok "finding marker recorded ($fid_b)" || bad "no finding marker"
board_has "$BARE_B" "ironhorse-fuzz-${fid_b}-repair" && ok "repair job keyed by finding id" || bad "repair job base mismatch"
[ -s "$TR/state-b/ihf/findings/$fid_b/input.bin" ] && ok "durable artifact persisted to state" || bad "no durable artifact"
[ -f "$TR/state-b/ihf/corpus/parser" -o -d "$TR/state-b/ihf/corpus/parser" ] && ok "persistent corpus dir exists" || bad "no corpus dir"

# ============================================================================
hr; echo "C — repeat-finding dedup (same crash, next tick)"; hr
run_svc "$TR/state-b" "$BARE_B" "$SEED_B"
[ "$(todo_count "$BARE_B")" -eq 1 ] && ok "still exactly one job (deduped)" || bad "duplicated: $(todo_count "$BARE_B")"

# ============================================================================
hr; echo "D — restart/resume: fresh state dir, surviving journal marker still dedups"; hr
run_svc "$TR/state-b-fresh" "$BARE_B" "$SEED_B"
[ "$(todo_count "$BARE_B")" -eq 1 ] && ok "journal marker dedups across host/state loss" || bad "re-posted after state loss: $(todo_count "$BARE_B")"

# ============================================================================
hr; echo "E — two distinct findings → two repair jobs"; hr
BARE_E="$TR/e.git"; seed_bare "$BARE_E"
SEED_E="$TR/seed-e"; mkdir -p "$SEED_E/parser" "$SEED_E/bytecode_decoder"
printf 'DISTINCT-ONE'   > "$SEED_E/parser/c1"
printf 'DISTINCT-TWO-X' > "$SEED_E/bytecode_decoder/c1"
run_svc "$TR/state-e" "$BARE_E" "$SEED_E"
[ "$(todo_count "$BARE_E")" -eq 2 ] && ok "two distinct repair jobs" || { bad "expected 2, got $(todo_count "$BARE_E")"; cat "$TR/last.log"; }
[ "$(finding_ids "$BARE_E" | wc -l)" -eq 2 ] && ok "two distinct finding markers" || bad "expected 2 markers"

# ============================================================================
hr; echo "F — non-reproducing crash (flake) → no job"; hr
BARE_F="$TR/f.git"; seed_bare "$BARE_F"
SEED_F="$TR/seed-f"; mkdir -p "$SEED_F/parser"; printf 'FLAKE' > "$SEED_F/parser/c1"
run_svc "$TR/state-f" "$BARE_F" "$SEED_F" STUB_REPRO_RC=1
[ "$(todo_count "$BARE_F")" -eq 0 ] && ok "flake discarded, no job" || bad "posted for a non-reproducing crash"
[ -z "$(finding_ids "$BARE_F")" ] && ok "no finding marker for a flake" || bad "recorded a flake"

# ============================================================================
hr; echo "G — bounded artifact: input over cap → marker recorded, base64 OMITTED, job still posted"; hr
BARE_G="$TR/g.git"; seed_bare "$BARE_G"
SEED_G="$TR/seed-g"; mkdir -p "$SEED_G/parser"
head -c 5000 /dev/zero | tr '\0' 'Z' > "$SEED_G/parser/big"
run_svc "$TR/state-g" "$BARE_G" "$SEED_G" GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES=1024
[ "$(todo_count "$BARE_G")" -eq 1 ] && ok "oversized finding still posts a job" || bad "no job for oversized finding"
fid_g="$(finding_ids "$BARE_G" | head -n1)"
mk="$(jfile "$BARE_G" "ironhorse-fuzz/findings/$fid_g.md")"
printf '%s' "$mk" | grep -q 'input_base64: (omitted' && ok "base64 omitted over cap" || bad "did not omit oversized base64"

# ============================================================================
hr; echo "H — standing-PR adoption: all repair jobs target the same marker_base + branch"; hr
b1="$(job_body "$BARE_E" "ironhorse-fuzz-$(finding_ids "$BARE_E" | sed -n 1p)-repair")"
b2="$(job_body "$BARE_E" "ironhorse-fuzz-$(finding_ids "$BARE_E" | sed -n 2p)-repair")"
printf '%s' "$b1" | grep -q 'ensure-pr.sh ironhorse-fuzz-findings ' && \
printf '%s' "$b2" | grep -q 'ensure-pr.sh ironhorse-fuzz-findings ' && \
  ok "both repair jobs adopt the same standing marker_base" || bad "repair jobs disagree on the standing PR"
printf '%s' "$b1" | grep -q 'garden-job: ironhorse-fuzz-findings -->' && ok "job body cites the durable adoption marker" || bad "no adoption marker in body"

# ============================================================================
hr; echo "I — post-merge rollover: MERGED standing PR bumps the generation"; hr
BARE_I="$TR/i.git"; seed_bare "$BARE_I"
# Seed an active gen-1 standing record with a recorded PR number.
STAND1="$TR/stand1.md"; {
  printf 'generation: 1\n'; printf 'branch: ironhorse-fuzz-findings\n'; printf 'marker_base: ironhorse-fuzz-findings\n'
  printf 'base_branch: llm\n'; printf 'repo: endojs/endo-but-for-bots\n'; printf 'state: active\n'; printf 'pr_number: 4242\n'
} > "$STAND1"
jput "$BARE_I" "ironhorse-fuzz/standing.md" "$STAND1"
SEED_I="$TR/seed-i"; mkdir -p "$SEED_I/parser"; printf 'POSTMERGE-CRASH' > "$SEED_I/parser/c1"
run_svc "$TR/state-i" "$BARE_I" "$SEED_I" STUB_PR_STATE=MERGED
newstand="$(jfile "$BARE_I" "ironhorse-fuzz/standing.md")"
printf '%s' "$newstand" | grep -q 'generation: 2' && ok "generation bumped to 2" || { bad "generation did not roll over"; printf '%s\n' "$newstand"; }
printf '%s' "$newstand" | grep -q 'branch: ironhorse-fuzz-findings-2' && ok "new standing branch = ironhorse-fuzz-findings-2" || bad "branch not rolled"
[ -n "$(jfile "$BARE_I" "ironhorse-fuzz/standing-archive/1.md")" ] && ok "gen-1 archived" || bad "no archive record"
fid_i="$(finding_ids "$BARE_I" | head -n1)"
printf '%s' "$(job_body "$BARE_I" "ironhorse-fuzz-${fid_i}-repair")" | grep -q 'ironhorse-fuzz-findings-2' \
  && ok "post-rollover finding targets gen-2 branch" || bad "finding did not target the new generation"

# ============================================================================
hr; echo "J — first-run init creates standing.md on a virgin journal"; hr
# (BARE_B had no standing seed; the first B tick must have created it.)
printf '%s' "$(jfile "$BARE_B" "ironhorse-fuzz/standing.md")" | grep -q 'generation: 1' \
  && ok "standing.md initialized at generation 1" || bad "standing.md not initialized"

# ============================================================================
hr; echo "K — untrusted-data: raw crash bytes never appear in the repair job body"; hr
body_b="$(job_body "$BARE_B" "ironhorse-fuzz-${fid_b}-repair")"
if printf '%s' "$body_b" | grep -q 'HELLO-CRASH-B'; then bad "raw crash bytes leaked into the job body"; else ok "raw crash bytes absent from the job body"; fi
printf '%s' "$body_b" | grep -q 'sha256' && ok "body carries the sha256 provenance instead" || bad "body missing sha256 provenance"

# ============================================================================
hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
