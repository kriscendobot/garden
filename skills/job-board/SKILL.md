---
created: 2026-05-18
updated: 2026-05-18
author: gardener
---

# Skill: job-board

Post, claim, and complete jobs on the journal's distributed work queue at `journal/jobs/`. The board is the producer-consumer channel for *work items*; the inbox (`skills/inbox-drain/SKILL.md`) remains the channel for *directed communication*. This skill is the canonical procedure; the contract and frontmatter schema live in `journal/jobs/README.md`.

The skill has three call sites:

- **Post a job** (`post-job.sh`): producers write a brief into `open/` and push. Used by the liaison most often, and by any returning subagent (or scheduled-engagement firing) that needs steward-shaped work picked up later.
- **Claim a job** (`claim-job.sh`): consumers race for an open job. The push to `origin/journal` is the serialization point; the loser falls back without retry.
- **Complete a job** (`complete-job.sh`): consumers transition a claimed job to `done/` or `abandoned/` after the dispatch returns.

A long-running poll daemon (`job-board-poll.sh`, parallel to `skills/github-activity-poll/monitor-poll.sh`) feeds a parent-context Monitor on each consumer host so idle consumers wake within ~30 s of a job posting.

## Inputs

### `post-job.sh <verb> <slug> [--repo <owner/name>] [--pr <N>] [--design <path>] [--project <slug>] [--eligible <role>[,<role>...]] [--priority urgent|normal] [--deadline <ISO>]`

Reads the job's body from stdin. The producer's role and host are read from `git config --get user.name` and `hostname -s`. Writes the file to `<garden-root>/journal/jobs/open/<UTC>--<short-id>--<slug>.md`, commits, pushes. Prints the resulting path on stdout.

### `claim-job.sh <open-path>`

`<open-path>` is the path the consumer learned about from the bash daemon's `NEW` line (relative to the journal worktree, e.g. `jobs/open/20260518T231500Z-a1b2c3-gamut-289.md`). The consumer's role is read from the calling shell's environment (`GARDEN_ROLE`, set by the consumer's bootstrap), the host from `hostname -s`, and a fresh `<sid>` is generated. Prints the resulting `claimed/...` path on stdout, or exits non-zero with `lost-race` on rejection.

### `complete-job.sh <claimed-path> <outcome> [--result-entry <path>] [--abandon-reason "<one line>"]`

`<outcome>` is `done` or `abandoned`. The result entry path (for `done`) names the journal entry the consumer's dispatch wrote. The abandon reason (for `abandoned`) is a one-line explanation. Prints the resulting `done/...` or `abandoned/...` path.

### `job-board-poll.sh <cadence-seconds>`

The daemon. Polls `git -C journal fetch --quiet origin journal && ls journal/jobs/open/` on the cadence; emits `NEW <path>` and `GONE <path>` lines to stdout (which the operator wires to `/tmp/garden-jobs.log`). State is written under `/tmp/garden-jobs-<host>.state` so the daemon can compare `ls` outputs across ticks.

## State

- The board's authoritative state is the journal's HEAD: which paths exist under `jobs/open/`, `jobs/claimed/`, `jobs/done/`, `jobs/abandoned/`.
- The daemon's per-tick state is `/tmp/garden-jobs-<host>.state` (a copy of the prior `ls` output). Recreated freely on daemon restart; one missed tick at most.
- Each consumer's claim is recorded in two places: the destination path under `claimed/` (the durable record on the journal) and the consumer's per-job dispatch root (ephemeral).

## Procedure

All commands assume `$JRN` is the journal worktree (`<garden-root>/journal/` for orchestrators, `<dispatch-root>/journal/` for subagents).

### 1. Post

```sh
SHORT=$(openssl rand -hex 3)
UTC=$(date -u +%Y%m%dT%H%M%SZ)
NAME="${UTC}--${SHORT}--${SLUG}.md"
DEST="$JRN/jobs/open/$NAME"

# Write the frontmatter + body file. Body is the brief from stdin.
{
  printf -- '---\n'
  printf 'job: %s\n' "$SHORT"
  printf 'posted_by_role: %s\n' "$ROLE"
  printf 'posted_by_host: %s\n' "$(hostname -s)"
  printf 'posted_at: %s\n' "$(date -u -Iseconds | sed 's/+00:00/Z/')"
  printf 'verb: %s\n' "$VERB"
  printf 'project: %s\n' "${PROJECT:-null}"
  printf 'target:\n'
  printf '  repo: %s\n' "${REPO:-null}"
  printf '  pr: %s\n' "${PR:-null}"
  printf '  issue: %s\n' "${ISSUE:-null}"
  printf '  design: %s\n' "${DESIGN:-null}"
  printf 'authorizations:\n'
  printf '  identity_switch: %s\n' "${IDENTITY_SWITCH:-false}"
  printf '  comment_repos: []\n'
  printf 'priority: %s\n' "${PRIORITY:-normal}"
  printf 'deadline: %s\n' "${DEADLINE:-null}"
  printf 'eligible_roles:\n'
  for r in "${ELIGIBLE[@]}"; do printf '  - %s\n' "$r"; done
  printf 'preconditions: []\n'
  printf 'refs: []\n'
  printf -- '---\n\n'
  cat
} > "$DEST.tmp"
mv "$DEST.tmp" "$DEST"

# Sync, commit, push via the standard journal-sync retry loop.
git -C $JRN fetch --quiet origin journal
git -C $JRN reset --hard origin/journal     # safe; no local edits yet
mv "$DEST" "$DEST"                          # re-publish if reset clobbered (rare)
git -C $JRN add "jobs/open/$NAME"
git -C $JRN commit -m "jobs: post $SHORT $VERB $SLUG"
for i in 1 2 3 4 5; do
  git -C $JRN push origin HEAD:journal && break
  git -C $JRN fetch --quiet origin journal
  git -C $JRN rebase origin/journal || { git -C $JRN rebase --abort; sleep $((i*i)); }
done
```

Post failures are exceptional; the producer reports them upward and tries again. There is no race on posting (each post has a fresh short-id and a fresh filename, so concurrent posts do not collide on path).

### 2. Claim

```sh
SOURCE="$1"                                 # jobs/open/<UTC>--<sid>--<slug>.md
SHORT=$(basename "$SOURCE" | awk -F-- '{print $2}')
SLUG=$(basename "$SOURCE" .md | awk -F-- '{print $3}')
HOST=$(hostname -s)
ROLE=${GARDEN_ROLE:?GARDEN_ROLE not set}
SID=$(openssl rand -hex 2)
UTC=$(date -u +%Y%m%dT%H%M%SZ)
ISO=$(date -u -Iseconds | sed 's/+00:00/Z/')
DEST="jobs/claimed/${UTC}--${HOST}--${ROLE}--${SID}--${SHORT}--${SLUG}.md"

# Resync. A claim from stale HEAD is a lost race waiting to happen.
git -C $JRN fetch --quiet origin journal
git -C $JRN reset --hard origin/journal

# Verify the job is still on the board.
test -f "$JRN/$SOURCE" || { echo "lost-race"; exit 1; }

# Move and stamp.
git -C $JRN mv "$SOURCE" "$DEST"
# Append claim frontmatter after the existing frontmatter close (line "---" at top of file).
awk -v r="$ROLE" -v h="$HOST" -v s="$SID" -v t="$ISO" '
  /^---$/ { count++ }
  count == 2 && !done {
    print "claimed_by_role: " r
    print "claimed_by_host: " h
    print "claimed_by_session: " s
    print "claimed_at: " t
    done = 1
  }
  { print }
' "$JRN/$DEST" > "$JRN/$DEST.tmp" && mv "$JRN/$DEST.tmp" "$JRN/$DEST"
git -C $JRN add -A "$DEST" "$SOURCE"
git -C $JRN commit -m "jobs: claim $SHORT on $HOST/$ROLE/$SID"

# Push. Rejection = lost race; do not retry.
if ! git -C $JRN push origin HEAD:journal 2>/dev/null; then
  git -C $JRN reset --hard origin/journal   # discard the local claim commit
  echo "lost-race"
  exit 1
fi
echo "$DEST"
```

**Crucial:** push rejection is the signal that *another consumer's claim landed first*. Resetting hard is correct; rebasing would attempt to re-apply the loser's `mv` against a file that no longer exists in `open/`, surfacing a conflict that the loser cannot resolve anyway (it would just be force-fighting a settled race).

### 3. Complete

```sh
SOURCE="$1"                                 # jobs/claimed/<...>.md
OUTCOME="$2"                                # done | abandoned
DEST_DIR="jobs/$OUTCOME"
NAME=$(basename "$SOURCE")
# Replace the leading claim-UTC with a fresh completion-UTC.
COMPLETE_UTC=$(date -u +%Y%m%dT%H%M%SZ)
NEW_NAME="${COMPLETE_UTC}--${NAME#*--}"
DEST="${DEST_DIR}/${NEW_NAME}"
ISO=$(date -u -Iseconds | sed 's/+00:00/Z/')

git -C $JRN fetch --quiet origin journal
git -C $JRN rebase origin/journal || { git -C $JRN rebase --abort; echo "complete: rebase conflict"; exit 1; }

git -C $JRN mv "$SOURCE" "$DEST"
{
  cat "$JRN/$DEST"
  printf '\n# Completion stamp\n'
  printf 'completed_at: %s\n' "$ISO"
  printf 'outcome: %s\n' "$OUTCOME"
  [ -n "$RESULT_ENTRY" ] && printf 'result_entry: %s\n' "$RESULT_ENTRY"
  [ -n "$ABANDON_REASON" ] && printf 'abandon_reason: %s\n' "$ABANDON_REASON"
} > "$JRN/$DEST.tmp" && mv "$JRN/$DEST.tmp" "$JRN/$DEST"
# The completion-stamp lines land at the body's end, not in the frontmatter, on purpose:
# tightly-typed frontmatter parsers might choke on a re-opened frontmatter block. The
# body's terminal stamp is grep-able and human-readable and does not collide with the
# header's existing fields.
git -C $JRN add -A "$DEST" "$SOURCE"
git -C $JRN commit -m "jobs: $OUTCOME $SHORT"
for i in 1 2 3 4 5; do
  git -C $JRN push origin HEAD:journal && break
  git -C $JRN fetch --quiet origin journal
  git -C $JRN rebase origin/journal || { git -C $JRN rebase --abort; sleep $((i*i)); }
done
echo "$DEST"
```

Completion is never racy: only the claiming consumer holds the path in `claimed/`, so its move into `done/` or `abandoned/` cannot collide with another consumer. The retry-on-rejection loop is the standard journal-sync shape; rejections here come from sister commits to *other* journal paths (entries, inbox state files, other jobs), not from this completion.

### 4. The bash poll daemon (`job-board-poll.sh`)

```sh
CADENCE=${1:-30}
JRN=${GARDEN_ROOT:?GARDEN_ROOT not set}/journal
STATE=/tmp/garden-jobs-$(hostname -s).state
trap 'echo "[$(date -u +%H:%M:%S)] job-board-poll stopping pid=$$"; exit 0' INT TERM
echo "[$(date -u +%H:%M:%S)] job-board-poll starting cadence=${CADENCE}s pid=$$"
touch "$STATE"
while true; do
  git -C "$JRN" fetch --quiet origin journal 2>/dev/null || true
  CUR=$(ls "$JRN/jobs/open/" 2>/dev/null | sort)
  if ! diff -q <(echo "$CUR") "$STATE" >/dev/null 2>&1; then
    PREV=$(cat "$STATE")
    comm -23 <(echo "$CUR") <(echo "$PREV") | while read f; do
      [ -n "$f" ] && echo "[$(date -u +%H:%M:%S)] NEW jobs/open/$f"
    done
    comm -13 <(echo "$CUR") <(echo "$PREV") | while read f; do
      [ -n "$f" ] && echo "[$(date -u +%H:%M:%S)] GONE jobs/open/$f"
    done
    echo "$CUR" > "$STATE"
  fi
  sleep "$CADENCE"
done
```

The daemon is wired by the consumer's bootstrap, parallel to the existing standing-monitor daemons. PID file `/tmp/garden-jobs.pid`. The Monitor in the consumer's parent context tails `/tmp/garden-jobs.log` for `^[^ ]* NEW` (and optionally `GONE`); each match becomes a notification the consumer reacts to with a claim attempt.

## Consumer-side wiring

The idle consumer (steward / understudy / general-contractor) keeps the parent-context Monitor tailing `/tmp/garden-jobs.log`. On a `NEW` line:

1. Run `claim-job.sh <path>`.
2. On `lost-race` (or any other failure), move on; the daemon's next `NEW` line is the next attempt.
3. On success, the printed `claimed/` path is the brief. Read it.
4. Build a per-job dispatch root via `skills/dispatch-worktree/SKILL.md`, dispatch the appropriate subordinate role (`fixer`, `builder`, `boatman`, etc.) with the brief inlined as the dispatch prompt. The dispatch's authorizations come from the job's `authorizations:` frontmatter.
5. Await the subagent's return. Write the standard `result` entry to the journal (citing the job's short-id in `refs:`).
6. Run `complete-job.sh <claimed-path> done --result-entry <path>` (or `abandoned ...`).
7. Tear down the dispatch root via `dispatch-teardown.sh`.
8. **`/clear` the consumer's context** (see *Consumer context-clear* below) and return to idle at the designated workspace.

The consumer never holds per-job substance in its own context across jobs. Identity (the role file's bootstrap), watch state (which Monitors are armed), and the presence file are the only things that survive `/clear`.

## Consumer context-clear

The decision recorded in the 2026-05-18 design conversation is that consumers do **per-job dispatch into a fresh subagent**. The consumer's parent context is the orchestrator's identity + Monitor state; the per-job content lives entirely in the dispatch subagent's context.

Mechanically:

- The consumer does not need to issue a literal `/clear` at job end. The per-job substance is in the dispatch subagent (which is torn down with the dispatch root); the consumer's own context only ever accreted the job's brief frontmatter and the dispatch-prep / dispatch-teardown commands.
- If a consumer's own context does accrete substance over many jobs (because the consumer chose to read the brief in detail rather than forward it verbatim), a `/clear` between jobs is the discipline. Stated on `roles/steward/AGENT.md` § Consumer context-clear; the harness implements the clear.
- Either way, the consumer reads its role file (`roles/steward/AGENT.md` after `/clear`) and its presence file (`journal/presence/<host>/steward.md`) on every bootstrap to re-anchor identity and watch state. The presence file's prose body names the designated workspace path (`/home/kris` on bot hosts) and the bootstrap order.

## Workspace check

Every consumer cycle starts by verifying the workspace is where the role expects it:

```sh
# Workspace = the host's garden root, named in the presence file.
WORKSPACE=$(awk '/^workspace_path:/ { print $2; exit }' \
  journal/presence/$(hostname -s)/steward.md)
test "$(pwd)" = "$WORKSPACE" || { echo "workspace drift; pwd=$(pwd) expected=$WORKSPACE"; exit 1; }

# Branch = main.
test "$(git -C $WORKSPACE branch --show-current)" = main || \
  { echo "branch drift; expected main"; exit 1; }

# Checkout at origin/main.
git -C $WORKSPACE fetch --quiet origin main
behind=$(git -C $WORKSPACE rev-list --count HEAD..origin/main)
ahead=$(git -C $WORKSPACE rev-list --count origin/main..HEAD)
if [ "$behind" -gt 0 ] && [ "$ahead" -eq 0 ]; then
  git -C $WORKSPACE pull --ff-only origin main
elif [ "$ahead" -gt 0 ]; then
  echo "workspace ahead of origin/main by $ahead; refusing to act"
  exit 1
fi
```

The check catches the failure modes the 2026-05-17 stuck-rebase incident produced: a working tree pinned behind HEAD because of an interactive rebase, a detached HEAD that should have been on `main`, a fork commit that drifted ahead of origin and would be silently overwritten on a fast-forward. The role file names this check; the skill is the procedure.

## Pitfalls

- **Editing the body in the `open/` file**. A consumer that reads the body verbatim into its own context (rather than forwarding it as the dispatch prompt unchanged) pollutes its context with per-job substance. The discipline is to *forward without reading*: the consumer's `claim-job.sh` returns a path; the consumer passes that path through `dispatch-prepare.sh` into the subagent's prompt; the subagent reads the body. The consumer reads only the frontmatter (verb, target, authorizations) to pick the subordinate role and forward authorizations.
- **Re-posting an abandoned job from a stale memory of its short-id**. The board does not auto-recycle. If a previously-abandoned job needs another try, a producer posts a *new* job with a fresh short-id and a `refs:` entry to the abandoned one. Recycling the same short-id would defeat the dedup.
- **Two consumers on the same host with the same role**. The `<sid>` in the claim path distinguishes them. They race for the same `open/` files; the `<sid>` lets a later reader (or the consumers themselves) tell their respective in-flight claims apart.
- **Producer eligibility off-the-shelf**. The default eligible-roles is `[steward]`. Producers wanting wider eligibility (e.g. an understudy claim) set `--eligible steward,understudy` explicitly; this is mostly a liaison job, since the liaison knows the maintainer's intent on who should pick up the work.

## Notes from the field

(Append; terse and dated.)

- _2026-05-18_: initial bootstrap. The board's three transitions all hinge on `git push origin HEAD:journal` as the serialization point. We will see this stress-test once two stewards are running concurrently; the current single-steward state has no race to lose. The maintainer's framing was clear that this design is meant to scale to multiple hosts and multiple same-host sessions.
