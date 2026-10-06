#!/bin/bash
# journal-clone-seed-from-root-test.sh — regression guard for seeding journal clones
# from the host's own root repo instead of the network.
#
# Incident (endolin-garden2, 2026-10-06 01:22-02:40Z): on a newly promoted leader,
# every singleton whose journal clone was missing timed out cloning journal2 from
# GitHub at 300s, and every clone last synced 09-23 timed out its 45s catch-up fetch
# on every tick, so each reported itself offline (rc=75) indefinitely; each aborted
# fetch left a tmp_pack_* behind (570 MiB in the foreman clone). Covered here:
#   * reclone_clone builds a new clone from $GARDEN_ROOT/.git with no network, shallow;
#   * with seeding disabled it still falls back to the network clone;
#   * sync_clone re-seeds a stale clone whose capped fetch fails, then succeeds;
#   * a seed never rewinds a clone that is ahead of the root;
#   * a seeded shallow clone is completed from the root after its first sync;
#   * stray tmp_pack_* files are swept (stale ones always, a timed-out attempt's own);
#   * a pre-transfer kriskowal/garden URL is canonicalized for new clones.
#
# Usage: journal-clone-seed-from-root-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

TR="$(mktemp -d "$HOME/.garden-seed-root-test.XXXXXX")"  # $HOME, not /tmp: the fake fetch must be executable
trap '[ -n "${KEEP:-}" ] || rm -rf "$TR"' EXIT
mkdir -p "$TR/bin"
export GARDEN_STATE="$TR/state" GARDEN_CONTENTION_DIR="$TR/state/journal-contention"

# shellcheck source=../common.sh
source "$JOBS/common.sh"
export GARDEN_FETCH_RETRIES=1

# The journal remote (stands in for GitHub) and a writer that advances it.
RB="$TR/journal.git"; W="$TR/writer"
git init -q --bare "$RB"
git init -q "$W"
git -C "$W" checkout -q -b journal2
git -C "$W" remote add origin "$RB"
commit_n() {  # <n> — add n commits to the remote
  local i
  for i in $(seq "$1"); do
    printf '%s\n' "$RANDOM-$i" > "$W/f-$(date +%s%N)"
    git -C "$W" add -A
    git -C "$W" -c user.name=t -c user.email=t@localhost commit -q -m "c$i"
  done
  git -C "$W" push -q origin HEAD:journal2
}
commit_n 6

# A stand-in for the deployed root: a real .git DIRECTORY whose origin/journal2
# tracks the remote, as the journal/ worktree keeps it on a host.
ROOT="$TR/root"
git init -q "$ROOT"
git -C "$ROOT" remote add origin "$RB"
refresh_root() { git -C "$ROOT" fetch -q origin "+refs/heads/journal2:refs/remotes/origin/journal2"; }
refresh_root
export GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$RB"
tip() { git -C "$RB" rev-parse journal2; }

hr; echo "CASE — a missing clone is built from the root repo with no network"; hr
CL="$TR/c-fresh"
rc=0
# The root's origin names the same (here unreachable) remote, as on a host.
git -C "$ROOT" remote set-url origin "$TR/unreachable.git"
( export JOURNAL_REMOTE="$TR/unreachable.git" GARDEN_JOURNAL_SEED_DEPTH=2
  ensure_clone "$CL" ) >/dev/null 2>"$TR/fresh.err" || rc=$?
git -C "$ROOT" remote set-url origin "$RB"
if [ "$rc" -eq 0 ] \
   && [ "$(git -C "$CL" rev-parse HEAD)" = "$(tip)" ] \
   && [ "$(git -C "$CL" rev-parse --abbrev-ref HEAD)" = journal2 ] \
   && [ "$(git -C "$CL" rev-parse --abbrev-ref journal2@{upstream})" = origin/journal2 ] \
   && [ "$(git -C "$CL" config --get remote.origin.fetch)" = "+refs/heads/journal2:refs/remotes/origin/journal2" ] \
   && [ "$(git -C "$CL" rev-parse --is-shallow-repository)" = true ] \
   && [ -z "$(git -C "$CL" for-each-ref refs/garden-seed)" ] \
   && ! ls -d "$TR"/c-fresh.seed.* "$TR"/c-fresh.reclone.* >/dev/null 2>&1; then
  ok "seeded single-branch shallow clone at the root's tip, no temp left behind"
else
  bad "fresh seed: rc=$rc stderr=$(tr '\n' ' ' < "$TR/fresh.err")"
fi

hr; echo "CASE — a clone of a different journal is never seeded from the root"; hr
rc=0
( export JOURNAL_REMOTE="$TR/unreachable.git"; ensure_clone "$TR/c-foreign" ) >/dev/null 2>"$TR/foreign.err" || rc=$?
if [ "$rc" -ne 0 ] && [ ! -d "$TR/c-foreign/.git" ] && ! grep -q 'seeded journal clone' "$TR/foreign.err"; then
  ok "origin differs from the root's: no seed, network clone attempted (rc=$rc)"
else
  bad "foreign: rc=$rc stderr=$(tr '\n' ' ' < "$TR/foreign.err")"
fi

hr; echo "CASE — seeding disabled falls back to the network clone"; hr
rc=0
( export GARDEN_JOURNAL_SEED_FROM_ROOT=0
  git -C "$ROOT" remote set-url origin "$TR/unreachable.git"
  export JOURNAL_REMOTE="$TR/unreachable.git"; ensure_clone "$TR/c-noseed" ) >/dev/null 2>"$TR/noseed.err" || rc=$?
if [ "$rc" -ne 0 ] && grep -q "clone of $TR/unreachable.git" "$TR/noseed.err"; then
  ok "without a seed the clone goes to the network (rc=$rc)"
else
  bad "noseed: rc=$rc stderr=$(tr '\n' ' ' < "$TR/noseed.err")"
fi
git -C "$ROOT" remote set-url origin "$RB"
rc=0
( export GARDEN_JOURNAL_SEED_FROM_ROOT=0; ensure_clone "$TR/c-net" ) >/dev/null 2>&1 || rc=$?
if [ "$rc" -eq 0 ] && [ "$(git -C "$TR/c-net" rev-parse HEAD)" = "$(tip)" ]; then
  ok "network clone still works when seeding is off"
else
  bad "network fallback clone failed (rc=$rc)"
fi

hr; echo "CASE — the seeded shallow clone is completed from the root on sync"; hr
rc=0
git -C "$CL" remote set-url origin "$RB"
( sync_clone "$CL" ) >/dev/null 2>"$TR/deepen.err" || rc=$?
if [ "$rc" -eq 0 ] && [ "$(git -C "$CL" rev-parse --is-shallow-repository)" = false ] \
   && [ "$(git -C "$CL" rev-list --count HEAD)" = "$(git -C "$RB" rev-list --count journal2)" ]; then
  ok "sync_clone unshallowed the seeded clone"
else
  bad "deepen: rc=$rc shallow=$(git -C "$CL" rev-parse --is-shallow-repository) stderr=$(tr '\n' ' ' < "$TR/deepen.err")"
fi

hr; echo "CASE — a stale clone whose capped fetch fails is re-seeded, then syncs"; hr
STALE="$TR/c-stale"
git clone -q --single-branch --branch journal2 "$RB" "$STALE"
commit_n 30; refresh_root; commit_n 2   # root lags origin by 2 commits
# fetch mock: a clone still behind the root "times out" (the whole gap); one
# already seeded fetches the remainder for real.
cat > "$TR/bin/fetch" <<EOF
#!/bin/bash
echo x >> "$TR/fetch.calls"
cur=\$(git -C "\$GARDEN_FETCH_DIR" rev-parse refs/remotes/origin/journal2)
if [ "\$cur" != "\$(git -C "$ROOT" rev-parse refs/remotes/origin/journal2)" ]; then
  : > "\$GARDEN_FETCH_DIR/.git/objects/pack/tmp_pack_killed\$RANDOM"
  exit 124
fi
exec git -C "\$GARDEN_FETCH_DIR" fetch -q origin journal2
EOF
chmod +x "$TR/bin/fetch"
: > "$TR/fetch.calls"
rc=0
( export GARDEN_FETCH_CMD="$TR/bin/fetch"; sync_clone "$STALE" ) >/dev/null 2>"$TR/stale.err" || rc=$?
if [ "$rc" -eq 0 ] && [ "$(git -C "$STALE" rev-parse HEAD)" = "$(tip)" ] \
   && [ "$(wc -l < "$TR/fetch.calls")" -eq 2 ] && grep -q 'seeded journal clone' "$TR/stale.err" \
   && [ -z "$(find "$STALE/.git/objects/pack" -name 'tmp_pack_*')" ]; then
  ok "stale clone re-seeded from root and topped up (2 fetches), timed-out tmp_pack swept"
else
  bad "stale: rc=$rc head=$(git -C "$STALE" rev-parse --short HEAD) calls=$(wc -l < "$TR/fetch.calls") stderr=$(tr '\n' ' ' < "$TR/stale.err")"
fi

hr; echo "CASE — a genuine outage on an up-to-date clone stays a clean offline skip"; hr
printf '#!/bin/bash\necho "fatal: unable to access: Could not resolve host: github.com" >&2\nexit 128\n' > "$TR/bin/offline"
chmod +x "$TR/bin/offline"
rc=0
( export GARDEN_FETCH_CMD="$TR/bin/offline"; sync_clone "$STALE" ) >/dev/null 2>"$TR/off.err" || rc=$?
if [ "$rc" -eq "$GARDEN_OFFLINE_RC" ] && ! grep -q 'seeded journal clone' "$TR/off.err"; then
  ok "no seed when the root has nothing newer; offline rc=$rc"
else
  bad "offline: rc=$rc stderr=$(tr '\n' ' ' < "$TR/off.err")"
fi

hr; echo "CASE — a seed never rewinds a clone that is ahead of the root"; hr
before="$(git -C "$STALE" rev-parse refs/remotes/origin/journal2)"
if ! journal_seed_from_root "$STALE" 2>/dev/null \
   && [ "$(git -C "$STALE" rev-parse refs/remotes/origin/journal2)" = "$before" ]; then
  ok "root behind the clone: ref unchanged"
else
  bad "seed rewound or claimed progress: $(git -C "$STALE" rev-parse --short refs/remotes/origin/journal2) vs ${before:0:7}"
fi

hr; echo "CASE — stray tmp_pack sweep"; hr
P="$STALE/.git/objects/pack"
: > "$P/tmp_pack_old"; touch -d '2 hours ago' "$P/tmp_pack_old"
: > "$P/tmp_idx_old";  touch -d '2 hours ago' "$P/tmp_idx_old"
: > "$P/tmp_pack_fresh"
_sweep_tmp_packs "$STALE" 2>/dev/null
if [ ! -e "$P/tmp_pack_old" ] && [ ! -e "$P/tmp_idx_old" ] && [ -e "$P/tmp_pack_fresh" ]; then
  ok "age-gated sweep removes only killed-transfer leftovers"
else
  bad "age-gated sweep: $(ls "$P" | tr '\n' ' ')"
fi
_sweep_tmp_packs "$STALE" "$(( $(date +%s) - 60 ))" 2>/dev/null
if [ ! -e "$P/tmp_pack_fresh" ] && [ -n "$(find "$P" -name '*.pack')" ]; then
  ok "attempt-scoped sweep removes the timed-out attempt's partial pack, keeps real packs"
else
  bad "attempt-scoped sweep: $(ls "$P" | tr '\n' ' ')"
fi

hr; echo "CASE — pre-transfer repo URL is canonicalized for new clones"; hr
c1="$(_canonical_journal_clone_url git@github.com:kriskowal/garden.git 2>/dev/null)"
c2="$(_canonical_journal_clone_url https://github.com/kriskowal/garden 2>/dev/null)"
c3="$(_canonical_journal_clone_url "$RB" 2>/dev/null)"
c4="$(_canonical_journal_clone_url git@github.com:kriskowal/garden-extra.git 2>/dev/null)"
if [ "$c1" = git@github.com:kriscendobot/garden.git ] && [ "$c2" = https://github.com/kriscendobot/garden ] \
   && [ "$c3" = "$RB" ] && [ "$c4" = git@github.com:kriskowal/garden-extra.git ]; then
  ok "alias rewritten; local and unrelated URLs untouched"
else
  bad "canonicalize: $c1 | $c2 | $c3 | $c4"
fi

hr; echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
