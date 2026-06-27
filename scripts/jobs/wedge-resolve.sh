# shellcheck shell=bash
# wedge-resolve.sh — shared autonomous dirty-tree-wedge resolution trigger.
#
# Sourced (never executed) by watchman.sh and deploy-sync.sh. Both reconcilers
# advance the shared $GARDEN_ROOT checkout to origin/main2 by a strict clean
# fast-forward; both stall when the live tree is wedged by an uncommitted TRACKED
# edit (or an UNTRACKED file colliding with an incoming tracked path). These
# wedges recur constantly under the live ~100-gardener fleet (gardeners that edit
# the SHARED tree instead of an isolated worktree) and they are mechanically
# resolvable.
#
# Maintainer directive 2026-06-27: "the watchmen needs to solve these problems
# autonomously and the maintainers do not need to be in the loop." So on a wedge
# we do NOT email the maintainer — we POST a high-priority resolve-wedge job to
# the board. A claude-driven gardener claims it and performs the finisher dance
# (lossless checkout/rm for redundant copies of landed work; preserve genuine WIP
# via an isolated-worktree commit or a stash). The fleet keeps running while the
# tree is wedged (a wedge only blocks picking up NEW code), so a posted job is
# claimed promptly. Reading the garden's OWN uncommitted code is safe (not
# untrusted external content), so a claude resolver here is not a prompt-injection
# concern.
#
# Idempotent reconcile between the two reconcilers: the job basename is derived
# deterministically from (host, target SHA, blocking paths), and post-job.sh is a
# no-op when that basename already exists anywhere in the lifecycle — so whichever
# of watchman/deploy-sync sees the wedge first posts, and the other's post folds
# into it. A local throttle marker (mirroring the old dirty-notified marker)
# avoids even calling post-job twice for the same wedge signature, so a persistent
# UNRESOLVABLE wedge does not spin: the posted job is retried by the reaper's
# stale-claim requeue, not by re-posting.

# Injectable so tests can mock the producer; defaults to the real board producer.
: "${GARDEN_POST_JOB:=$GARDEN_ROOT/scripts/jobs/post-job.sh}"

# A filesystem- and git-ref-safe slug.
_wedge_slug() { printf '%s' "$1" | tr -c 'A-Za-z0-9._-' '-' | tr -s '-' | sed 's/^-//; s/-$//'; }

# trigger_wedge_resolution <from-sha> <to-sha> <reason> <blocking-paths>
#
# Posts (once per wedge signature) a resolve-wedge job describing this host's
# dirty-tree wedge and the lossless finisher procedure. Returns 0 when the job is
# posted or already throttled/present; non-zero only when the post itself failed.
trigger_wedge_resolution() {
  local from="$1" to="$2" reason="$3" paths="$4"
  local pathsum; pathsum="$(printf '%s' "$paths" | cksum | tr -d ' ' | cut -d' ' -f1)"
  local sig="$to:$pathsum"

  # Throttle: same wedge signature already posted from this host? do nothing.
  local marker="$GARDEN_STATE/wedge-resolve/posted-$GARDEN_MAIN_BRANCH"
  if [ "$(cat "$marker" 2>/dev/null || true)" = "$sig" ]; then
    log "wedge-resolve already posted for this state ($sig); not re-posting"
    return 0
  fi
  mkdir -p "$(dirname "$marker")"

  local base; base="$(_wedge_slug "resolve-wedge-$GARDEN_HOST-${to:0:12}-$pathsum")"
  local body; body="$(mktemp "${TMPDIR:-/tmp}/wedge-resolve.XXXXXX")"
  {
    printf '# Autonomous wedge resolution — clean the shared %s tree on host %s\n\n' "$GARDEN_MAIN_BRANCH" "$GARDEN_HOST"
    printf 'HIGH PRIORITY. The shared garden checkout at `%s` (branch `%s`) is WEDGED:\n' "$GARDEN_ROOT" "$GARDEN_MAIN_BRANCH"
    printf 'origin advanced to `%s` but the live tree is stuck at `%s` — %s.\n' "$to" "$from" "$reason"
    printf 'Until the tree is clean this host will NOT pick up new roles/skills/scripts\n'
    printf '(the deploy reconcilers fast-forward only a clean tree).\n\n'
    if [ -n "$paths" ]; then
      printf 'Blocking change(s):\n```\n%s\n```\n\n' "$paths"
    else
      printf 'No tracked WIP, yet the fast-forward was refused — typically an UNTRACKED\n'
      printf 'file colliding with an incoming tracked path.\n\n'
    fi
    cat <<EOF
## What to do

The mechanical, LOSSLESS part is already scripted. Run it first — it operates
directly on the shared tree at \`$GARDEN_ROOT\` (the ONE case where editing the
shared tree in place is correct: you are CLEANING it, not adding work):

    "$GARDEN_ROOT/scripts/jobs/resolve-wedge.sh" $GARDEN_MAIN_BRANCH

It re-surveys the tree and resolves EACH blocking path individually:
  * a tracked edit byte-identical to \`origin/$GARDEN_MAIN_BRANCH\` (a redundant
    copy of landed work) → \`git checkout HEAD -- <file>\`;
  * an untracked file byte-identical to its incoming \`origin/$GARDEN_MAIN_BRANCH\`
    version → \`rm\` it;
  * GENUINE WIP (differs from both HEAD and origin) → PRESERVED, never discarded:
    a tracked file is \`git stash push\`ed; a divergent untracked collision is
    moved into \`$GARDEN_SCRATCH\`. The script reports each preserved item on stderr.

It NEVER does a blind \`git reset --hard\`, \`git checkout .\`, or \`git clean -fd\`,
and it touches ONLY the blocking file(s). On exit 0 the tree is clean and the
watchman / deploy-sync fast-forward proceeds on its next tick.

## Your one judgment call: land the preserved WIP

If \`resolve-wedge.sh\` reported stashed or preserved WIP, decide per item whether
it is coherent work that should LAND on \`$GARDEN_MAIN_BRANCH\`:
  * If so, recover it (\`git -C "$GARDEN_ROOT" stash show -p\` / the off-tree copy),
    apply it in an ISOLATED worktree off \`origin/$GARDEN_MAIN_BRANCH\`, commit with
    an EXPLICIT pathspec (\`git commit -m '…' -- <paths>\`), and push
    HEAD:$GARDEN_MAIN_BRANCH through a \`git pull --rebase\`/push CAS loop.
  * If it is not yet coherent, LEAVE the stash / off-tree copy in place and note it
    in your report so it is not lost. Never discard it.

If \`resolve-wedge.sh\` exits non-zero (tracked dirt it could not classify
remains), re-survey by hand, resolve only the specific blocking file(s) the same
lossless way, and STOP if any unrelated tracked file is unexpectedly dirty.
EOF
  } > "$body"

  if GARDEN_SENDER=wedge-resolve "$GARDEN_POST_JOB" "$base" "$body" >/dev/null 2>&1; then
    printf '%s\n' "$sig" > "$marker"
    log "posted resolve-wedge job '$base' (autonomous; maintainer NOT paged)"
    rm -f "$body"
    return 0
  else
    log "WARN: could not post resolve-wedge job '$base'"
    rm -f "$body"
    return 1
  fi
}
