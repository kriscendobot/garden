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
#   E. two DISTINCT findings → two markers, but only one live repair; completing it releases its successor
#   F. a crash that does NOT reproduce (reproducer says flake) → no job, no marker
#   G. bounded artifact — an input over the byte cap → marker recorded with base64 OMITTED, job still posted
#   H. standing-PR adoption — every repair job targets the SAME marker_base + branch (one standing PR)
#   I. post-merge rollover — a MERGED standing PR bumps the generation; the next finding targets gen 2
#   J. first-run init — standing.md is created on a virgin journal
#   K. untrusted-data — raw crash bytes never appear in the repair job body (only sha256 + base64 + path)
#   L. failed release — the durable marker remains queued and a later tick retries it
#   M. shared runner outage — retries persist one episode, warn on its edge, and summarize recovery once
#   N. runner exit contract — a target run's own rc=2 is remapped to target-specific rc=1
#   O. corrupt checkout recovery — quarantine only the project cache and retry provisioning once
#   P. repair-job register — correctness/robustness wording without offensive-security vocabulary
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
  out=""
  for s in plan todo doin tada; do
    [ -f "$v/jobs/$s/$2.md" ] && out="$(cat "$v/jobs/$s/$2.md")"
  done
  rm -rf "$v"; printf '%s' "$out"
}
complete_job() {  # complete_job <bare> <base> — simulate the gardener's todo -> tada transition
  local bare="$1" base="$2" w; w="$(mktemp -d "$TR/done.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$bare" "$w" 2>/dev/null
  mv "$w/jobs/todo/$base.md" "$w/jobs/tada/$base.md"
  git -C "$w" add -A
  git -C "$w" "${git_id[@]}" commit -q -m "complete $base"
  git -C "$w" push -q origin "$BRANCH"
  rm -rf "$w"
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
printf '%s\n' "$target" >> "${STUB_RUN_LOG:-/dev/null}"
[ -z "${STUB_RUN_DIAGNOSTIC:-}" ] || printf '%s\n' "$STUB_RUN_DIAGNOSTIC"
[ "${STUB_RUN_RC:-0}" = 0 ] || exit "$STUB_RUN_RC"
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
  FAILPOST="$TR/stub-fail-post.sh"; cat > "$FAILPOST" <<'EOF'
#!/bin/bash
exit 1
EOF
  chmod +x "$RUNNER" "$MINIMIZER" "$REPRODUCER" "$SHACMD" "$PRSTATE" "$FAILPOST"
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
hr; echo "E — two distinct findings are retained but repairs are serialized"; hr
BARE_E="$TR/e.git"; seed_bare "$BARE_E"
SEED_E="$TR/seed-e"; mkdir -p "$SEED_E/parser" "$SEED_E/bytecode_decoder"
printf 'DISTINCT-ONE'   > "$SEED_E/parser/c1"
printf 'DISTINCT-TWO-X' > "$SEED_E/bytecode_decoder/c1"
run_svc "$TR/state-e" "$BARE_E" "$SEED_E"
[ "$(finding_ids "$BARE_E" | wc -l)" -eq 2 ] && ok "two distinct finding markers" || bad "expected 2 markers"
[ "$(todo_count "$BARE_E")" -eq 1 ] && ok "only one repair released while both findings remain durable" || { bad "expected 1 live repair, got $(todo_count "$BARE_E")"; cat "$TR/last.log"; }
first_e="ironhorse-fuzz-$(finding_ids "$BARE_E" | sed -n 1p)-repair"
second_e="ironhorse-fuzz-$(finding_ids "$BARE_E" | sed -n 2p)-repair"
board_has "$BARE_E" "$first_e" && ok "first deterministic repair released" || bad "first repair was not released"
if board_has "$BARE_E" "$second_e"; then bad "successor released before predecessor completed"; else ok "successor withheld while predecessor is live"; fi
run_svc "$TR/state-e" "$BARE_E" "$SEED_E"
[ "$(todo_count "$BARE_E")" -eq 1 ] && { board_has "$BARE_E" "$second_e" && bad "next tick released successor while predecessor remained live" || ok "next tick still withholds successor"; } || bad "live repair count changed before completion"
complete_job "$BARE_E" "$first_e"
run_svc "$TR/state-e" "$BARE_E" "$SEED_E"
[ "$(todo_count "$BARE_E")" -eq 1 ] && board_has "$BARE_E" "$second_e" \
  && ok "predecessor completion releases exactly one successor" \
  || { bad "successor was not released after predecessor completion"; cat "$TR/last.log"; }

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
b1="$(job_body "$BARE_E" "$first_e")"
b2="$(job_body "$BARE_E" "$second_e")"
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
printf '%s' "$body_b" | grep -q '^# Repair Ironhorse engine defect ' \
  && printf '%s' "$body_b" | grep -q 'incorrect behaviour or abort' \
  && ok "repair body frames the work as an engine correctness defect" \
  || bad "repair body is missing the correctness-defect framing"
if printf '%s' "$body_b" | grep -Eiq '\b(crash|untrusted|panic|attack|adversarial|exploit)\b'; then
  bad "repair body retains offensive-security vocabulary"
else
  ok "repair body omits offensive-security vocabulary"
fi

# ============================================================================
hr; echo "L — a failed release remains queued and retries on a later tick"; hr
BARE_L="$TR/l.git"; seed_bare "$BARE_L"
SEED_L="$TR/seed-l"; mkdir -p "$SEED_L/parser"; printf 'RETRY-ME' > "$SEED_L/parser/c1"
run_svc "$TR/state-l" "$BARE_L" "$SEED_L" GARDEN_IRONHORSE_FUZZ_POST="$FAILPOST"
fid_l="$(finding_ids "$BARE_L" | head -n1)"
[ -n "$fid_l" ] && [ "$(todo_count "$BARE_L")" -eq 0 ] \
  && ok "failed post leaves the finding durable and unreleased" \
  || bad "failed post did not preserve a queued finding"
rm -f "$SEED_L/parser/c1"
run_svc "$TR/state-l" "$BARE_L" "$SEED_L"
board_has "$BARE_L" "ironhorse-fuzz-${fid_l}-repair" \
  && ok "later tick releases the queued finding without rediscovery dependence" \
  || { bad "later tick did not retry the queued repair"; cat "$TR/last.log"; }

# ============================================================================
hr; echo "M — shared runner outage is a durable, edge-triggered episode"; hr
BARE_M="$TR/m.git"; seed_bare "$BARE_M"
SEED_M="$TR/seed-m"; mkdir -p "$SEED_M"
RUN_LOG_M="$TR/m-runs.log"
run_svc "$TR/state-m" "$BARE_M" "$SEED_M" STUB_RUN_RC=2 STUB_RUN_LOG="$RUN_LOG_M" \
  STUB_RUN_DIAGNOSTIC='first setup failure detail' GARDEN_IRONHORSE_FUZZ_SHARED_RETRY_SECS=99999
[ "$(wc -l < "$RUN_LOG_M")" -eq 1 ] \
  && ok "first shared rc=2 skips every remaining target" \
  || bad "shared outage invoked $(wc -l < "$RUN_LOG_M") runners instead of one"
[ "$(grep -c 'WARN: shared fuzz campaign setup unavailable' "$TR/last.log" || true)" -eq 1 ] \
  && ok "shared outage emits one warning" || bad "shared outage warning was not deduplicated"
cooldown="$TR/state-m/ihf/shared-runner-cooldown"
now="$(date +%s)"; retry_after="$(sed -n 's/^retry_after: *//p' "$cooldown")"
[ -s "$cooldown" ] && [ "$retry_after" -gt "$now" ] && [ "$retry_after" -le $((now + 3600)) ] \
  && ok "shared retry cooldown persisted and was clamped to one hour" \
  || bad "shared retry cooldown missing or outside its bound"
started_at="$(sed -n 's/^started_at: *//p' "$cooldown")"
grep -q '^consecutive_failures: 1$' "$cooldown" \
  && grep -q 'first setup failure detail' "$TR/state-m/ihf/logs/shared-runner-outage.log" \
  && ok "outage latch records its start, failure count, and bounded diagnostic snapshot" \
  || bad "outage episode metadata or diagnostics were not persisted"
run_svc "$TR/state-m" "$BARE_M" "$SEED_M" STUB_RUN_RC=2 STUB_RUN_LOG="$RUN_LOG_M"
[ "$(wc -l < "$RUN_LOG_M")" -eq 1 ] \
  && ok "active cooldown invokes no runner" || bad "active cooldown retried a runner"
grep -q 'shared runner cooldown active' "$TR/last.log" \
  && ! grep -q 'WARN: shared fuzz campaign setup unavailable' "$TR/last.log" \
  && ok "cooldown tick is quiet apart from one status line" \
  || bad "cooldown tick repeated the outage warning"
sed -i 's/^retry_after:.*/retry_after: 2/' "$cooldown"
run_svc "$TR/state-m" "$BARE_M" "$SEED_M" STUB_RUN_RC=2 STUB_RUN_LOG="$RUN_LOG_M" \
  STUB_RUN_DIAGNOSTIC='second setup failure detail' GARDEN_IRONHORSE_FUZZ_SHARED_RETRY_SECS=1
[ "$(wc -l < "$RUN_LOG_M")" -eq 2 ] \
  && ! grep -q 'WARN: shared fuzz campaign setup unavailable' "$TR/last.log" \
  && grep -q 'consecutive failure #2' "$TR/last.log" \
  && grep -q '^consecutive_failures: 2$' "$cooldown" \
  && grep -q "^started_at: $started_at$" "$cooldown" \
  && grep -q 'second setup failure detail' "$TR/state-m/ihf/logs/shared-runner-outage.log" \
  && ok "expired cooldown retries once, retains the episode, and does not repeat the warning" \
  || bad "expired cooldown did not re-arm the shared setup probe"
sed -i 's/^retry_after:.*/retry_after: 2/' "$cooldown"
run_svc "$TR/state-m" "$BARE_M" "$SEED_M" STUB_RUN_RC=0 STUB_RUN_LOG="$RUN_LOG_M"
[ ! -e "$cooldown" ] \
  && [ "$(grep -c 'shared fuzz campaign setup recovered' "$TR/last.log" || true)" -eq 1 ] \
  && grep -q '2 consecutive rc=2 failure(s)' "$TR/last.log" \
  && grep -q 'second setup failure detail' "$TR/state-m/ihf/logs/shared-runner-outage.log" \
  && ok "first successful probe clears the latch and emits one duration/count recovery summary" \
  || bad "shared outage recovery did not clear and summarize exactly once"
run_svc "$TR/state-m" "$BARE_M" "$SEED_M" STUB_RUN_RC=0 STUB_RUN_LOG="$RUN_LOG_M"
[ "$(grep -c 'shared fuzz campaign setup recovered' "$TR/last.log" || true)" -eq 0 ] \
  && ok "later healthy ticks emit no duplicate recovery summary" \
  || bad "healthy tick repeated the recovery summary"

# ============================================================================
hr; echo "N — runner reserves rc=2 for shared setup failures"; hr
PROJ_N="$TR/project-n"; ORIGIN_N="$TR/project-n.git"; SEED_N="$TR/project-seed-n"
git init -q --bare "$ORIGIN_N"
git init -q "$SEED_N"; git -C "$SEED_N" checkout -q -b llm
mkdir -p "$SEED_N/rust/engine/ironhorse-fuzz/fuzz"
touch "$SEED_N/rust/engine/ironhorse-fuzz/fuzz/.gitkeep"
git -C "$SEED_N" add -A; git -C "$SEED_N" "${git_id[@]}" commit -q -m seed
git -C "$SEED_N" remote add origin "$ORIGIN_N"; git -C "$SEED_N" push -q -u origin llm
git clone -q --single-branch --branch llm "$ORIGIN_N" "$PROJ_N"
FAKEBIN_N="$TR/fakebin-n"; mkdir -p "$FAKEBIN_N"
FAKECARGO_N="$FAKEBIN_N/cargo"
printf '%s\n' '#!/bin/bash' 'case " $* " in *" --help "*) exit 0 ;; *) exit 2 ;; esac' > "$FAKECARGO_N"
chmod +x "$FAKECARGO_N"
mkdir -p "$TR/home-n"
rc_n=0
env HOME="$TR/home-n" GARDEN_TEST=1 GARDEN_STATE="$TR/state-n" GARDEN_ROOT="$TR/root-n" \
  GARDEN_IRONHORSE_FUZZ_STATE="$TR/state-n/ihf" \
  GARDEN_IRONHORSE_FUZZ_PROJECT_DIR="$PROJ_N" \
  GARDEN_IRONHORSE_FUZZ_SUBMODULE=. PATH="$FAKEBIN_N:$PATH" \
  "$JOBS/handlers/ironhorse-fuzz-run-gh.sh" parser "$TR/corpus-n" "$TR/arts-n" 1 \
  >"$TR/runner-n.log" 2>&1 || rc_n=$?
[ "$rc_n" -eq 1 ] \
  && ok "target cargo rc=2 is remapped to target-specific rc=1" \
  || { bad "target cargo rc=2 escaped as rc=$rc_n"; cat "$TR/runner-n.log"; }

# ============================================================================
hr; echo "O — corrupt checkout recovery quarantines only the disposable project cache"; hr
PROJ_O="$TR/project-o"; ORIGIN_O="$TR/project-o.git"; SEED_O="$TR/project-seed-o"
git init -q --bare "$ORIGIN_O"
git init -q "$SEED_O"; git -C "$SEED_O" checkout -q -b llm
mkdir -p "$SEED_O/rust/engine/ironhorse-fuzz/fuzz"
touch "$SEED_O/rust/engine/ironhorse-fuzz/fuzz/.gitkeep"
git -C "$SEED_O" add -A; git -C "$SEED_O" "${git_id[@]}" commit -q -m seed
git -C "$SEED_O" remote add origin "$ORIGIN_O"; git -C "$SEED_O" push -q -u origin llm
git clone -q --single-branch --branch llm "$ORIGIN_O" "$PROJ_O"
ROOT_O="$TR/root-o"; mkdir -p "$ROOT_O/worktrees"
ln -s "$ORIGIN_O" "$ROOT_O/worktrees/endojs-endo-but-for-bots.git"
FAKEBIN_O="$TR/fakebin-o"; mkdir -p "$FAKEBIN_O"
FETCH_COUNT_O="$TR/fetch-count-o"
FAKEGIT_O="$FAKEBIN_O/git"
printf '%s\n' \
  '#!/bin/bash' \
  'real_git=/usr/bin/git' \
  'if [ "${3:-}" = fetch ]; then' \
  '  n=0; [ ! -f "$FETCH_COUNT_O" ] || n="$(cat "$FETCH_COUNT_O")"' \
  '  n=$((n + 1)); printf "%s\n" "$n" > "$FETCH_COUNT_O"' \
  '  if [ "$n" -eq 1 ]; then echo "fatal: pack has unresolved deltas" >&2; exit 128; fi' \
  '  exec "$real_git" -C "$2" fetch --quiet "$ORIGIN_O" llm' \
  'fi' \
  'exec "$real_git" "$@"' > "$FAKEGIT_O"
chmod +x "$FAKEGIT_O"
FAKECARGO_O="$FAKEBIN_O/cargo"
printf '%s\n' '#!/bin/bash' 'exit 0' > "$FAKECARGO_O"; chmod +x "$FAKECARGO_O"
STATE_O="$TR/state-o"; mkdir -p "$STATE_O/ihf/corpus"
printf 'persistent-corpus' > "$STATE_O/ihf/corpus/sentinel"
rc_o=0
env HOME="$TR/home-n" GARDEN_TEST=1 GARDEN_STATE="$STATE_O" GARDEN_ROOT="$ROOT_O" \
  GARDEN_IRONHORSE_FUZZ_STATE="$STATE_O/ihf" \
  GARDEN_IRONHORSE_FUZZ_PROJECT_DIR="$PROJ_O" \
  GARDEN_IRONHORSE_FUZZ_SUBMODULE=. PATH="$FAKEBIN_O:$PATH" \
  FETCH_COUNT_O="$FETCH_COUNT_O" ORIGIN_O="$ORIGIN_O" \
  "$JOBS/handlers/ironhorse-fuzz-run-gh.sh" parser "$STATE_O/ihf/corpus/parser" "$TR/arts-o" 1 \
  >"$TR/runner-o.log" 2>&1 || rc_o=$?
quarantine_o="$(find "$TR" -maxdepth 1 -type d -name 'project-o.corrupt-*' -print -quit)"
[ "$rc_o" -eq 0 ] && [ "$(cat "$FETCH_COUNT_O")" -eq 2 ] && [ -d "$PROJ_O/.git" ] \
  && [ -n "$quarantine_o" ] && [ -d "$quarantine_o/.git" ] \
  && ok "object-corruption signature quarantines the checkout and retries provisioning exactly once" \
  || { bad "corruption recovery failed (rc=$rc_o fetches=$(cat "$FETCH_COUNT_O" 2>/dev/null || echo 0) quarantine=$quarantine_o)"; cat "$TR/runner-o.log"; }
[ "$(cat "$STATE_O/ihf/corpus/sentinel")" = persistent-corpus ] \
  && ok "corruption recovery preserves the persistent corpus outside the project cache" \
  || bad "corruption recovery touched the persistent corpus"
grep -q 'Git object corruption detected' "$TR/runner-o.log" \
  && ok "corruption recovery is diagnosed in the runner log" \
  || bad "corruption recovery did not log its diagnosis"

# ============================================================================
hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
