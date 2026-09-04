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
#   B. one reproduced finding → exactly one bounded TRIAGE job (not a per-finding repair) + marker + artifact
#   C. repeat-finding dedup — the SAME crash on the next tick posts NO duplicate (journal marker)
#   D. restart/resume — a fresh state dir but a surviving journal marker still dedups (host-loss safe)
#   E. two DISTINCT findings → two markers, but only one live triage job; completing it releases the next target's
#   F. a crash that does NOT reproduce (reproducer says flake) → no job, no marker
#   G. bounded artifact — an input over the byte cap → marker recorded with base64 OMITTED, job still posted
#   H. batching — genuine findings cluster into one cluster repair that adopts the standing PR + cites its cluster record
#   I. post-merge rollover — a MERGED standing PR bumps the generation; the next triage job targets gen 2
#   J. first-run init — standing.md is created on a virgin journal
#   K. untrusted-data — raw bytes stay out of the triage + cluster bodies; wording uses a correctness/robustness register
#   L. failed release — the durable marker remains queued (untriaged) and a later tick retries the triage
#   M. shared runner outage — retries persist one episode, warn on its edge, and summarize recovery once
#   N. runner exit contract — a target run's own rc=2 is remapped to target-specific rc=1
#   O. corrupt checkout recovery — quarantine only the project cache and retry provisioning once
#   P. unbounded-subprocess guard — a stuck cargo build+run is bounded by `timeout` and remapped to rc=1
#   Q. hysteretic backpressure band — high water stops fuzzing; resume only below low water (the only band in the repo)
#   R. doom-signature feedback — N same-signature dooms from one target stop that target's release, depth-independent
#   S. legacy-backlog migration CAS op — supersede old-shape repairs + seed triage records; idempotent; fail-closed
#   T. paused-lane guard — the fuzz unit stays in EXCLUDED_UNITS until a deliberate two-part re-arm
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
finding_target() {  # finding_target <bare> <fid>
  jfile "$1" "ironhorse-fuzz/findings/$2.md" | sed -n 's/^target: *//p' | head -n1
}
board_has_prefix() {  # board_has_prefix <bare> <base-prefix> — any job whose base starts with prefix
  local v rc=1 s f; v="$(mktemp -d "$TR/bp.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  for s in plan todo doin tada; do
    for f in "$v/jobs/$s/$2"*.md; do [ -e "$f" ] && rc=0; done
  done
  rm -rf "$v"; return $rc
}
board_base_with_prefix() {  # echo the first job base matching a prefix (todo/doin/plan)
  local v s f; v="$(mktemp -d "$TR/bwp.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  for s in todo doin plan; do
    for f in "$v/jobs/$s/$2"*.md; do [ -e "$f" ] && { basename "$f" .md; rm -rf "$v"; return 0; }; done
  done
  rm -rf "$v"; return 1
}
seed_finding() {  # seed_finding <bare> <fid> <target> [gen]
  local bare="$1" fid="$2" target="$3" gen="${4:-1}" f; f="$(mktemp)"
  { printf 'finding_id: %s\n' "$fid"; printf 'target: %s\n' "$target"
    printf 'project_sha: deadbeef\n'; printf 'toolchain: nightly-test\n'
    printf 'artifact_sha256: %064d\n' 0; printf 'artifact_bytes: 3\n'
    printf 'repro_command: cargo fuzz run %s <input>\n' "$target"
    printf 'generation: %s\n' "$gen"; printf 'branch: ironhorse-fuzz-findings\n'
    printf 'marker_base: ironhorse-fuzz-findings\n'; printf 'repair_base: ironhorse-fuzz-%s-repair\n' "$fid"
    printf 'artifact_path: /dev/null\n'; printf 'input_base64: QQ==\n'; } > "$f"
  jput "$bare" "ironhorse-fuzz/findings/$fid.md" "$f"; rm -f "$f"
}
del_finding() {  # del_finding <bare> <fid>
  local bare="$1" fid="$2" w; w="$(mktemp -d "$TR/df.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$bare" "$w" 2>/dev/null
  git -C "$w" rm -q -- "ironhorse-fuzz/findings/$fid.md" >/dev/null 2>&1 || rm -f "$w/ironhorse-fuzz/findings/$fid.md"
  git -C "$w" add -A; git -C "$w" "${git_id[@]}" commit -q -m "del $fid"; git -C "$w" push -q origin "$BRANCH"; rm -rf "$w"
}
seed_triage() {  # seed_triage <bare> <fid> <status> [root_signature]
  local bare="$1" fid="$2" status="$3" rootsig="${4:-}" f; f="$(mktemp)"
  { printf 'schema: 1\n'; printf 'finding_id: %s\n' "$fid"; printf 'status: %s\n' "$status"
    [ -n "$rootsig" ] && printf 'root_signature: %s\n' "$rootsig"; } > "$f"
  jput "$bare" "ironhorse-fuzz/triage/$fid.md" "$f"; rm -f "$f"
}
seed_doomed() {  # seed_doomed <bare> <base> <target> <signature>
  local bare="$1" base="$2" target="$3" sig="$4" f; f="$(mktemp)"
  { printf '%s\n' '---'; printf 'gate: go-ahead\n'; printf 'role: builder\n'
    printf 'doomed: true\n'; printf 'doom_signature: %s\n' "$sig"; printf '%s\n' '---'
    printf '<!-- ironhorse-fuzz-target: %s -->\n' "$target"
    printf 'quarantined %s\n' "$base"; } > "$f"
  jput "$bare" "jobs/plan/$base.md" "$f"; rm -f "$f"
}
# run_migrate <state> <bare>
run_migrate() {
  local state="$1" bare="$2"; shift 2
  env -i HOME="$HOME" PATH="$PATH" GARDEN_TEST=1 \
      GARDEN_STATE="$state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN="testhost" GARDEN_LEADER="testhost" \
      GARDEN_IRONHORSE_FUZZ_STATE="$state/ihf" GARDEN_BACKOFF_BASE_MS=0 \
      "$@" "$JOBS/ironhorse-fuzz-migrate-backlog.sh" >"$TR/migrate.log" 2>&1
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
hr; echo "B — one reproduced finding → one TRIAGE job + marker + durable artifact"; hr
BARE_B="$TR/b.git"; seed_bare "$BARE_B"
SEED_B="$TR/seed-b"; mkdir -p "$SEED_B/parser"; printf 'HELLO-CRASH-B' > "$SEED_B/parser/c1"
run_svc "$TR/state-b" "$BARE_B" "$SEED_B"
[ "$(todo_count "$BARE_B")" -eq 1 ] && ok "exactly one job released (triage, not per-finding repair)" || { bad "expected 1 job, got $(todo_count "$BARE_B")"; cat "$TR/last.log"; }
fid_b="$(finding_ids "$BARE_B" | head -n1)"
[ -n "$fid_b" ] && ok "finding marker recorded ($fid_b)" || bad "no finding marker"
board_has_prefix "$BARE_B" "ironhorse-fuzz-triage-parser-" && ok "a bounded triage job was released for the target" || bad "no triage job on the board"
board_has "$BARE_B" "ironhorse-fuzz-${fid_b}-repair" && bad "released a legacy per-finding repair (should be triage first)" || ok "no per-finding repair released (capture→triage, not capture→repair)"
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
hr; echo "E — two distinct findings retained; triage jobs serialized one at a time"; hr
BARE_E="$TR/e.git"; seed_bare "$BARE_E"
SEED_E="$TR/seed-e"; mkdir -p "$SEED_E/parser" "$SEED_E/bytecode_decoder"
printf 'DISTINCT-ONE'   > "$SEED_E/parser/c1"
printf 'DISTINCT-TWO-X' > "$SEED_E/bytecode_decoder/c1"
run_svc "$TR/state-e" "$BARE_E" "$SEED_E"
[ "$(finding_ids "$BARE_E" | wc -l)" -eq 2 ] && ok "two distinct finding markers" || bad "expected 2 markers"
[ "$(todo_count "$BARE_E")" -eq 1 ] && ok "only one triage job released while both findings remain durable" || { bad "expected 1 live triage job, got $(todo_count "$BARE_E")"; cat "$TR/last.log"; }
# The producer batches by target and releases the target owning the lexically-first
# pending marker; the other target waits behind the single-live-triage rule.
first_fid_e="$(finding_ids "$BARE_E" | sed -n 1p)"
first_target_e="$(finding_target "$BARE_E" "$first_fid_e")"
[ "$first_target_e" = parser ] && other_target_e=bytecode_decoder || other_target_e=parser
board_has_prefix "$BARE_E" "ironhorse-fuzz-triage-${first_target_e}-" && ok "triage released for the oldest pending target ($first_target_e)" || bad "first triage was not released"
if board_has_prefix "$BARE_E" "ironhorse-fuzz-triage-${other_target_e}-"; then bad "second target's triage released before the first completed"; else ok "second target's triage withheld while one triage is live"; fi
run_svc "$TR/state-e" "$BARE_E" "$SEED_E"
[ "$(todo_count "$BARE_E")" -eq 1 ] && ok "next tick still holds at one live triage job" || bad "live job count changed before completion"
# Simulate the triage job classifying its member and completing.
triage_base_e="$(board_base_with_prefix "$BARE_E" "ironhorse-fuzz-triage-${first_target_e}-")"
seed_triage "$BARE_E" "$first_fid_e" pending
complete_job "$BARE_E" "$triage_base_e"
run_svc "$TR/state-e" "$BARE_E" "$SEED_E"
board_has_prefix "$BARE_E" "ironhorse-fuzz-triage-${other_target_e}-" \
  && ok "completing the first triage releases exactly one successor (other target)" \
  || { bad "successor triage was not released after completion"; cat "$TR/last.log"; }

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
hr; echo "H — genuine findings batch into one cluster repair that adopts the standing PR"; hr
BARE_H="$TR/h.git"; seed_bare "$BARE_H"
SEED_H="$TR/seed-h"; mkdir -p "$SEED_H/parser"; printf 'CLUSTER-CASE-H' > "$SEED_H/parser/c1"
run_svc "$TR/state-h" "$BARE_H" "$SEED_H"                 # tick 1: capture → triage job
fid_h="$(finding_ids "$BARE_H" | head -n1)"
triage_h="$(board_base_with_prefix "$BARE_H" "ironhorse-fuzz-triage-parser-")"
seed_triage "$BARE_H" "$fid_h" genuine sigH               # triage says: genuine, root sig sigH
complete_job "$BARE_H" "$triage_h"
run_svc "$TR/state-h" "$BARE_H" "$SEED_H"                 # tick 2: batcher → cluster repair
cluster_h="$(board_base_with_prefix "$BARE_H" "ironhorse-fuzz-parser-")"
[ -n "$cluster_h" ] && ok "one cluster repair released for the genuine finding ($cluster_h)" || { bad "no cluster repair released"; cat "$TR/last.log"; }
bh="$(job_body "$BARE_H" "$cluster_h")"
printf '%s' "$bh" | grep -q 'ensure-pr.sh ironhorse-fuzz-findings ' && ok "cluster repair adopts the standing marker_base" || bad "cluster repair does not target the standing PR"
printf '%s' "$bh" | grep -q 'garden-job: ironhorse-fuzz-findings -->' && ok "cluster body cites the durable adoption marker" || bad "no adoption marker in cluster body"
printf '%s' "$bh" | grep -q "cluster record: \`ironhorse-fuzz/clusters/" -i && ok "cluster body cites its durable cluster record" || bad "cluster body missing cluster record reference"
[ -n "$(jfile "$BARE_H" "ironhorse-fuzz/clusters/$(printf '%s' "$cluster_h" | sed 's/ironhorse-fuzz-parser-//; s/-repair//').md")" ] && ok "durable cluster record written to the journal" || bad "no cluster record in journal"

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
triage_i="$(board_base_with_prefix "$BARE_I" "ironhorse-fuzz-triage-parser-")"
printf '%s' "$(job_body "$BARE_I" "$triage_i")" | grep -q 'ironhorse-fuzz-findings-2' \
  && ok "post-rollover triage job targets the gen-2 standing branch" || bad "triage job did not target the new generation"

# ============================================================================
hr; echo "J — first-run init creates standing.md on a virgin journal"; hr
# (BARE_B had no standing seed; the first B tick must have created it.)
printf '%s' "$(jfile "$BARE_B" "ironhorse-fuzz/standing.md")" | grep -q 'generation: 1' \
  && ok "standing.md initialized at generation 1" || bad "standing.md not initialized"

# ============================================================================
hr; echo "K — untrusted-data: raw crash bytes never appear in the triage or cluster body"; hr
triage_b="$(board_base_with_prefix "$BARE_B" "ironhorse-fuzz-triage-parser-")"
body_b="$(job_body "$BARE_B" "$triage_b")"
if printf '%s' "$body_b" | grep -q 'HELLO-CRASH-B'; then bad "raw crash bytes leaked into the triage body"; else ok "raw crash bytes absent from the triage body"; fi
printf '%s' "$body_b" | grep -q 'sha256' && ok "triage body carries sha256 provenance instead" || bad "triage body missing sha256 provenance"
printf '%s' "$body_b" | grep -q 'Ironhorse JS engine port' \
  && printf '%s' "$body_b" | grep -qi 'classify' \
  && ok "triage body frames the work as bounded engine-defect classification" \
  || bad "triage body is missing the classification framing"
for reg in "$body_b" "$bh"; do
  if printf '%s' "$reg" | grep -Eiq '\b(crash|untrusted|panic|attack|adversarial|exploit)\b'; then
    bad "a released body retains offensive-security vocabulary"; reg_bad=1
  fi
done
[ -z "${reg_bad:-}" ] && ok "triage and cluster bodies omit offensive-security vocabulary"

# ============================================================================
hr; echo "L — a failed triage release remains queued and retries on a later tick"; hr
BARE_L="$TR/l.git"; seed_bare "$BARE_L"
SEED_L="$TR/seed-l"; mkdir -p "$SEED_L/parser"; printf 'RETRY-ME' > "$SEED_L/parser/c1"
run_svc "$TR/state-l" "$BARE_L" "$SEED_L" GARDEN_IRONHORSE_FUZZ_POST="$FAILPOST"
fid_l="$(finding_ids "$BARE_L" | head -n1)"
[ -n "$fid_l" ] && [ "$(todo_count "$BARE_L")" -eq 0 ] \
  && ok "failed post leaves the finding durable and unreleased" \
  || bad "failed post did not preserve a queued finding"
rm -f "$SEED_L/parser/c1"
run_svc "$TR/state-l" "$BARE_L" "$SEED_L"
board_has_prefix "$BARE_L" "ironhorse-fuzz-triage-parser-" \
  && ok "later tick releases the queued triage without rediscovery dependence" \
  || { bad "later tick did not retry the queued triage"; cat "$TR/last.log"; }

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
hr; echo "P — a stuck cargo build+run is bounded by timeout and remapped to rc=1"; hr
PROJ_P="$TR/project-p"; ORIGIN_P="$TR/project-p.git"; SEED_P="$TR/project-seed-p"
git init -q --bare "$ORIGIN_P"
git init -q "$SEED_P"; git -C "$SEED_P" checkout -q -b llm
mkdir -p "$SEED_P/rust/engine/ironhorse-fuzz/fuzz"
touch "$SEED_P/rust/engine/ironhorse-fuzz/fuzz/.gitkeep"
git -C "$SEED_P" add -A; git -C "$SEED_P" "${git_id[@]}" commit -q -m seed
git -C "$SEED_P" remote add origin "$ORIGIN_P"; git -C "$SEED_P" push -q -u origin llm
git clone -q --single-branch --branch llm "$ORIGIN_P" "$PROJ_P"
FAKEBIN_P="$TR/fakebin-p"; mkdir -p "$FAKEBIN_P"
FAKECARGO_P="$FAKEBIN_P/cargo"
# --help succeeds (cargo-fuzz "available"); `fuzz run` HANGS to model a stuck build.
printf '%s\n' \
  '#!/bin/bash' \
  'case " $* " in' \
  '  *" --help "*) exit 0 ;;' \
  '  *" fuzz run "*) sleep 120 ;;' \
  '  *) exit 0 ;;' \
  'esac' > "$FAKECARGO_P"
chmod +x "$FAKECARGO_P"
mkdir -p "$TR/home-p"
rc_p=0; t0="$(date +%s)"
env HOME="$TR/home-p" GARDEN_TEST=1 GARDEN_STATE="$TR/state-p" GARDEN_ROOT="$TR/root-p" \
  GARDEN_IRONHORSE_FUZZ_STATE="$TR/state-p/ihf" \
  GARDEN_IRONHORSE_FUZZ_PROJECT_DIR="$PROJ_P" \
  GARDEN_IRONHORSE_FUZZ_SUBMODULE=. \
  GARDEN_IRONHORSE_FUZZ_BUILD_ALLOWANCE_SECS=1 \
  GARDEN_IRONHORSE_FUZZ_KILL_AFTER_SECS=1 \
  PATH="$FAKEBIN_P:$PATH" \
  "$JOBS/handlers/ironhorse-fuzz-run-gh.sh" parser "$TR/corpus-p" "$TR/arts-p" 1 \
  >"$TR/runner-p.log" 2>&1 || rc_p=$?
t1="$(date +%s)"; elapsed_p=$((t1 - t0))
[ "$rc_p" -eq 1 ] \
  && ok "a stuck cargo run is bounded and remapped to target-specific rc=1" \
  || { bad "stuck cargo run escaped as rc=$rc_p"; cat "$TR/runner-p.log"; }
[ "$elapsed_p" -lt 30 ] \
  && ok "the bounded run self-terminated in ${elapsed_p}s (well under the sleep 120 and the unit budget)" \
  || bad "the bounded run took ${elapsed_p}s — timeout did not preempt the stuck subprocess"
grep -q 'build+run budget' "$TR/runner-p.log" \
  && ok "the timeout is diagnosed in the runner log" \
  || { bad "the bounded run did not log its budget diagnosis"; cat "$TR/runner-p.log"; }
hr; echo "Q — hysteretic backpressure band (the only one in the repo)"; hr
BARE_BP="$TR/bp.git"; seed_bare "$BARE_BP"
SEED_BP="$TR/seed-bp"; mkdir -p "$SEED_BP/parser"; printf 'BACKPRESSURE-CRASH' > "$SEED_BP/parser/c1"
# Seed 8 nonterminal (untriaged) parser findings — at the per-target high water (8).
for i in 01 02 03 04 05 06 07 08; do seed_finding "$BARE_BP" "aaaaaaaaaaaaaa$i" parser; done
run_svc "$TR/state-bp" "$BARE_BP" "$SEED_BP"
grep -q 'backpressure=stopped' "$TR/last.log" && ok "at/above high water the band stops fuzzing" || { bad "band did not stop at high water"; cat "$TR/last.log"; }
[ "$(finding_ids "$BARE_BP" | grep -c '^aaaaaaaaaaaaaa')" -eq 8 ] && [ "$(finding_ids "$BARE_BP" | wc -l)" -eq 8 ] \
  && ok "no new crash captured while fuzzing is suppressed" || bad "captured a crash despite backpressure stop"
printf '%s' "$(jfile "$BARE_BP" "ironhorse-fuzz/backpressure.md")" | grep -q 'fuzzing: stopped' && ok "backpressure state persisted to the journal" || bad "backpressure state not persisted"
board_has_prefix "$BARE_BP" "ironhorse-fuzz-triage-parser-" && ok "even while stopped it still releases one triage job (drains the backlog)" || bad "no triage release while stopped"
# Hysteresis: drop below low water (3 total, max_target 3 < 4) — resumes.
for i in 04 05 06 07 08; do del_finding "$BARE_BP" "aaaaaaaaaaaaaa$i"; done   # leaves 01..03 = 3
run_svc "$TR/state-bp2" "$BARE_BP" "$SEED_BP"
now_ct="$(finding_ids "$BARE_BP" | grep -c '^aaaaaaaaaaaaaa')"
if [ "$now_ct" -lt 4 ]; then
  grep -q 'backpressure=running' "$TR/last.log" && ok "below low water ($now_ct<4) the band resumes fuzzing" || { bad "band did not resume below low water"; cat "$TR/last.log"; }
  [ "$(finding_ids "$BARE_BP" | wc -l)" -gt "$now_ct" ] && ok "a fresh crash is captured again once resumed" || bad "no capture after resume"
else
  bad "test setup: expected <4 seeded findings after deletion, got $now_ct"
fi

# ============================================================================
hr; echo "R — doom-signature feedback stops a target's release regardless of depth"; hr
BARE_Q="$TR/q.git"; seed_bare "$BARE_Q"
mkdir -p "$TR/seed-empty-q"
seed_finding "$BARE_Q" "cccccccccccccc01" parser
# Positive control: with no dooms, the pending parser finding releases a triage job.
run_svc "$TR/state-q1" "$BARE_Q" "$TR/seed-empty-q"
board_has_prefix "$BARE_Q" "ironhorse-fuzz-triage-parser-" && ok "control: a pending finding releases triage when no dooms" || { bad "control triage did not release"; cat "$TR/last.log"; }
# Now arm 3 same-signature (policy-refusal) dooms attributed to parser (>= stop N=3).
BARE_Q2="$TR/q2.git"; seed_bare "$BARE_Q2"
seed_finding "$BARE_Q2" "dddddddddddddd01" parser
seed_doomed "$BARE_Q2" "ironhorse-fuzz-parser-11111111aaaa-repair" parser policy-refusal
seed_doomed "$BARE_Q2" "ironhorse-fuzz-parser-22222222bbbb-repair" parser policy-refusal
seed_doomed "$BARE_Q2" "ironhorse-fuzz-parser-33333333cccc-repair" parser policy-refusal
run_svc "$TR/state-q2" "$BARE_Q2" "$TR/seed-empty-q"
grep -q "triage release for 'parser' held" "$TR/last.log" && ok "doom feedback holds release for the refusing target" || { bad "doom feedback did not hold release"; cat "$TR/last.log"; }
board_has_prefix "$BARE_Q2" "ironhorse-fuzz-triage-parser-" && bad "released triage for a doom-stopped target" || ok "no triage released for the doom-stopped target"

# ============================================================================
hr; echo "S — legacy-backlog migration CAS op (idempotent, fail-closed)"; hr
BARE_R="$TR/r.git"; seed_bare "$BARE_R"
# Two legacy per-finding repairs (one in plan doomed, one in todo) + markers, plus
# the repromote-quarantined job, plus a finding with no legacy job.
seed_finding "$BARE_R" "1111111111111111" parser
seed_finding "$BARE_R" "2222222222222222" bytecode_decoder
seed_finding "$BARE_R" "3333333333333333" parser
seed_doomed  "$BARE_R" "ironhorse-fuzz-1111111111111111-repair" parser policy-refusal
# a plain todo legacy job (not doomed)
TMPJOB="$TR/legacy-todo.md"; printf '%s\n' '---' 'role: builder' '---' 'legacy repair' > "$TMPJOB"
jput "$BARE_R" "jobs/todo/ironhorse-fuzz-2222222222222222-repair.md" "$TMPJOB"
printf '%s\n' '---' 'role: builder' '---' 'repromote' > "$TMPJOB"
jput "$BARE_R" "jobs/plan/ironhorse-fuzz-repromote-quarantined.md" "$TMPJOB"
run_migrate "$TR/state-r" "$BARE_R" && ok "migration ran and landed" || { bad "migration failed"; cat "$TR/migrate.log"; }
board_has "$BARE_R" "ironhorse-fuzz-1111111111111111-repair" && bad "doomed legacy plan job survived migration" || ok "doomed legacy plan job superseded (removed from claimable states)"
board_has "$BARE_R" "ironhorse-fuzz-2222222222222222-repair" && bad "legacy todo job survived migration" || ok "legacy todo job superseded"
board_has "$BARE_R" "ironhorse-fuzz-repromote-quarantined" && bad "repromote-quarantined survived migration" || ok "repromote-quarantined superseded (never promoted one by one)"
[ -n "$(finding_ids "$BARE_R" | grep -c 1111111111111111)" ] && [ "$(finding_ids "$BARE_R" | wc -l)" -eq 3 ] && ok "all finding markers preserved (no finding lost)" || bad "a finding marker was lost"
man="$(jfile "$BARE_R" "ironhorse-fuzz/migrations/triage-batch-v1.md")"
printf '%s' "$man" | grep -q 'migration: triage-batch-v1' && printf '%s' "$man" | grep -q 'superseded-by-triage-batch' && ok "manifest records the basename→finding mapping and disposition" || bad "manifest incomplete"
for fid in 1111111111111111 2222222222222222 3333333333333333; do
  printf '%s' "$(jfile "$BARE_R" "ironhorse-fuzz/triage/$fid.md")" | grep -q 'status: pending' || { bad "no seeded triage record for $fid"; seedfail=1; }
done
[ -z "${seedfail:-}" ] && ok "every unresolved marker got a seeded pending triage record"
# Idempotency: a rerun makes no further changes.
head_before="$(git ls-remote "$BARE_R" "refs/heads/$BRANCH" | cut -f1)"
run_migrate "$TR/state-r2" "$BARE_R"
head_after="$(git ls-remote "$BARE_R" "refs/heads/$BRANCH" | cut -f1)"
[ "$head_before" = "$head_after" ] && ok "migration rerun is a no-op (idempotent)" || { bad "migration rerun mutated the journal"; cat "$TR/migrate.log"; }
# Fail-closed: a legacy job whose finding marker is missing refuses the migration.
BARE_R3="$TR/r3.git"; seed_bare "$BARE_R3"
printf '%s\n' '---' 'role: builder' '---' 'orphan' > "$TMPJOB"
jput "$BARE_R3" "jobs/plan/ironhorse-fuzz-9999999999999999-repair.md" "$TMPJOB"
rc_r3=0; run_migrate "$TR/state-r3" "$BARE_R3" || rc_r3=$?
[ "$rc_r3" -ne 0 ] && grep -q 'FAIL-CLOSED' "$TR/migrate.log" && ok "migration fails closed on a legacy job with no finding marker" || { bad "migration did not fail closed on a missing marker"; cat "$TR/migrate.log"; }

# ============================================================================
hr; echo "T — the lane stays paused (EXCLUDED_UNITS) until deliberately re-armed"; hr
grep -q 'garden-ironhorse-fuzz.timer' "$JOBS/install-units.sh" \
  && grep -q 'garden-ironhorse-fuzz.service' "$JOBS/install-units.sh" \
  && ok "garden-ironhorse-fuzz is still in EXCLUDED_UNITS (lane paused)" \
  || bad "the fuzz lane is no longer excluded — it must stay paused"

# ============================================================================
hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
