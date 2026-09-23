# Job board

The job board is the garden's distributed work queue. Producers (typically a [liaison](../../<garden-root>/roles/liaison/AGENT.md), a returning subagent, or a scheduled-engagement firing) post a job into `open/`; consumers ([steward](../../<garden-root>/roles/steward/AGENT.md), [general-contractor](../../<garden-root>/roles/general-contractor/AGENT.md)) race to claim it by moving it into `claimed/`, do the work in a per-job dispatch, and move it on to `done/` or `abandoned/` when the dispatch returns.

The board lives on the journal branch alongside the entries, inboxes, presence files, and worktree indices. Its lifecycle is the journal's lifecycle: append-and-commit, push, fetch, retry. The git push is the serialization point that resolves claim races between concurrent consumers across hosts and within the same host.

The full procedure (post / claim / complete / abandon) is in [`<garden-root>/skills/job-board/SKILL.md`](../../<garden-root>/skills/job-board/SKILL.md). This README is the contract.

## Layout

```
jobs/open/<UTC>--<short-id>--<slug>.md          # flat board; any eligible role may claim
jobs/claimed/<UTC>--<host>--<role>--<sid>--<short-id>--<slug>.md
jobs/done/<UTC>--<host>--<role>--<sid>--<short-id>--<slug>.md
jobs/abandoned/<UTC>--<host>--<role>--<sid>--<short-id>--<slug>.md

jobs/<role>/open/<UTC>--<short-id>--<slug>.md   # per-role board; only that role's workers claim
jobs/<role>/claimed/...                         # same per-bin structure under each role
jobs/<role>/done/...
jobs/<role>/abandoned/...
```

The flat board (`jobs/{open,claimed,done,abandoned}/`) is the original design; the per-role boards (`jobs/<role>/{open,claimed,done,abandoned}/`) are the layout `designs/driver.md` § Role-specific job boards adds for the script-orchestrated driver model. Both coexist during the migration. Initial per-role boards: `cleaner`, `judge`, `fixer`, `weaver`, `shepherd`, `conductor`; each has its own README. The judge board is the shared queue for the three judge-flavored roles (`solicitor`, `barrister`, `justice`).

- `<UTC>` is compact `YYYYMMDDTHHMMSSZ`, generated at the transition that moves the file into the directory (so the `open/` timestamp is post time; the `claimed/` timestamp is claim time; etc.).
- `<short-id>` is six hex characters, set at post time and preserved across moves. The job's identity for the whole lifecycle.
- `<slug>` is a short kebab-case description (one or two words). Survives the moves.
- `<host>` is `hostname -s` of the claiming consumer.
- `<role>` is the claimant's role (`steward`, `general-contractor`). Eligible producers are not consumers; eligible consumers may not all dispatch the same verbs (see *Eligibility*).
- `<sid>` is the first four hex chars of the claiming session's id (the same one `dispatch-prepare.sh` would use for a short-id). Distinguishes two same-role sessions on the same host racing for separate jobs.

A job's identity (`<short-id>`) is set once at post time and never changes. The filename grows on each transition; the short-id lets a future reader follow the job across the four directories with a single `find jobs/ -name '*<short-id>*'`.

## Frontmatter schema

```yaml
---
job: <short-id>                            # six hex chars; set once at post time
posted_by_role: <role>                     # the role that posted; e.g. liaison
posted_by_host: <host>                     # hostname of the posting session
posted_at: <ISO>                           # UTC; set once
verb: <verb>                               # the canonical orchestrator verb
project: <slug or null>                    # short kebab-case project slug
target:                                    # what the verb acts on; shape depends on the verb
  repo: <owner/name or null>
  pr: <int or null>
  issue: <int or null>
  design: <path or null>
authorizations:                            # forwarded into the dispatch prompt at claim time
  identity_switch: false                   # boatman only; default false
  comment_repos: []                        # per-action comment authorizations
priority: normal                           # normal | urgent
deadline: <UTC or null>                    # if the job becomes stale after this
eligible_roles:                            # which consumer roles may claim
  - steward
preconditions: []                          # human-readable; informational only
refs:                                      # journal entries the brief depends on
  - entries/<...>.md

# added at claim time (transition open/ → claimed/):
claimed_by_role: <role>
claimed_by_host: <host>
claimed_by_session: <sid>
claimed_at: <ISO>

# added at completion time (transition claimed/ → done/ or abandoned/):
result_entry: entries/<...>.md             # the dispatch's result entry
completed_at: <ISO>
outcome: done | abandoned
abandon_reason: <one line>                 # only present when outcome=abandoned
---

<body: the full brief the claiming consumer reads to build the dispatch prompt>
```

The body is the same brief shape that used to live in a `message: <role> → steward` entry. The job board does not change what gets said; it changes where the message lands so concurrent consumers can race.

## Eligibility

The producer's `eligible_roles:` list names which consumer roles may claim the job. Today's defaults:

- `steward` is eligible for every verb the steward's role file lists in its *Vocabulary* tables (`ferry`, `shepherd`, `judge`, `build`, `fix`, `weave`, `gamut`, `retcon`, `merge`, etc.).
- `general-contractor` is eligible for slot-fillable PR-pipeline verbs (`build`, `gamut`, `judge`, `fix`, `weave`, `shepherd`). The contractor's three-slot cap applies after claiming; jobs beyond the cap sit on the board until a slot frees.

A producer that does not know which roles are eligible defaults to `[steward]` only. The liaison's `skills/job-board/post-job.sh` helper sets the default; producers may override per job.

## Transitions

Each transition is one git commit that moves the file and edits its frontmatter. The transitions:

1. **Post** (no source → `open/`). Producer writes the file at `open/<post-UTC>--<short-id>--<slug>.md` with the *posted_by_*, *posted_at*, *verb*, *target*, *eligible_roles* fields populated. Commit message: `jobs: post <short-id> <verb> <slug>`.
2. **Claim** (`open/` → `claimed/`). Consumer fetches, verifies the file still exists in `open/`, runs `git mv` to `claimed/<claim-UTC>--<host>--<role>--<sid>--<short-id>--<slug>.md`, appends *claimed_by_** and *claimed_at* to the frontmatter, commits, and pushes. The push is the race resolution; rejected push means the consumer lost and resets.
3. **Complete-done** (`claimed/` → `done/`). After the dispatch returns successfully, the consumer runs `git mv` to `done/<done-UTC>--<host>--<role>--<sid>--<short-id>--<slug>.md`, appends *result_entry*, *completed_at*, and `outcome: done` to the frontmatter, commits, pushes.
4. **Complete-abandoned** (`claimed/` → `abandoned/`). When the consumer cannot finish (stall, missing precondition, deliberate decline), it transitions to `abandoned/<abandon-UTC>--...md` with `outcome: abandoned` and a one-line `abandon_reason:`. A new job (with a fresh short-id) may be re-posted by a producer; the board does not auto-recycle.

The four-directory structure is the producer-consumer signal: a glance at `ls open/` answers "what is available", and the bash poll daemon below diffs the listing across ticks to know when to wake the LLM Monitor.

## Claim race resolution

Two consumers see the same `open/X.md` and both try to claim it. Both run `git mv X.md claimed/.../X.md`, commit, push. The git push is serial against `origin/journal`: one push lands first, the other comes back rejected. The rejected pusher hard-resets to `origin/journal` (discarding its local claim commit) and moves on to the next open job, or back to idle.

The procedure is encoded in `<garden-root>/skills/job-board/SKILL.md` § Claim. Key invariants:

- The consumer does **not** retry-with-rebase on a rejected claim push. The whole point of the rejection is that someone else got the job. Retrying would force-fight for ownership the loser already lost.
- The hard-reset is safe because the loser only created one commit (the claim commit) since the prior fetch. The reset throws away exactly that commit.
- The consumer does **not** edit the open-side file before the move. The frontmatter additions (`claimed_by_*`, `claimed_at`) are made in the destination path after `git mv`. This keeps the move atomic from git's perspective.

If neither consumer can land the claim after a small number of retries (the race interleaves badly under heavy concurrency), both back off; the job stays in `open/` for the next claim attempt. The bash daemon's next `NEW` line wakes them again.

## Bash poll daemon

A long-lived `skills/job-board/job-board-poll.sh` daemon runs on every host that hosts a consumer. It is parallel in shape to `skills/github-activity-poll/monitor-poll.sh`:

- Polls `git -C journal fetch --quiet origin journal && ls journal/jobs/open/` on its cadence (default 30 s).
- Writes `[HH:MM:SS] NEW <path>` to `/tmp/garden-jobs.log` for every new filename that appeared since the last tick. Removes that disappear (because someone else claimed) write `[HH:MM:SS] GONE <path>`.
- The consumer's parent-context Monitor tails `/tmp/garden-jobs.log` and emits one notification per new line; the consumer reacts by attempting a claim.

The daemon survives across LLM ticks; state is the prior `ls` output written to `/tmp/garden-jobs-<host>.state`. PID file `/tmp/garden-jobs.pid`. The daemon is restarted on the same liveness-check discipline the steward uses for the standing monitors (`roles/steward/AGENT.md` § Standing monitors).

## Where things are

| Path                                                                                          | Owner                                                                  | What it carries                                                  |
| --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------- |
| `journal/jobs/open/`                                                                          | producers (any role with `skills/job-board/post-job.sh`)               | available jobs                                                   |
| `journal/jobs/claimed/`                                                                       | consumers (steward / general-contractor)                  | jobs in flight                                                   |
| `journal/jobs/done/` and `journal/jobs/abandoned/`                                            | consumers                                                              | terminal states; append-only archive                             |
| `<garden-root>/skills/job-board/SKILL.md`                                                     | gardener                                                               | procedural detail                                                |
| `<garden-root>/skills/job-board/{post-job,claim-job,job-board-poll}.sh`                       | gardener                                                               | the helper scripts                                               |
| `/tmp/garden-jobs.{pid,log,err,state}`                                                        | bash daemon                                                            | poll state                                                       |

## Inventory cap

A board with hundreds of open jobs is a signal the consumer set is undersized; a board with zero open jobs for a long stretch is the steady state. There is no hard cap, but jobs older than their `deadline:` should be triaged by the next consumer cycle that sees them (the bulletin's *Awaits maintainer decision* section is the escalation surface, not this board).

## Composition with the message bus

The job board carries **work items** (do something). The inbox (`journal/inboxes/<host>/<role>.md`, drained via `skills/inbox-drain/SKILL.md`) carries **directed communication** (FYI, decision, retro, reply from a subagent). The two channels are orthogonal:

- A producer asking the steward to "do gamut on #N" posts a job. Old pattern: `message: liaison → steward`.
- A subagent reporting "my dispatch encountered X" writes a `message` entry. New pattern: still a message.
- A retro lesson ("the inbox-drain Monitor failed again") is a message to the liaison or to `*`. Still a message.

The role files name the channel selection explicitly (`roles/liaison/AGENT.md` § Posting jobs; `roles/steward/AGENT.md` § Job-board claim discipline). When in doubt, ask: *would a producer expect a specific role to act on this?* If yes, post a job. If the producer just wants the message read, write a message.
