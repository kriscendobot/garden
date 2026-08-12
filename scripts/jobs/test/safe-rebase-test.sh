#!/bin/bash
# safe-rebase-test.sh: the gardening rebase stage must recover a stale PR branch
# DETERMINISTICALLY and FAIL CLOSED otherwise. Reproduces the shapes hermetically on
# throwaway git fixtures:
#   1. a branch already carrying the base tip is a quiet no-op (rc 0, nothing done);
#   2. a base that moved with NO overlap rebases the reviewed commits clean (rc 0);
#   3. a base that moved the SAME lockfile drops the stale lockfile commit and
#      regenerates it against the new base (rc 0), preserving the reviewed code
#      commit and leaving exactly one `chore: Update yarn.lock` at the tip;
#   4. a base that conflicts on a CODE file is REFUSED (rc 3) and the worktree is
#      left unchanged (no half-applied rebase) — the endo-but-for-bots #868 fail-safe.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SR="$JOBS/gardening/safe-rebase.sh"
# The lockfile-recovery subtest hands safe-rebase.sh an executable regen stub, so the
# test root must permit EXECUTION — this container's /tmp is `noexec` (same constraint
# run-test.sh probes for). Take the first candidate base that can run a throwaway script.
tr_base=""
for cand in "${TMPDIR:-}" /var/tmp /tmp "$HOME"; do
  { [ -n "$cand" ] && [ -d "$cand" ] && [ -w "$cand" ]; } || continue
  probe="$(mktemp -d "$cand/.garden-sr-probe.XXXXXX" 2>/dev/null)" || continue
  printf '#!/bin/sh\nexit 0\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null || true
  if [ -x "$probe/x" ] && "$probe/x" 2>/dev/null; then rm -rf "$probe"; tr_base="$cand"; break; fi
  rm -rf "$probe"
done
[ -n "$tr_base" ] || tr_base="$HOME"
TR="$(mktemp -d "$tr_base/.garden-safe-rebase-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

G=(-c user.name=test -c user.email=test@example.invalid -c commit.gpgsign=false)
git_c() { command git -C "$1" "${G[@]}" "${@:2}"; }

pass=0
ok()  { echo "  PASS: $*"; pass=$((pass+1)); }
die() { echo "  FAIL: $*" >&2; exit 1; }

# A throwaway repo whose base branch carries a code file and a lockfile. Returns via
# globals: the fixture dir is $1, base branch is `main`, PR branch is `pr`.
# The lockfile regeneration is stubbed to a deterministic writer so the test never
# shells out to a real package manager.
REGEN="$TR/regen.sh"
cat > "$REGEN" <<'STUB'
#!/bin/bash
# Deterministic lockfile "regeneration": write a marker that is a function of the
# current base content, so the regenerated lockfile differs from any skipped one.
wt="$1"
printf 'lockfile regenerated against base:\n' > "$wt/yarn.lock"
cat "$wt/pkg.txt" >> "$wt/yarn.lock" 2>/dev/null || true
STUB
chmod +x "$REGEN"

new_repo() {  # new_repo <dir>: base branch `main` with pkg.txt + yarn.lock, plus PR branch `pr`
  local d="$1"
  git init -q -b main "$d"
  # Production's ensure-project-worktree.sh pins the bot identity in the worktree
  # config; the rebase safe-rebase.sh runs internally needs it. Mirror that here.
  git -C "$d" config user.email test@example.invalid
  git -C "$d" config user.name test
  git -C "$d" config commit.gpgsign false
  printf 'pkg v1\n' > "$d/pkg.txt"
  printf 'lock v1\n' > "$d/yarn.lock"
  printf 'code v1\n' > "$d/code.txt"
  git -C "$d" add -A; git_c "$d" commit -q -m "base"
}

# ── 1. Already-fresh branch: quiet no-op ─────────────────────────────────────
D="$TR/fresh"; new_repo "$D"
git_c "$D" checkout -q -b pr
printf 'code v2\n' > "$D/code.txt"; git -C "$D" add -A; git_c "$D" commit -q -m "feat: change code"
PR_TIP="$(git -C "$D" rev-parse HEAD)"
rc=0; out="$("$SR" "$D" main 2>&1)" || rc=$?
[ "$rc" -eq 0 ] || die "already-fresh branch should be rc 0, got $rc: $out"
[ "$(git -C "$D" rev-parse HEAD)" = "$PR_TIP" ] || die "no-op rebase changed HEAD"
[ -z "$out" ] || die "already-fresh branch should be QUIET, printed: $out"
ok "a branch already carrying the base tip is a quiet no-op"

# ── 2. Base moved, no overlap: reviewed commits replay clean ─────────────────
D="$TR/clean"; new_repo "$D"
git_c "$D" checkout -q -b pr
printf 'code v2\n' > "$D/code.txt"; git -C "$D" add -A; git_c "$D" commit -q -m "feat: change code"
git_c "$D" checkout -q main
printf 'other v2\n' > "$D/other.txt"; git -C "$D" add -A; git_c "$D" commit -q -m "chore: unrelated base move"
git_c "$D" checkout -q pr
rc=0; out="$("$SR" "$D" main 2>&1)" || rc=$?
[ "$rc" -eq 0 ] || die "clean rebase should be rc 0, got $rc: $out"
git -C "$D" merge-base --is-ancestor main HEAD || die "rebase did not put the base tip under HEAD"
grep -q 'code v2' "$D/code.txt" || die "reviewed code change lost in clean rebase"
[ -f "$D/other.txt" ] || die "base's new file missing after rebase"
ok "a moved base with no overlap replays the reviewed commits clean"

# ── 3. Lockfile-only conflict: drop the stale lockfile commit + regenerate ───
D="$TR/lock"; new_repo "$D"
git_c "$D" checkout -q -b pr
printf 'pkg v2-pr\n' > "$D/pkg.txt"; git -C "$D" add pkg.txt; git_c "$D" commit -q -m "feat: bump dep"
printf 'lock v2-pr\n' > "$D/yarn.lock"; git -C "$D" add yarn.lock; git_c "$D" commit -q -m "chore: Update yarn.lock"
CODE_MSG_BEFORE="$(git -C "$D" log --format=%s -n2 | tail -1)"
# Base independently moves the SAME lockfile → the pr's lockfile commit conflicts.
git_c "$D" checkout -q main
printf 'lock v2-base\n' > "$D/yarn.lock"; git -C "$D" add yarn.lock; git_c "$D" commit -q -m "chore: Update yarn.lock on base"
git_c "$D" checkout -q pr
rc=0; out="$(GARDEN_LOCKFILE_REGEN="$REGEN" "$SR" "$D" main 2>&1)" || rc=$?
[ "$rc" -eq 0 ] || die "lockfile-only conflict should recover (rc 0), got $rc: $out"
git -C "$D" merge-base --is-ancestor main HEAD || die "recovered branch is not on the fresh base"
# The reviewed feat commit survives; the lockfile is the regenerated one, and there
# is exactly one lockfile commit at the tip.
git -C "$D" log --format=%s | grep -q '^feat: bump dep$' || die "reviewed feat commit lost during lockfile recovery"
grep -q 'pkg v2-pr' "$D/pkg.txt" || die "reviewed package change lost"
grep -q 'regenerated against base' "$D/yarn.lock" || die "lockfile was not regenerated (stale side kept?)"
[ "$(git -C "$D" log --format=%s | grep -c '^chore: Update yarn.lock$')" -eq 1 ] \
  || die "expected exactly one regenerated lockfile commit"
[ "$(git -C "$D" rev-parse HEAD:pkg.txt)" != "" ] || die "worktree tree broken"
git -C "$D" diff --quiet && git -C "$D" diff --cached --quiet || die "worktree left dirty after recovery"
ok "a lockfile-only conflict drops the stale lockfile commit and regenerates it (#868)"

# ── 4. Code conflict: REFUSED, worktree untouched (fail closed) ──────────────
D="$TR/codeconf"; new_repo "$D"
git_c "$D" checkout -q -b pr
printf 'code PR-side\n' > "$D/code.txt"; git -C "$D" add code.txt; git_c "$D" commit -q -m "feat: PR edits code"
PR_TIP="$(git -C "$D" rev-parse HEAD)"
git_c "$D" checkout -q main
printf 'code BASE-side\n' > "$D/code.txt"; git -C "$D" add code.txt; git_c "$D" commit -q -m "fix: base edits same code"
git_c "$D" checkout -q pr
rc=0; out="$(GARDEN_LOCKFILE_REGEN="$REGEN" "$SR" "$D" main 2>&1)" || rc=$?
[ "$rc" -eq 3 ] || die "a code conflict must be REFUSED (rc 3), got $rc: $out"
printf '%s\n' "$out" | grep -qi 'non-deterministic conflict' || die "refusal should name the non-deterministic conflict: $out"
[ "$(git -C "$D" rev-parse HEAD)" = "$PR_TIP" ] || die "REFUSED rebase left HEAD moved (should abort cleanly)"
[ ! -d "$D/.git/rebase-merge" ] && [ ! -d "$D/.git/rebase-apply" ] || die "REFUSED rebase left a rebase in progress"
grep -q 'code PR-side' "$D/code.txt" || die "worktree not restored to the PR side after abort"
ok "a code conflict is REFUSED and the worktree is left unchanged (fail closed, #868 safety)"

# ── 5. Unresolvable local base (e.g. HEAD~1 on a single-commit branch): skip ─
# The scaffold default is HEAD~1; on a single-commit branch it does not resolve, and
# that is "no base to rebase onto", not a conflict — it must not wedge the gauntlet.
D="$TR/onecommit"; git init -q -b main "$D"
git -C "$D" config user.email test@example.invalid; git -C "$D" config user.name test
printf 'only\n' > "$D/f.txt"; git -C "$D" add -A; git_c "$D" commit -q -m "sole commit"
SOLE="$(git -C "$D" rev-parse HEAD)"
rc=0; out="$("$SR" "$D" HEAD~1 2>&1)" || rc=$?
[ "$rc" -eq 0 ] || die "unresolvable local base should skip (rc 0), got $rc: $out"
[ "$(git -C "$D" rev-parse HEAD)" = "$SOLE" ] || die "skip changed HEAD"
ok "an unresolvable local base ref skips quietly (rc 0), never wedges the gauntlet"

echo "PASS: safe-rebase recovers stale branches deterministically and fails closed on real conflicts ($pass checks)"
