#!/bin/bash
# ironhorse-fuzz.sh — the continuous Ironhorse libFuzzer campaign, off the PR
# critical path. A deterministic, leader-only, no-LLM background producer that drives
# a BOUNDED increment of the fuzz campaign each tick against a PERSISTENT corpus, and
# turns every distinct reproducible crash into one durable, deduplicated REPAIR JOB
# that creates-or-amends ONE standing bot-fork pull request (case + fix).
#
# Design: designs/continuous-ironhorse-fuzz.md. Directive: kriskowal on
# endojs/endo-but-for-bots#1046 (comment 5446442895) — "move the fuzzer out of CI and
# drive it continuously in the background from a new garden service; we should have a
# standing pull request that is created or amended for each ironhorse fuzz case and
# solution."
#
# ── Shape ───────────────────────────────────────────────────────────────────
# Type=oneshot timer tick, like every other leader-only singleton. Each tick runs a
# bounded fuzz increment (per-target -max_total_time) over a corpus that PERSISTS in
# $GARDEN_STATE between ticks; "continuous" is the timer firing forever over the same
# growing corpus, not one endless process. oneshot is the concurrency guard (no second
# tick starts while one is active); the leader-only ExecCondition keeps two hosts off
# the same campaign; every journal write is a CAS push, so a restart or a leader
# handoff never loses or duplicates a finding.
#
# ── Untrusted data (load-bearing) ───────────────────────────────────────────
# A crash input is adversarial bytes BY CONSTRUCTION. This script NEVER interpolates
# crash bytes into a shell command or an LLM prompt: crash files are passed to the
# fuzzer BY PATH; the stable finding identity is an inert hex sha256; the repair-job
# body carries only bounded metadata (target from a fixed allowlist, project SHA,
# toolchain, options, artifact sha256 + durable path, exact repro command) plus the
# minimized input as an INERT base64 blob the repair job decodes to disk. No eval, no
# word-split of artifact content, ever.
#
# ── Seams (all GARDEN_* overridable; this is what makes the tick hermetically
#     testable, mirroring pages-watcher.sh's GARDEN_PAGES_SOURCE/POST) ─────────
#   GARDEN_IRONHORSE_FUZZ_CLONE      journal clone dir   (default $GARDEN_STATE/ironhorse-fuzz/journal)
#   GARDEN_IRONHORSE_FUZZ_STATE      durable state root  (default $GARDEN_STATE/ironhorse-fuzz)
#   GARDEN_IRONHORSE_FUZZ_RUNNER     run one bounded increment; drop crashes into artifacts dir
#                                    (default handlers/ironhorse-fuzz-run-gh.sh)
#       runner <target> <corpus-dir> <artifacts-dir> <seconds>  -> exit 0 clean / 77 crash / other error
#   GARDEN_IRONHORSE_FUZZ_MINIMIZER  minimize a crash input
#       minimizer <target> <in-file> <out-file>  -> writes minimized bytes (falls back to a copy)
#   GARDEN_IRONHORSE_FUZZ_REPRODUCER confirm a crash still reproduces
#       reproducer <target> <in-file>  -> exit 0 reproduces / nonzero does not
#   GARDEN_IRONHORSE_FUZZ_SHA_CMD     echo the project SHA under fuzz    (default handlers/ironhorse-fuzz-sha-gh.sh)
#   GARDEN_IRONHORSE_FUZZ_PR_STATE    echo OPEN|MERGED|CLOSED|NONE for the standing PR
#                                    (default handlers/ironhorse-fuzz-pr-state-gh.sh <repo> <marker-base> <author>)
#   GARDEN_IRONHORSE_FUZZ_POST        post-job seam       (default post-job.sh)
#   GARDEN_IRONHORSE_FUZZ_TARGETS     space-separated target allowlist (default: the 9 maintained targets)
#   GARDEN_IRONHORSE_FUZZ_SECS        per-target seconds  (default 60)
#   GARDEN_IRONHORSE_FUZZ_REPO        bot fork owner/name (default endojs/endo-but-for-bots)
#   GARDEN_IRONHORSE_FUZZ_BASE_BRANCH standing-PR base    (default llm)
#   GARDEN_IRONHORSE_FUZZ_BRANCH_STEM standing branch stem (default ironhorse-fuzz-findings)
#   GARDEN_IRONHORSE_FUZZ_TOOLCHAIN   pinned nightly      (default nightly-2026-08-15)
#   GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES  cap on a handled/embedded crash input (default 1048576)
#   GARDEN_IRONHORSE_FUZZ_CORPUS_MAX_MB       per-target corpus size cap (default 256)
#   GARDEN_IRONHORSE_FUZZ_MAX_FINDINGS_PER_TICK  bound work per tick (default 8)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="ironhorse-fuzz"

: "${GARDEN_IRONHORSE_FUZZ_STATE:=$GARDEN_STATE/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_CLONE:=$GARDEN_IRONHORSE_FUZZ_STATE/journal}"
: "${GARDEN_IRONHORSE_FUZZ_RUNNER:=$HERE/handlers/ironhorse-fuzz-run-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_MINIMIZER:=$HERE/handlers/ironhorse-fuzz-minimize-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_REPRODUCER:=$HERE/handlers/ironhorse-fuzz-reproduce-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_SHA_CMD:=$HERE/handlers/ironhorse-fuzz-sha-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_PR_STATE:=$HERE/handlers/ironhorse-fuzz-pr-state-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_POST:=$HERE/post-job.sh}"
: "${GARDEN_IRONHORSE_FUZZ_TARGETS:=differential_source bytecode_decoder differential_stage2b differential_regexp differential_regexp_surface parser differential_compile snapshot_roundtrip snapshot_decoder}"
: "${GARDEN_IRONHORSE_FUZZ_SECS:=60}"
: "${GARDEN_IRONHORSE_FUZZ_REPO:=endojs/endo-but-for-bots}"
: "${GARDEN_IRONHORSE_FUZZ_BASE_BRANCH:=llm}"
: "${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM:=ironhorse-fuzz-findings}"
: "${GARDEN_IRONHORSE_FUZZ_TOOLCHAIN:=nightly-2026-08-15}"
: "${GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES:=1048576}"
: "${GARDEN_IRONHORSE_FUZZ_CORPUS_MAX_MB:=256}"
: "${GARDEN_IRONHORSE_FUZZ_MAX_FINDINGS_PER_TICK:=8}"
: "${GARDEN_IRONHORSE_FUZZ_BOT_LOGIN:=${GARDEN_BOT_LOGIN:-kriscendobot}}"

require_tools git sha256sum

fleet_draining && { log "fleet draining; skipping"; exit 0; }

STATE="$GARDEN_IRONHORSE_FUZZ_STATE"
CLONE="$GARDEN_IRONHORSE_FUZZ_CLONE"
CORPUS_ROOT="$STATE/corpus"
FINDINGS_ROOT="$STATE/findings"
LOGS_ROOT="$STATE/logs"
mkdir -p "$STATE" "$CORPUS_ROOT" "$FINDINGS_ROOT" "$LOGS_ROOT"

ensure_clone "$CLONE"
sync_clone "$CLONE"

JSTANDING="ironhorse-fuzz/standing.md"
jshow() {  # jshow <journal2-relative-path> -> file content on stdout (empty if absent)
  git -C "$CLONE" show "origin/$JOURNAL_BRANCH:$1" 2>/dev/null || true
}
field() {  # field <text> <key> -> value of "key: value" (first match)
  printf '%s\n' "$1" | sed -n "s/^$2: *//p" | head -n1
}

# --- validate a target against the fixed allowlist (never trust dynamic input) ---
declare -A ALLOWED=()
for _t in $GARDEN_IRONHORSE_FUZZ_TARGETS; do ALLOWED["$_t"]=1; done
is_allowed_target() { [ -n "${ALLOWED[$1]:-}" ]; }

# --- CAS-write a small file into the journal (whole-file) --------------------
# Mirrors land-journal-edit.sh's loop but confined to our ironhorse-fuzz/ subtree so
# the service is self-contained and hermetically testable against a bare-repo stub.
journal_put() {  # journal_put <journal2-relative-path> <src-file> <commit-msg>
  local rel="$1" src="$2" msg="$3" attempt
  for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
    sync_clone "$CLONE"
    mkdir -p "$CLONE/$(dirname "$rel")"
    cp "$src" "$CLONE/$rel"
    git -C "$CLONE" add -- "$rel" >/dev/null 2>&1 || true
    local rc=0; commit_and_push "$CLONE" "$msg" || rc=$?
    case "$rc" in
      0|2) return 0 ;;               # landed, or nothing-to-commit (already present)
      *)   backoff "$attempt" ;;      # push race / transient — re-sync and retry
    esac
  done
  return 1
}

# ─────────────────────────────────────────────────────────────────────────────
# 1. Standing-PR lifecycle: load, and roll over after a merge/close.
# ─────────────────────────────────────────────────────────────────────────────
standing_txt="$(jshow "$JSTANDING")"
gen="$(field "$standing_txt" generation)"; gen="${gen:-1}"
[ "$gen" -ge 1 ] 2>/dev/null || gen=1
st_state="$(field "$standing_txt" state)"; st_state="${st_state:-active}"
st_pr="$(field "$standing_txt" pr_number)"
branch="$(field "$standing_txt" branch)"
marker_base="$(field "$standing_txt" marker_base)"

write_standing() {  # write_standing <generation> <branch> <marker_base> <state> [pr_number] [pr_url]
  local g="$1" br="$2" mb="$3" stt="$4" prn="${5:-}" pru="${6:-}" tmp
  tmp="$(mktemp)"
  {
    printf 'generation: %s\n' "$g"
    printf 'branch: %s\n' "$br"
    printf 'marker_base: %s\n' "$mb"
    printf 'base_branch: %s\n' "$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH"
    printf 'repo: %s\n' "$GARDEN_IRONHORSE_FUZZ_REPO"
    printf 'state: %s\n' "$stt"
    [ -n "$prn" ] && printf 'pr_number: %s\n' "$prn"
    [ -n "$pru" ] && printf 'pr_url: %s\n' "$pru"
    printf 'updated_by: %s\n' "$GARDEN"
  } > "$tmp"
  journal_put "$JSTANDING" "$tmp" "ironhorse-fuzz: standing gen $g ($stt)" || { rm -f "$tmp"; return 1; }
  rm -f "$tmp"
}

# Initialize on first run.
if [ -z "$standing_txt" ]; then
  branch="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}"
  marker_base="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}"
  write_standing "$gen" "$branch" "$marker_base" active || log "WARN: could not initialize standing state (will retry next tick)"
  standing_txt="$(jshow "$JSTANDING")"
  st_state="active"; st_pr=""
fi
[ -n "$branch" ] || branch="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}"
[ -n "$marker_base" ] || marker_base="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}"

# Roll over if a recorded PR has merged or closed. The next finding creates the next
# generation's PR; we do NOT pre-create an empty one.
if [ -n "$st_pr" ] && [ "$st_state" = "active" ]; then
  pr_state="$("$GARDEN_IRONHORSE_FUZZ_PR_STATE" "$GARDEN_IRONHORSE_FUZZ_REPO" "$marker_base" "$GARDEN_IRONHORSE_FUZZ_BOT_LOGIN" 2>/dev/null || echo UNKNOWN)"
  case "$pr_state" in
    MERGED|CLOSED)
      log "standing PR #$st_pr is $pr_state — archiving gen $gen and rolling over"
      archtmp="$(mktemp)"; printf '%s\n' "$standing_txt" > "$archtmp"
      printf 'retired_state: %s\n' "$pr_state" >> "$archtmp"
      journal_put "ironhorse-fuzz/standing-archive/$gen.md" "$archtmp" "ironhorse-fuzz: archive standing gen $gen ($pr_state)" || true
      rm -f "$archtmp"
      gen=$((gen + 1))
      branch="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}-${gen}"
      marker_base="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}-${gen}"
      write_standing "$gen" "$branch" "$marker_base" active || log "WARN: rollover write failed (retry next tick)"
      st_pr=""
      ;;
    OPEN|NONE|UNKNOWN) : ;;   # keep amending / not yet created / transient — no rollover
  esac
fi

log "campaign gen=$gen branch=$branch marker=$marker_base targets=[$GARDEN_IRONHORSE_FUZZ_TARGETS]"

# ─────────────────────────────────────────────────────────────────────────────
# 2. Resolve the project SHA under fuzz (provenance).
# ─────────────────────────────────────────────────────────────────────────────
project_sha="$("$GARDEN_IRONHORSE_FUZZ_SHA_CMD" 2>/dev/null | head -n1 | tr -d '[:space:]' || true)"
[ -n "$project_sha" ] || project_sha="unknown"

# ─────────────────────────────────────────────────────────────────────────────
# 3. Run a bounded fuzz increment per target; collect crash artifacts.
# ─────────────────────────────────────────────────────────────────────────────
ART_ROOT="$(mktemp -d)"
cleanup() { rm -rf "$ART_ROOT" 2>/dev/null || true; }
trap 'cleanup' EXIT
trap 'cleanup; exit 143' TERM
trap 'cleanup; exit 130' INT

posted_this_tick=0

# posted_anywhere <base> — rc 0 if the base exists anywhere in the lifecycle.
posted_anywhere() {
  local base="$1" sub
  for sub in "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN"; do
    git -C "$CLONE" cat-file -e "origin/$JOURNAL_BRANCH:$sub/$base.md" 2>/dev/null && return 0
  done
  tada_find_tree "$CLONE" "origin/$JOURNAL_BRANCH" "$base" >/dev/null 2>&1 && return 0
  return 1
}

handle_finding() {  # handle_finding <target> <crash-file>
  local target="$1" crash="$2"
  is_allowed_target "$target" || { log "WARN: ignoring crash for unknown target '$target'"; return 0; }
  [ -s "$crash" ] || { log "WARN: empty crash file for $target — skipping"; return 0; }

  local sz; sz="$(wc -c < "$crash" | tr -d '[:space:]')"
  if [ "$sz" -gt "$GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES" ]; then
    log "WARN: $target crash input ${sz}B exceeds cap ${GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES}B — recording metadata only, not embedding"
  fi

  # Confirm it still reproduces (never chase a flake). Bounded by the reproducer seam.
  if ! "$GARDEN_IRONHORSE_FUZZ_REPRODUCER" "$target" "$crash" >/dev/null 2>&1; then
    log "$target crash did not reproduce deterministically — discarding (not a finding)"
    return 0
  fi

  # Minimize (stable identity). Fall back to the raw input if the minimizer no-ops.
  local minz; minz="$(mktemp)"
  if ! "$GARDEN_IRONHORSE_FUZZ_MINIMIZER" "$target" "$crash" "$minz" >/dev/null 2>&1 || [ ! -s "$minz" ]; then
    cp "$crash" "$minz"
  fi

  local art_sha fid repair_base
  art_sha="$(sha256sum "$minz" | cut -d' ' -f1)"
  fid="$(printf '%s\0' "$target" | cat - "$minz" | sha256sum | cut -c1-16)"
  repair_base="ironhorse-fuzz-${fid}-repair"

  # Dedup gate 1: journal marker (survives restart AND leader handoff).
  if [ -n "$(jshow "ironhorse-fuzz/findings/$fid.md")" ]; then
    log "finding $fid already recorded — idempotent skip"
    rm -f "$minz"; return 0
  fi
  # Dedup gate 2: board pre-check (belt-and-suspenders with post-job idempotency).
  if posted_anywhere "$repair_base"; then
    log "repair job $repair_base already on the board — idempotent skip"
    rm -f "$minz"; return 0
  fi

  # Persist durable host-local artifact (raw bytes stay on disk, referenced by path).
  local fdir="$FINDINGS_ROOT/$fid"
  mkdir -p "$fdir"
  cp "$minz" "$fdir/input.bin"
  local repro_cmd="cargo +${GARDEN_IRONHORSE_FUZZ_TOOLCHAIN} fuzz run ${target} <input> -- -runs=1"
  {
    printf 'finding_id: %s\n' "$fid"
    printf 'target: %s\n' "$target"
    printf 'project_sha: %s\n' "$project_sha"
    printf 'toolchain: %s\n' "$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN"
    printf 'artifact_sha256: %s\n' "$art_sha"
    printf 'artifact_bytes: %s\n' "$(wc -c < "$minz" | tr -d '[:space:]')"
    printf 'repro_command: %s\n' "$repro_cmd"
    printf 'discovered_by: %s\n' "$GARDEN"
    printf 'generation: %s\n' "$gen"
  } > "$fdir/meta.md"

  # Journal dedup marker + portable provenance. Embed the minimized input as INERT
  # base64 ONLY when within the size cap, so a finding is reproducible cross-host
  # without depending on this leader's local disk. base64 is never interpolated into
  # a shell/LLM context — the repair job decodes it to a file.
  local jmark; jmark="$(mktemp)"
  {
    cat "$fdir/meta.md"
    printf 'repair_base: %s\n' "$repair_base"
    printf 'artifact_path: %s\n' "$fdir/input.bin"
    if [ "$sz" -le "$GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES" ]; then
      printf 'input_base64: '
      base64 -w0 "$minz" 2>/dev/null || base64 "$minz" | tr -d '\n'
      printf '\n'
    else
      printf 'input_base64: (omitted: %sB exceeds cap)\n' "$sz"
    fi
  } > "$jmark"
  if ! journal_put "ironhorse-fuzz/findings/$fid.md" "$jmark" "ironhorse-fuzz: record finding $fid ($target)"; then
    log "WARN: could not land finding marker $fid — will re-handle next tick"
    rm -f "$minz" "$jmark"; return 0
  fi
  rm -f "$jmark"

  # Post exactly one repair job with BOUNDED metadata (no raw bytes inlined).
  local jb; jb="$(mktemp)"
  {
    printf '%s\n' '---'
    printf '%s\n' 'role: builder'
    printf '%s\n' 'tier: mentor'
    printf '%s\n' 'fallback-tier: minion'
    printf '%s\n' 'dispatch: automatic'
    printf '%s\n\n' '---'
    printf '# Fix Ironhorse fuzz finding %s (target `%s`) and amend the standing PR\n\n' "$fid" "$target"
    printf 'The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a\n'
    printf 'load-bearing regression case AND the causal fix, then amend the ONE standing\n'
    printf 'pull request for fuzz findings.\n\n'
    printf '## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)\n\n'
    printf -- '- Target: `%s` (one of the maintained ironhorse-fuzz targets)\n' "$target"
    printf -- '- Project SHA under fuzz: `%s`\n' "$project_sha"
    printf -- '- Toolchain: `%s`\n' "$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN"
    printf -- '- Minimized input sha256: `%s` (%s bytes)\n' "$art_sha" "$(wc -c < "$minz" | tr -d '[:space:]')"
    printf -- '- Durable artifact (leader host): `%s`\n' "$fdir/input.bin"
    printf -- '- Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/%s.md`\n' "$fid"
    printf -- '- Reproduction: `%s`\n\n' "$repro_cmd"
    printf '## Procedure\n\n'
    printf '1. Get an isolated project checkout of `%s` @ `%s` via ensure-project-worktree.sh.\n' "$GARDEN_IRONHORSE_FUZZ_REPO" "$branch"
    printf '2. Recover the minimized input to a FILE without inlining it into any prompt:\n'
    printf '   decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the\n'
    printf '   durable artifact path above. Verify `sha256sum` equals `%s`.\n' "$art_sha"
    printf '3. Set up the pinned fuzz env (c/moddable submodule peer-init, `%s`, cargo-fuzz —\n' "$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN"
    printf '   see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file\n'
    printf '   before changing any code. If it does not reproduce at `%s`, report that and stop.\n\n' "$project_sha"
    printf '4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,\n'
    printf '   so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`\n'
    printf '   that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).\n'
    printf '5. Fix the causal defect. Keep the fix minimal and targeted.\n'
    printf '6. Amend the STANDING branch `%s` with fetch/rebase/push CAS discipline, then\n' "$branch"
    printf '   `scripts/jobs/gardening/ensure-pr.sh %s %s %s:%s %s` to create-or-adopt the standing\n' "$marker_base" "$GARDEN_IRONHORSE_FUZZ_REPO" "$GARDEN_IRONHORSE_FUZZ_BOT_LOGIN" "$branch" "$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH"
    printf '   PR (the `<!-- garden-job: %s -->` marker guarantees every finding amends the SAME PR),\n' "$marker_base"
    printf '   and run its required gauntlet.\n'
    printf '7. Document THIS case and its solution in the standing PR body or a PR comment (finding %s).\n' "$fid"
    printf '8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a\n'
    printf '   comment, and record the unsolved finding visibly in the PR — never let it disappear.\n'
  } > "$jb"

  if "$GARDEN_IRONHORSE_FUZZ_POST" --identity "ironhorse-fuzz-finding-$fid" "$repair_base" "$jb" >/dev/null 2>&1; then
    posted_this_tick=$((posted_this_tick + 1))
    log "posted repair job $repair_base for finding $fid (target $target)"
  else
    log "WARN: post of $repair_base did not land — the finding marker persists, will retry next tick"
  fi
  rm -f "$jb" "$minz"
}

findings_seen=0
for target in $GARDEN_IRONHORSE_FUZZ_TARGETS; do
  is_allowed_target "$target" || continue
  corpus="$CORPUS_ROOT/$target"; mkdir -p "$corpus"
  arts="$ART_ROOT/$target"; mkdir -p "$arts"

  rc=0
  "$GARDEN_IRONHORSE_FUZZ_RUNNER" "$target" "$corpus" "$arts" "$GARDEN_IRONHORSE_FUZZ_SECS" \
    >"$LOGS_ROOT/$target.log" 2>&1 || rc=$?
  case "$rc" in
    0)  : ;;                                   # clean increment
    77) log "$target: runner reported a crash artifact" ;;
    *)  log "WARN: $target runner exited rc=$rc (see $LOGS_ROOT/$target.log) — skipping this target this tick"
        continue ;;
  esac

  # Handle every fresh crash artifact this target produced (bounded per tick).
  while IFS= read -r crash; do
    [ -n "$crash" ] || continue
    [ "$findings_seen" -lt "$GARDEN_IRONHORSE_FUZZ_MAX_FINDINGS_PER_TICK" ] || { log "reached per-tick finding cap; deferring the rest to next tick"; break; }
    findings_seen=$((findings_seen + 1))
    handle_finding "$target" "$crash"
  done < <(find "$arts" -type f 2>/dev/null | sort)

  # Corpus disk bound: prune oldest entries beyond the per-target cap.
  cap_kb=$(( GARDEN_IRONHORSE_FUZZ_CORPUS_MAX_MB * 1024 ))
  cur_kb="$(du -sk "$corpus" 2>/dev/null | cut -f1 || echo 0)"
  if [ "${cur_kb:-0}" -gt "$cap_kb" ]; then
    log "$target corpus ${cur_kb}KB over cap ${cap_kb}KB — pruning oldest"
    # Delete oldest files until under cap (never touch the artifacts we already handled).
    while [ "$(du -sk "$corpus" 2>/dev/null | cut -f1 || echo 0)" -gt "$cap_kb" ]; do
      oldest="$(find "$corpus" -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | head -n1 | cut -d' ' -f2-)"
      [ -n "$oldest" ] || break
      rm -f "$oldest"
    done
  fi
done

# ─────────────────────────────────────────────────────────────────────────────
# 4. If we posted the FIRST finding of a generation, the repair job will create the
#    standing PR; record its number opportunistically so rollover detection works.
#    We do NOT create the PR here (that is the repair job's job) — we only learn its
#    number, which the PR-state seam can also resolve by marker on a later tick.
# ─────────────────────────────────────────────────────────────────────────────
if [ -z "$st_pr" ]; then
  pr_num="$("$GARDEN_IRONHORSE_FUZZ_PR_STATE" "$GARDEN_IRONHORSE_FUZZ_REPO" "$marker_base" "$GARDEN_IRONHORSE_FUZZ_BOT_LOGIN" --number 2>/dev/null | head -n1 | tr -d '[:space:]' || true)"
  if [ -n "$pr_num" ] && [ "$pr_num" != "0" ]; then
    write_standing "$gen" "$branch" "$marker_base" active "$pr_num" || true
    log "recorded standing PR #$pr_num for gen $gen"
  fi
fi

log "tick complete: gen=$gen findings_handled=$findings_seen repair_jobs_posted=$posted_this_tick"
exit 0
