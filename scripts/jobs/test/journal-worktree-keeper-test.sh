#!/bin/bash
# journal-worktree-keeper-test.sh — coverage for the shared-journal-worktree
# reconciler (journal-worktree-keeper.sh).
#
# The journal/ worktree drifts unbounded (observed 6000+ behind, 3 stray
# superseded local-only commits, dirty library-staging paths) because the
# scripted pipeline works only in per-instance clones and common.sh intentionally
# never touches it. The keeper reconciles it on a cadence: a clean tree advances
# by `merge --ff-only`, and a DIVERGED tree (dirty and/or local-ahead) is
# SELF-HEALED losslessly — back up everything, gate on no-active-writer, then
# reset --hard — paging the maintainer ONLY for genuinely unpreservable WIP.
#
# Cases, mirroring the job spec:
#   * clean + behind            -> fast-forwarded to origin/journal2, no alert
#   * diverged + superseded     -> auto-healed (reset), backup taken, NO alert
#   * genuine WIP, healable      -> healed, WIP captured in the backup (lossless)
#   * genuine WIP, UNPRESERVABLE -> left untouched + alert (backup dir unwritable)
#   * active writer              -> heal aborts, tree untouched, no alert
#
# Hermetic: a throwaway upstream bare repo on branch journal2 + a real checkout
# of it standing in for the journal worktree. alert_maintainer is captured via
# GARDEN_ALERT_CMD so the inbox is never touched. No real garden/journal/network.
#
# Usage: journal-worktree-keeper-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
KEEPER="$JOBS/journal-worktree-keeper.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-journal-worktree-keeper-test
git_id=(-c user.name=test -c user.email=test@localhost)

UP="$TR/upstream.git"     # the shared origin (carries branch journal2)
JW="$TR/journal"          # stands in for $GARDEN_ROOT/journal
ALERTS="$TR/alerts.log"   # GARDEN_ALERT_CMD appends "<key>|<msg>" here

# Push a fresh commit onto upstream journal2 (so the worktree falls behind).
upstream_commit() {  # upstream_commit <content> <msg>
  local wt; wt="$(mktemp -d "$TR/push.XXXXXX")"
  git clone -q --branch journal2 "$UP" "$wt"
  printf '%s\n' "$1" > "$wt/f"
  git -C "$wt" add -A
  git -C "$wt" "${git_id[@]}" commit -q -m "$2"
  git -C "$wt" push -q origin journal2
  rm -rf "$wt"
}

setup_fixture() {
  rm -rf "$TR"; mkdir -p "$TR/state"
  git init -q --bare "$UP"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b journal2
  printf 'a\n' > "$SEED/f"
  git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m c1
  git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin journal2
  # Make journal2 the bare repo's HEAD so a plain clone checks it out.
  git -C "$UP" symbolic-ref HEAD refs/heads/journal2
  rm -rf "$SEED"
  # The standing journal worktree: a real checkout of journal2 with origin->UP.
  git clone -q --branch journal2 "$UP" "$JW"
  : > "$ALERTS"
}

# A tiny alert capture: GARDEN_ALERT_CMD receives (<dedup-key> <message>).
ALERT_STUB="$TR/alert-stub.sh"
write_alert_stub() {
  mkdir -p "$TR"
  cat > "$ALERT_STUB" <<EOF
#!/bin/bash
printf '%s|%s\n' "\$1" "\$2" >> "$ALERTS"
EOF
  chmod +x "$ALERT_STUB"
}

BACKUPS="$TR/backups"     # host-local lossless backup root (outside the worktree)
run_keeper() {  # run_keeper [extra env KEY=VAL ...] ; fills $OUT, $RC
  set +e
  OUT="$(env GARDEN_ROOT="$TR" GARDEN_STATE="$TR/state" \
             GARDEN_JOURNAL_WORKTREE="$JW" GARDEN=testhost \
             JOURNAL_BRANCH=journal2 \
             GARDEN_FETCH_TIMEOUT=10 GARDEN_FETCH_RETRIES=1 \
             GARDEN_ALERT_CMD="$ALERT_STUB" \
             GARDEN_JW_BACKUP_DIR="$BACKUPS" GARDEN_JW_SETTLE_SECS=1 \
             "$@" \
             bash "$KEEPER" 2>&1)"
  RC=$?
  set -e
}
head_sha()   { git -C "$JW" rev-parse HEAD; }
remote_sha() { git -C "$JW" rev-parse refs/remotes/origin/journal2; }
alert_count(){ local n; n="$(grep -c . "$ALERTS" 2>/dev/null)" || true; printf '%s\n' "${n:-0}"; }
# Newest backup dir the keeper created this run (host-<ts>), or empty.
latest_backup(){ ls -1d "$BACKUPS"/testhost-* 2>/dev/null | sort | tail -n1; }

# ============================================================================
hr; echo "STATIC — the script parses (bash -n)"; hr
bash -n "$KEEPER" && ok "journal-worktree-keeper.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "FRESH — worktree == origin: no-op, no alert"; hr
setup_fixture; write_alert_stub
before="$(head_sha)"
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 when already fresh" || bad "exit $RC when already fresh"
[ "$(head_sha)" = "$before" ] && ok "HEAD unchanged when fresh" || bad "HEAD moved when already fresh"
grep -qF "already fresh" <<<"$OUT" && ok "logged 'already fresh'" || bad "did not log already-fresh"
[ "$(alert_count)" -eq 0 ] && ok "no alert when fresh" || bad "alerted when fresh"

# ============================================================================
hr; echo "CLEAN+BEHIND — upstream advanced: worktree fast-forwarded"; hr
setup_fixture; write_alert_stub
old="$(head_sha)"
upstream_commit b c2
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 on fast-forward" || bad "exit $RC on fast-forward"
[ "$(head_sha)" = "$(remote_sha)" ] && ok "HEAD advanced to origin/journal2" || bad "HEAD did NOT advance ($(head_sha) != $(remote_sha))"
[ "$(head_sha)" != "$old" ] && ok "HEAD actually moved off the old tip" || bad "HEAD did not move"
grep -qF "fast-forwarded" <<<"$OUT" && ok "logged the fast-forward" || bad "did not log the fast-forward"
[ "$(alert_count)" -eq 0 ] && ok "no alert on a clean fast-forward" || bad "alerted on a clean fast-forward"

# ============================================================================
hr; echo "MISSING ORIGIN (JOURNAL_REMOTE) — origin re-added, worktree reconciled"; hr
# The 2026-07-03 15:50-15:51Z cascade: the journal worktree opens fine (gitdir
# resolves) but remote.origin.url momentarily vanishes, so journal_fetch — and every
# other git op resolving the journal remote — dives down the "no origin" fatal path.
# The keeper must re-add origin (here from an explicit $JOURNAL_REMOTE) BEFORE the
# fetch, then reconcile normally, never leaving the root cause for a later tick.
setup_fixture; write_alert_stub
upstream_commit b c2                          # upstream advances (so a real fetch matters)
git -C "$JW" remote remove origin             # drop origin — the exact wedge condition
git -C "$JW" config --get remote.origin.url >/dev/null 2>&1 \
  && bad "fixture: origin should be absent pre-run" \
  || ok "fixture: remote.origin.url absent before the keeper runs"
run_keeper JOURNAL_REMOTE="$UP"
[ "$RC" -eq 0 ] && ok "exit 0 after re-adding a missing origin" || bad "exit $RC on missing origin"
[ "$(git -C "$JW" config --get remote.origin.url 2>/dev/null)" = "$UP" ] \
  && ok "origin re-added to the canonical remote" || bad "origin not re-added"
grep -qF "REPAIRED:" <<<"$OUT" && ok "logged a REPAIRED: line for the re-added origin" || bad "did not log the origin repair"
[ "$(head_sha)" = "$(remote_sha)" ] && ok "worktree reconciled to origin/journal2 after the repair" || bad "worktree not reconciled after re-adding origin"
[ "$(alert_count)" -eq 0 ] && ok "no maintainer page on a self-healed origin" || bad "paged despite a self-healed origin"

# ============================================================================
hr; echo "MISSING ORIGIN (persisted cache) — origin re-added from the companion cache"; hr
# The companion job persists the last-good journal remote to $JOURNAL_REMOTE_CACHE
# ($GARDEN_STATE/config/journal-remote). With NO $JOURNAL_REMOTE set and no root
# origin, the keeper must still recover origin from that persisted canonical URL.
setup_fixture; write_alert_stub
git -C "$JW" remote remove origin
mkdir -p "$TR/state/config"; printf '%s\n' "$UP" > "$TR/state/config/journal-remote"
run_keeper                                    # no JOURNAL_REMOTE; forces the cache path
[ "$RC" -eq 0 ] && ok "exit 0 re-adding origin from the cache" || bad "exit $RC on cache-based origin repair"
[ "$(git -C "$JW" config --get remote.origin.url 2>/dev/null)" = "$UP" ] \
  && ok "origin re-added from the persisted cache" || bad "origin not re-added from the cache"
grep -qF "REPAIRED:" <<<"$OUT" && ok "logged the REPAIRED: line (cache path)" || bad "did not log the cache-path repair"
[ "$(alert_count)" -eq 0 ] && ok "no page on the cache-based origin repair" || bad "paged despite recovering origin from the cache"

# ============================================================================
hr; echo "SELF-HEAL (a) — diverged+superseded, no writer: auto-healed, no page"; hr
# The recurring real shape: a stale local-ahead commit, a dirty tracked file, and
# a stray untracked entry, all while upstream has moved far ahead. Expect a
# lossless reset to origin/journal2, a backup, and NO maintainer page.
setup_fixture; write_alert_stub
upstream_commit b c2                       # upstream advances (we fall behind)
printf 'stray local\n' > "$JW/f"           # a superseded local commit
git -C "$JW" add -A; git -C "$JW" "${git_id[@]}" commit -q -m "aborted scholar work"
printf 'dirty staging\n' >> "$JW/f"        # a dirty tracked path (library-staging shape)
mkdir -p "$JW/entries/2026/06/30"
printf 'stray result\n' > "$JW/entries/2026/06/30/195620Z-result-gardener-cc4a54.md"  # untracked
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 on a self-heal" || bad "exit $RC on self-heal"
[ "$(head_sha)" = "$(remote_sha)" ] && ok "HEAD reset to origin/journal2" || bad "HEAD not at origin ($(head_sha) != $(remote_sha))"
[ -z "$(git -C "$JW" status --porcelain)" ] && ok "worktree is clean after heal" || bad "worktree still dirty after heal"
[ ! -e "$JW/entries/2026/06/30/195620Z-result-gardener-cc4a54.md" ] && ok "stray untracked entry cleared" || bad "stray untracked entry remains"
grep -qF "SELF-HEALED:" <<<"$OUT" && ok "logged a SELF-HEALED line" || bad "did not log the self-heal"
[ "$(alert_count)" -eq 0 ] && ok "NO maintainer page on the lossless case" || bad "paged on a lossless self-heal"
B="$(latest_backup)"
[ -n "$B" ] && [ -n "$(ls -A "$B/patches" 2>/dev/null)" ] && ok "local-ahead commit captured as a patch" || bad "no patch backup for the local commit"
[ -f "$B/files/f" ] && ok "dirty tracked file captured in the backup" || bad "dirty file not backed up"
[ -f "$B/files/entries/2026/06/30/195620Z-result-gardener-cc4a54.md" ] && ok "untracked entry captured in the backup" || bad "untracked entry not backed up"

# ============================================================================
hr; echo "SELF-HEAL (b) — genuine WIP, healable: healed + WIP captured (lossless)"; hr
# Genuine (non-superseded) WIP is still healed — the backup, not on-origin
# presence, is the losslessness guarantee — but the exact WIP content must be
# recoverable from the backup afterwards.
setup_fixture; write_alert_stub
upstream_commit b c2
printf 'GENUINE-UNIQUE-WIP-9f3a\n' > "$JW/f"       # dirty content that is NOT on origin
run_keeper
[ "$RC" -eq 0 ] && ok "exit 0 healing genuine WIP" || bad "exit $RC on genuine-WIP heal"
[ "$(head_sha)" = "$(remote_sha)" ] && ok "HEAD reset to origin/journal2" || bad "HEAD not at origin on genuine-WIP heal"
[ "$(alert_count)" -eq 0 ] && ok "NO page (WIP was backupable → lossless)" || bad "paged despite a successful backup"
B="$(latest_backup)"
grep -qF "GENUINE-UNIQUE-WIP-9f3a" "$B/files/f" 2>/dev/null && ok "genuine WIP recoverable from the backup (never clobbered)" || bad "genuine WIP not recoverable from backup"

# ============================================================================
hr; echo "SELF-HEAL (c) — genuine WIP, UNPRESERVABLE: untouched + page"; hr
# When the backup itself cannot be taken (here: the backup root is blocked by a
# regular file so mkdir -p fails), the WIP is genuinely unpreservable: leave the
# tree exactly as-is (never clobber) and page the maintainer — the rare real case.
setup_fixture; write_alert_stub
upstream_commit b c2
printf 'unpreservable WIP\n' > "$JW/f"
before="$(head_sha)"
: > "$TR/blocked"                                   # a FILE where a dir is needed
run_keeper GARDEN_JW_BACKUP_DIR="$TR/blocked/backups"
[ "$RC" -eq 0 ] && ok "exit 0 (never wedged) on unpreservable WIP" || bad "exit $RC on unpreservable WIP"
[ "$(head_sha)" = "$before" ] && ok "HEAD untouched (no reset) on unpreservable WIP" || bad "reset despite an unpreservable backup"
grep -qF "unpreservable WIP" "$JW/f" && ok "WIP preserved in place (never clobbered)" || bad "WIP was clobbered"
grep -qF "UNPRESERVABLE:" <<<"$OUT" && ok "logged the UNPRESERVABLE case" || bad "did not log unpreservable"
[ "$(alert_count)" -ge 1 ] && ok "paged the maintainer for genuine unpreservable WIP" || bad "did not page on unpreservable WIP"
grep -qF "journal-worktree-unpreservable-testhost" "$ALERTS" && ok "page carries the unpreservable dedup-key" || bad "unpreservable dedup-key wrong/missing"

# ============================================================================
hr; echo "SELF-HEAL (d) — active writer: heal aborts, tree untouched, no page"; hr
# A live agent holds the worktree as cwd. The heal must abort losslessly: no
# reset, no page (an active writer is transient; the next tick heals).
setup_fixture; write_alert_stub
upstream_commit b c2
printf 'writer in progress\n' > "$JW/f"
before="$(head_sha)"
# Force the active-writer verdict deterministically (also exercised for real via
# the /proc cwd scan; here we inject to keep the test hermetic and fast).
run_keeper GARDEN_JW_WRITER_PROBE=/bin/true
[ "$RC" -eq 0 ] && ok "exit 0 when a writer is active" || bad "exit $RC with an active writer"
[ "$(head_sha)" = "$before" ] && ok "HEAD untouched while a writer is active" || bad "reset despite an active writer"
grep -qF "writer in progress" "$JW/f" && ok "in-flight WIP untouched" || bad "clobbered an active writer's WIP"
grep -qiF "active writer" <<<"$OUT" && ok "logged the active-writer abort" || bad "did not log the active-writer abort"
[ "$(alert_count)" -eq 0 ] && ok "NO page on a transient active writer" || bad "paged on an active writer"

# ============================================================================
hr; echo "REAL /proc PROBE — a process with cwd in the worktree aborts the heal"; hr
# Exercise the built-in active-writer probe's /proc/*/cwd scan (no injection):
# a background process parked in $JW must abort the heal.
setup_fixture; write_alert_stub
upstream_commit b c2
printf 'proc-held WIP\n' > "$JW/f"
before="$(head_sha)"
( cd "$JW" && exec sleep 30 ) &   # a live "writer" holding the worktree as cwd
writer_pid=$!
sleep 0.3                          # let it establish cwd
run_keeper
kill "$writer_pid" 2>/dev/null || true; wait "$writer_pid" 2>/dev/null || true
[ "$(head_sha)" = "$before" ] && ok "HEAD untouched (real /proc cwd detected)" || bad "reset despite a proc holding the worktree"
grep -qiF "active writer" <<<"$OUT" && ok "the /proc scan reported the active writer" || bad "the /proc scan missed the cwd-holding process"
[ "$(alert_count)" -eq 0 ] && ok "NO page for the /proc-detected writer" || bad "paged on a /proc-detected writer"

# ============================================================================
hr; echo "DANGLING GITDIR — .git points at a defunct path: keeper repairs it"; hr
# A deploy that relocated the garden root can leave the journal worktree's .git
# gitdir pointing at the OLD checkout path while the backing entry stays intact,
# crash-looping every journal-touching service ("not a git repository:
# <old>/.git/worktrees/journal"). The keeper must run `git worktree repair` and
# leave the worktree on journal2 — not WARN-and-skip. Needs a real worktree (not
# the plain clone the other cases use), so build a bespoke fixture here.
rm -rf "$TR"; mkdir -p "$TR/state"
git init -q --bare "$UP"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
printf 'a\n' > "$SEED/f"
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m c1
git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin journal2
git -C "$UP" symbolic-ref HEAD refs/heads/journal2
rm -rf "$SEED"
ROOT="$TR/root"                                  # stands in for $GARDEN_ROOT
git clone -q "$UP" "$ROOT"
git -C "$ROOT" checkout -q --detach          # free journal2 for the worktree
git -C "$ROOT" "${git_id[@]}" worktree add -q "$ROOT/journal" journal2
write_alert_stub
# DANGLE the gitdir: rewrite journal/.git to a nonexistent prior-checkout path,
# mirroring the observed failure signature (backing entry left intact).
printf 'gitdir: %s/defunct-prior/.git/worktrees/journal\n' "$TR" > "$ROOT/journal/.git"
git -C "$ROOT/journal" rev-parse --git-dir >/dev/null 2>&1 \
  && bad "fixture: gitdir should be dangling pre-repair" \
  || ok "fixture: gitdir dangles before the keeper runs"
run_keeper GARDEN_ROOT="$ROOT" GARDEN_JOURNAL_WORKTREE="$ROOT/journal"
[ "$RC" -eq 0 ] && ok "exit 0 on a dangling-gitdir repair" || bad "exit $RC on dangling gitdir"
git -C "$ROOT/journal" rev-parse --git-dir >/dev/null 2>&1 \
  && ok "gitdir repaired (rev-parse --git-dir works again)" \
  || bad "gitdir still dangling after the keeper ran"
git -C "$ROOT/journal" config --get remote.origin.url >/dev/null 2>&1 \
  && ok "origin resolves through the worktree after the repair (no 'no origin' fatal)" \
  || bad "origin still unresolved after the repair"
[ "$(git -C "$ROOT/journal" rev-parse --abbrev-ref HEAD 2>/dev/null)" = journal2 ] \
  && ok "HEAD left on journal2 after the repair" \
  || bad "HEAD not on journal2 after the repair"
grep -qF "REPAIRED:" <<<"$OUT" && ok "logged the REPAIRED: self-heal line" || bad "did not log a REPAIRED: line"
[ "$(alert_count)" -eq 0 ] && ok "no maintainer page on a self-healed gitdir" || bad "paged despite a successful repair"

# ============================================================================
hr; echo "DANGLING GITDIR (owning checkout DELETED) — rebuilt from origin, no page"; hr
# The live 2026-07-03 incident: the checkout that OWNED the worktree was REMOVED
# (the root moved and the old one deleted, or $GARDEN_ROOT/.git/worktrees/ was
# wiped), so there is NO admin entry and `git worktree repair` fails outright. The
# keeper must PRUNE, back up the files still under the worktree, remove the stale
# dir, and re-`worktree add` it off origin/journal2 — losslessly, with no page.
rm -rf "$TR"; mkdir -p "$TR/state"
git init -q --bare "$UP"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
printf 'a\n' > "$SEED/f"
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m c1
git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin journal2
git -C "$UP" symbolic-ref HEAD refs/heads/journal2
rm -rf "$SEED"
ROOT="$TR/root"                                  # stands in for $GARDEN_ROOT
git clone -q "$UP" "$ROOT"
git -C "$ROOT" checkout -q --detach              # free journal2 for the worktree
git -C "$ROOT" "${git_id[@]}" worktree add -q "$ROOT/journal" journal2
write_alert_stub
# Content in the worktree that MUST survive the rebuild (a tracked-clean tree plus
# untracked WIP the backup has to capture).
printf 'agent WIP that must survive\n' > "$ROOT/journal/wip.md"
mkdir -p "$ROOT/journal/entries/2026/07"
printf 'a journal entry\n' > "$ROOT/journal/entries/2026/07/result.md"
# SIMULATE the owning-checkout deletion: wipe the admin entry AND dangle the
# forward pointer at a now-gone path, so `worktree repair` has nothing to re-link.
rm -rf "$ROOT/.git/worktrees"
printf 'gitdir: %s/gone-garden2/.git/worktrees/journal\n' "$TR" > "$ROOT/journal/.git"
git -C "$ROOT/journal" rev-parse --git-dir >/dev/null 2>&1 \
  && bad "fixture: gitdir should be dangling+unrepairable pre-run" \
  || ok "fixture: gitdir dangles with NO admin entry before the keeper runs"
run_keeper GARDEN_ROOT="$ROOT" GARDEN_JOURNAL_WORKTREE="$ROOT/journal"
[ "$RC" -eq 0 ] && ok "exit 0 on an owning-checkout-deleted rebuild" || bad "exit $RC on the rebuild"
git -C "$ROOT/journal" rev-parse --git-dir >/dev/null 2>&1 \
  && ok "worktree resolves its git dir after the rebuild" \
  || bad "worktree still broken after the rebuild"
[ "$(git -C "$ROOT/journal" rev-parse --abbrev-ref HEAD 2>/dev/null)" = journal2 ] \
  && ok "worktree re-established on journal2" || bad "worktree not on journal2 after rebuild"
[ "$(git -C "$ROOT/journal" rev-parse HEAD 2>/dev/null)" = "$(git -C "$ROOT/journal" rev-parse refs/remotes/origin/journal2 2>/dev/null)" ] \
  && ok "worktree HEAD reconciled to origin/journal2" || bad "worktree HEAD not at origin/journal2"
grep -qiF "rebuil" <<<"$OUT" && ok "logged the rebuild" || bad "did not log the rebuild"
[ "$(alert_count)" -eq 0 ] && ok "NO maintainer page on the lossless rebuild" || bad "paged on a lossless rebuild"
RB="$(latest_backup)"
[ -n "$RB" ] && [ -f "$RB/files/wip.md" ] && ok "present WIP captured in the backup" || bad "WIP not backed up before rebuild"
[ -n "$RB" ] && [ -f "$RB/files/entries/2026/07/result.md" ] && ok "nested entry captured in the backup" || bad "nested entry not backed up"

# ============================================================================
hr; echo "GUARD — rebuild refuses a worktree that is not \$GARDEN_ROOT/journal"; hr
# Re-break the (now-healthy) worktree, then point a DIFFERENT $GARDEN_ROOT at it so
# $JW != $GARDEN_ROOT/journal. The rebuild must REFUSE and leave the tree untouched
# — the destructive removal only ever fires on the canonical journal path.
rm -rf "$ROOT/.git/worktrees"
printf 'gitdir: %s/gone-garden2/.git/worktrees/journal\n' "$TR" > "$ROOT/journal/.git"
printf 'sentinel that must not be removed\n' > "$ROOT/journal/guard-sentinel.md"
mkdir -p "$TR/otherroot"; git init -q "$TR/otherroot"
run_keeper GARDEN_ROOT="$TR/otherroot" GARDEN_JOURNAL_WORKTREE="$ROOT/journal"
[ "$RC" -eq 0 ] && ok "exit 0 (never wedged) when the guard refuses" || bad "exit $RC on guard refusal"
[ -f "$ROOT/journal/guard-sentinel.md" ] && ok "refused: the non-canonical worktree left UNTOUCHED" || bad "guard removed a worktree outside \$GARDEN_ROOT/journal"
grep -qF "refusing to rebuild" <<<"$OUT" && ok "logged the guard refusal" || bad "did not log the guard refusal"

# ============================================================================
hr; echo "STALE PRUNABLE ADMIN ENTRY — the live 2026-07-03 /home/kris signature"; hr
# The EXACT observed incident: the root RELOCATED (/home/kris/garden2 -> /home/kris).
# $GARDEN_ROOT/journal's .git still points at the removed /home/kris/garden2/.git,
# AND the root repo's registered journal worktree points at a DIFFERENT, now-gone
# path (/home/kris/garden2/journal) that `git worktree list` reports as `prunable`.
# journal_remote() then died ("no origin on .../journal"), crash-looping orchestrate
# and every journal-touching service. The keeper must re-link the worktree back to
# $GARDEN_ROOT/journal (repair after prune clears the mismatched entry) and leave it
# on journal2 — never WARN-and-skip.
rm -rf "$TR"; mkdir -p "$TR/state"
git init -q --bare "$UP"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
printf 'a\n' > "$SEED/f"
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m c1
git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin journal2
git -C "$UP" symbolic-ref HEAD refs/heads/journal2
rm -rf "$SEED"
ROOT="$TR/root"                                  # stands in for $GARDEN_ROOT
git clone -q "$UP" "$ROOT"
git -C "$ROOT" checkout -q --detach
git -C "$ROOT" "${git_id[@]}" worktree add -q "$ROOT/journal" journal2
write_alert_stub
printf 'live agent WIP\n' > "$ROOT/journal/wip.md"          # untracked, must survive
# 1. $JW/.git points at the removed garden2/.git ...
printf 'gitdir: %s/garden2/.git/worktrees/journal\n' "$TR" > "$ROOT/journal/.git"
# 2. ... and the admin entry points at a DIFFERENT prunable path (garden2/journal).
printf '%s/garden2/journal/.git\n' "$TR" > "$ROOT/.git/worktrees/journal/gitdir"
git -C "$ROOT/journal" rev-parse --git-dir >/dev/null 2>&1 \
  && bad "fixture: gitdir should be dangling pre-run" \
  || ok "fixture: gitdir dangles with a prunable mismatched admin entry"
git -C "$ROOT" worktree list 2>/dev/null | grep -q prunable \
  && ok "fixture: registered journal worktree reports 'prunable'" \
  || bad "fixture: expected a prunable registered worktree"
run_keeper GARDEN_ROOT="$ROOT" GARDEN_JOURNAL_WORKTREE="$ROOT/journal"
[ "$RC" -eq 0 ] && ok "exit 0 on the stale-prunable-admin signature" || bad "exit $RC on the live signature"
git -C "$ROOT/journal" rev-parse --git-dir >/dev/null 2>&1 \
  && ok "gitdir re-linked (rev-parse --git-dir works again)" \
  || bad "gitdir still broken after the keeper ran"
[ "$(git -C "$ROOT/journal" rev-parse --abbrev-ref HEAD 2>/dev/null)" = journal2 ] \
  && ok "worktree left on journal2" || bad "worktree not on journal2 after repair"
[ "$(git -C "$ROOT/journal" rev-parse HEAD 2>/dev/null)" = "$(git -C "$ROOT/journal" rev-parse refs/remotes/origin/journal2 2>/dev/null)" ] \
  && ok "worktree HEAD reconciled to origin/journal2" || bad "worktree HEAD not at origin/journal2"
[ "$(alert_count)" -eq 0 ] && ok "no maintainer page on the self-healed live signature" || bad "paged despite a self-heal"
# The untracked WIP is either still in place (repair path, tree untouched) or
# recoverable from a backup (rebuild path) — never simply lost.
{ [ -f "$ROOT/journal/wip.md" ] || { RB="$(latest_backup)"; [ -n "$RB" ] && [ -f "$RB/files/wip.md" ]; }; } \
  && ok "untracked WIP preserved (in place or in the backup)" || bad "untracked WIP lost"

# ============================================================================
hr; echo "REBUILD ACTIVE-WRITER GATE — a live writer defers the destructive rebuild"; hr
# When the owning checkout is gone (rebuild path, not repair) AND a live agent holds
# the worktree as cwd, the keeper must NOT rm -rf it out from under the writer: defer
# this tick (the dangling tree is unusable anyway; the next tick rebuilds once the
# writer leaves). No removal, no page.
rm -rf "$TR"; mkdir -p "$TR/state"
git init -q --bare "$UP"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
printf 'a\n' > "$SEED/f"
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m c1
git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin journal2
git -C "$UP" symbolic-ref HEAD refs/heads/journal2
rm -rf "$SEED"
ROOT="$TR/root"
git clone -q "$UP" "$ROOT"
git -C "$ROOT" checkout -q --detach
git -C "$ROOT" "${git_id[@]}" worktree add -q "$ROOT/journal" journal2
write_alert_stub
printf 'writer sentinel that must not be removed\n' > "$ROOT/journal/writer-sentinel.md"
# Owning-checkout deletion -> forces the rebuild path (repair can't help).
rm -rf "$ROOT/.git/worktrees"
printf 'gitdir: %s/gone-garden2/.git/worktrees/journal\n' "$TR" > "$ROOT/journal/.git"
# Force the active-writer verdict deterministically (the /proc cwd scan is covered
# elsewhere; inject here to keep the test hermetic and fast).
run_keeper GARDEN_ROOT="$ROOT" GARDEN_JOURNAL_WORKTREE="$ROOT/journal" \
           GARDEN_JW_WRITER_PROBE=/bin/true
[ "$RC" -eq 0 ] && ok "exit 0 when a writer is active during a rebuild" || bad "exit $RC with an active writer"
[ -f "$ROOT/journal/writer-sentinel.md" ] && ok "rebuild deferred: worktree dir left UNTOUCHED" || bad "rm -rf'd a worktree a live writer holds"
grep -qiF "active writer" <<<"$OUT" && ok "logged the active-writer rebuild deferral" || bad "did not log the active-writer deferral"
[ "$(alert_count)" -eq 0 ] && ok "NO page on a transient active writer" || bad "paged on an active writer"

# ============================================================================
hr
echo "journal-worktree-keeper-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
