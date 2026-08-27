#!/bin/bash
# ironhorse-fuzz-rehearsal.sh — an INTEGRATION REHEARSAL of the continuous Ironhorse
# fuzz service against a KNOWN SYNTHETIC crash, with no GitHub, no cargo, and no real
# fuzz wait. It drives the REAL ironhorse-fuzz.sh end to end and narrates the pipeline
# so an operator can see exactly what a live finding produces:
#
#   capture (runner drops a synthetic crash) → reproduce → minimize → durable metadata
#   + journal dedup marker → one posted repair job → idempotent replay (no duplicate).
#
# This is the "without requiring an actual long fuzz wait" acceptance rehearsal: the
# heavy fuzz seam is a synthetic-crash stub; everything downstream is the production code
# path. Run it by hand: scripts/jobs/test/ironhorse-fuzz-rehearsal.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
# This rehearsal execs stub seam scripts from TR, so TR must be on an EXEC-capable
# filesystem. Prefer TMPDIR/tmp, but the garden sandbox mounts /tmp noexec (a /tmp
# path would fail the seam exec rc=126) — probe, then fall back to a home-side dir.
_base="${TMPDIR:-/tmp}"
_probe="$_base/.ihfx.$$"
if printf '#!/bin/sh\nexit 0\n' >"$_probe" 2>/dev/null && chmod +x "$_probe" 2>/dev/null && "$_probe" 2>/dev/null; then :; else _base="$HOME"; fi
rm -f "$_probe" 2>/dev/null || true
TR="$(mktemp -d "$_base/garden-ihf-rehearsal.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
git_id=(-c user.name=test -c user.email=test@localhost)
say() { printf '\n\033[1m== %s ==\033[0m\n' "$*"; }

# --- throwaway journal ------------------------------------------------------
BARE="$TR/journal.git"; SEED="$TR/seed"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"; mkdir -p jobs/plan jobs/todo jobs/doin jobs/tada jobs/index ironhorse-fuzz
  for d in jobs/plan jobs/todo jobs/doin jobs/tada jobs/index ironhorse-fuzz; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin "$BRANCH"

# --- a KNOWN synthetic crash ------------------------------------------------
SEED_ROOT="$TR/crashes"; mkdir -p "$SEED_ROOT/bytecode_decoder"
SYNTH='SYNTHETIC-IRONHORSE-CRASH-\x00\x01deadbeef'
printf '%b' "$SYNTH" > "$SEED_ROOT/bytecode_decoder/synthetic-1"
say "Synthetic crash input (target bytecode_decoder)"
printf '  bytes: %s\n  sha256: %s\n' "$SYNTH" "$(sha256sum "$SEED_ROOT/bytecode_decoder/synthetic-1" | cut -d' ' -f1)"

# --- stubs for the heavy seams (capture/minimize/reproduce/sha/pr-state) ----
RUNNER="$TR/runner.sh"; cat > "$RUNNER" <<'EOF'
#!/bin/bash
target="$1"; arts="$3"; src="$STUB_SEED_ROOT/$target"; d=0
[ -d "$src" ] && for f in "$src"/*; do [ -f "$f" ] && { cp "$f" "$arts/crash-$(basename "$f")"; d=1; }; done
[ "$d" = 1 ] && exit 77 || exit 0
EOF
MIN="$TR/min.sh"; printf '#!/bin/bash\ncp "$2" "$3"\n' > "$MIN"
REP="$TR/rep.sh"; printf '#!/bin/bash\nexit 0\n' > "$REP"
SHA="$TR/sha.sh"; printf '#!/bin/bash\necho cd6e55513ca6618755ee9455809a8ead7c9227a4\n' > "$SHA"
PRS="$TR/prs.sh"; printf '#!/bin/bash\n[ "${4:-}" = "--number" ] && echo 0 || echo NONE\n' > "$PRS"
chmod +x "$RUNNER" "$MIN" "$REP" "$SHA" "$PRS"

STATE="$TR/state"
run_tick() {
  env -i HOME="$HOME" PATH="$PATH" GARDEN_TEST=1 \
    GARDEN_STATE="$STATE" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN=rehearsal-host GARDEN_LEADER=rehearsal-host \
    GARDEN_IRONHORSE_FUZZ_STATE="$STATE/ihf" STUB_SEED_ROOT="$SEED_ROOT" \
    GARDEN_IRONHORSE_FUZZ_RUNNER="$RUNNER" GARDEN_IRONHORSE_FUZZ_MINIMIZER="$MIN" \
    GARDEN_IRONHORSE_FUZZ_REPRODUCER="$REP" GARDEN_IRONHORSE_FUZZ_SHA_CMD="$SHA" \
    GARDEN_IRONHORSE_FUZZ_PR_STATE="$PRS" GARDEN_IRONHORSE_FUZZ_POST="$JOBS/post-job.sh" \
    GARDEN_IRONHORSE_FUZZ_TARGETS="bytecode_decoder" GARDEN_IRONHORSE_FUZZ_SECS=1 \
    GARDEN_BACKOFF_BASE_MS=0 \
    "$JOBS/ironhorse-fuzz.sh"
}
jfile() { local w; w="$(mktemp -d "$TR/jf.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$w" 2>/dev/null; cat "$w/$1" 2>/dev/null || true; rm -rf "$w"; }
todo_n() { local w; w="$(mktemp -d "$TR/tn.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$w" 2>/dev/null; ls -1 "$w/jobs/todo" | grep -vxc '.gitkeep' || true; rm -rf "$w"; }

say "TICK 1 — capture → reproduce → minimize → record → post"
run_tick 2>&1 | sed 's/^/  [svc] /'

FID="$(ls "$STATE/ihf/findings" 2>/dev/null | head -n1)"
say "Durable metadata ($STATE/ihf/findings/$FID/meta.md)"
sed 's/^/  /' "$STATE/ihf/findings/$FID/meta.md"
say "Durable minimized artifact"
printf '  %s  (%s bytes)\n' "$STATE/ihf/findings/$FID/input.bin" "$(wc -c < "$STATE/ihf/findings/$FID/input.bin")"

say "Journal dedup marker (ironhorse-fuzz/findings/$FID.md) — note inert base64, NO host-path dependence"
jfile "ironhorse-fuzz/findings/$FID.md" | sed 's/^/  /'

say "Posted repair job (frontmatter + heading)"
jfile "jobs/todo/ironhorse-fuzz-${FID}-repair.md" | sed -n '1,14p' | sed 's/^/  /'

say "Jobs in todo after tick 1: $(todo_n)"

say "TICK 2 — idempotent replay (same synthetic crash) → NO duplicate"
run_tick 2>&1 | sed 's/^/  [svc] /'
N="$(todo_n)"
say "Jobs in todo after tick 2: $N"
if [ "$N" -eq 1 ]; then
  printf '\n\033[1;32mREHEARSAL PASSED\033[0m: one finding → one durable record → one repair job → idempotent on replay.\n'
  exit 0
else
  printf '\n\033[1;31mREHEARSAL FAILED\033[0m: expected 1 job, got %s\n' "$N"
  exit 1
fi
