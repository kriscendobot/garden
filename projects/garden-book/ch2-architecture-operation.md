---
created: 2026-09-30
author: gardener (job book-ch2, orchestration garden-book-orch)
grounded-on: main2 2a5c1991779
---

# Chapter 2: Architecture and operation

This chapter explains how the garden actually runs: where work is recorded,
how many workers on many hosts share it without a lock server, how messages
move, which services run where, and how a new version of the garden reaches a
running fleet. It is written for a reader who needs to operate or change the
machinery, so it names real script paths and journal locations throughout.

It is grounded in [`CLAUDE.md`][claude-md] (§ Layout, § How work reaches
workers, § Job system), the [job-board][job-board] and
[message-bus][message-bus] skills, [`WORKTREES.md`][worktrees], and the two
architecture designs [`designs/job-board.md`][design-job-board] and
[`designs/gardening-state-machine.md`][design-gsm]. When this chapter and
those files disagree, the files win: they are what the fleet executes.

Paths below are relative to the garden root (`<garden-root>`, the bot user's
home directory) unless they start with `jobs/`, `inbox/`, `msgs/`, or another
journal directory, in which case they are relative to the root of the
`journal2` branch.

## Contents

- [2.1 The journal as job board and message bus](#21-the-journal-as-job-board-and-message-bus)
- [2.2 The job lifecycle](#22-the-job-lifecycle)
- [2.3 The gardener fleet](#23-the-gardener-fleet)
- [2.4 The message bus](#24-the-message-bus)
- [2.5 Fleet topology: leaders, followers, and the sysop](#25-fleet-topology-leaders-followers-and-the-sysop)
- [2.6 The deliberate deploy](#26-the-deliberate-deploy)
- [2.7 Summary of invariants](#27-summary-of-invariants)

## 2.1 The journal as job board and message bus

### One branch, three jobs

The garden repository (`github.com/kriscendobot/garden`) has two long-lived
branches that never merge:

- **`main2`** holds the library: `roles/`, `skills/`, `scripts/`, `designs/`,
  `context/`. This is code and prose that agents read.
- **`journal2`** is an **orphan** branch (no shared history with `main2`)
  holding the garden's *state*. It is checked out as a worktree at
  `<garden-root>/journal/`.

The journal does three things at once:

1. **It is the transcript.** `entries/<Y>/<M>/<D>/…` holds progress
   narration written by `scripts/jobs/journal-entry.sh`.
2. **It is the job board.** `jobs/{todo,doin,tada}/` is the work queue, with
   `jobs/plan/` for parked work (§ 2.2).
3. **It is the message bus.** `inbox/<doer>/{unread,read}/` holds directed
   mail, `msgs/role/<r>/` and `msgs/broadcast/` hold fan-out topics, and
   `msgs/host/<GARDEN>/` carries host-directed operations for the sysop
   (§ 2.4, § 2.5).

Around those sit the rest of the fleet's shared state, all on the same
branch: `repos/<slug>` (the watch set; adding a file arms the watchers,
removing it disarms them), `hosts/<GARDEN>` (per-host worker counts),
`leader` (the leader marker, § 2.5), `schedules/` (recurring jobs),
`jobs/orch/` (orchestration records), `jobs/index/` (the directive-identity
map, below), `work/<base>` (per-job in-flight state), and `deploy/roll/`
(rolling-deploy release tokens, § 2.6). The design lists the core layout in
[`designs/job-board.md`][design-job-board] § 1.

Using git for all of this means the whole coordination state is versioned,
auditable (`git log` on `journal2` is a complete history of who claimed what
and when), replicated to every host by ordinary fetch, and requires no
database or queue service. The price is that every mutation is a commit and a
push, and the design has to make concurrent pushes safe. That is the subject
of the rest of this section.

### The basename is the spine

Every unit of work has a **basename** (`<base>`), a short, deterministic,
extensionless name such as `build-foo` or `book-ch2`. Board files carry
`.md` (`jobs/todo/<base>.md`), but the basename alone ties together every
artifact belonging to that job:

```
jobs/todo/<base>.md → jobs/doin/<base>.md → jobs/tada/YYYY/MM/DD/<base>.md
work/<base>                       in-flight state
inbox/<base>/{unread,read}/       the doer's mailbox
scratch/gardener-wt-<base>/       the per-job garden worktree
scratch/project-wt-<base>-<digest>/  the per-job project worktree
```

Because the name is derived from the identity of the change, posting the same
ask twice is a no-op: `scripts/jobs/post-job.sh` refuses a basename that
already exists anywhere in `todo/`, `doin/`, `plan/`, or `tada/`. That
idempotency is what lets the liaison re-issue a request after a `/clear`
without creating duplicate work.

It cuts both ways. For **one-shot** work (`design-X`, `build-X`, a specific
fix) the bare name is correct and must never be date-suffixed, since that
would break the no-op property. For a **recurring verb against the same
target** (`weave`, `shepherd`, `conduct`, a restack, a `retcon`), this
month's invocation is different work from last month's but derives the same
bare base; if the earlier one is in `tada/`, the new post is **silently
swallowed**. Those bases get a disambiguator, conventionally an ISO date
`-YYYYMMDD` ([job-board][job-board] § Basename shape). The deterministic
producers already handle this: the scheduler stamps
`${prefix}-YYYYMMDD-HHMMSS`, the pages-watcher keys on the commit SHA, and the
comment and CI watchers pass a directive identity (below). `post-job.sh` and
`post-plan.sh` emit a loud WARN when a post collides with a completed job, so
a scripted loop cannot let the swallow pass unnoticed.

A second dedup layer catches **different names for the same directive**. Two
producers (say, the comment-watcher and a hand-posting liaison) can name one
PR comment's work differently, and basename idempotency cannot see that they
are the same. `post-job.sh --identity <owner>/<repo>#<pr>:comment:<cid>` (or
`…:review:<id>`, or `GARDEN_JOB_IDENTITY`) records the identity in
`jobs/index/<hash>`, written in the same commit as the job; a later post with
the same identity while its job is live, or after it completed, is a no-op.
When no identity is passed, one is derived from the body if it cites exactly
one canonical GitHub comment URL. This closed the endo-but-for-bots #58
incident, where two differently-named jobs for one comment raced and one
worker clobbered the other's working tree.

### The push is the compare-and-swap

A local `git mv jobs/todo/X jobs/doin/X` is atomic on one filesystem, but
nobody else can see it until it is pushed. The real serialization point is
the **`git push` to `origin/journal2`**, which the server accepts only as a
fast-forward. Of several workers that start from the same tip and each push a
different commit, exactly one is accepted; every other push is rejected as
non-fast-forward. That rejection *is* the failed compare-and-swap: "I expected
the tip to be T; it is not T any more."

No code path treats the local move as authoritative. Everything that mutates
the board follows the same shape:

1. fetch and hard-reset a private clone to `origin/journal2`;
2. make the change and commit;
3. push; on rejection, go back to step 1.

What differs is **whether to retry after a rejection**, and the garden draws
that line deliberately ([`designs/job-board.md`][design-job-board] § 2):

- **Claims back off.** After a rejected claim push, `claim-job.sh` re-syncs,
  and if its candidate is no longer in `todo/` someone else took it. The
  worker moves on to another candidate. It never blindly re-applies the
  claim, since that could steal a job a peer already owns.
- **Posts, completions, sends, and promotions retry.** These touch only the
  caller's own basename or message id, so replaying them onto a newer tip
  cannot damage anyone else's state. They retry until they land.

Both use exponential backoff with full jitter (`backoff()` in
`scripts/jobs/common.sh`: a uniform draw in `[0, min(cap, base·2^attempt)]`,
base 50 ms, cap 2 s). The jitter matters: the
design's stress test found a fixed six-attempt completion retry with no
backoff stranding a job in `doin/` under eight-way contention. The idle poll
between claims uses the same recipe at second scale (`idle_backoff()`), so a
large fleet started in lockstep does not hammer `journal2` with simultaneous
fetches.

Two operational rules follow from this model:

- **Each writer has its own clone.** Two gardeners on one host must never
  share a journal checkout, or their `reset --hard` calls would stomp each
  other's working trees. Each worker has a private clone under
  `$GARDEN_STATE`, and producers share one serialized producer clone
  (`$GARDEN_STATE/producer/journal`) guarded by a per-clone `journal.lock`.
  Batch posts should therefore run sequentially, not in parallel.
- **Nobody edits the live `journal/` worktree by hand.** It can be stale and
  hold a peer's uncommitted changes. Content edits under `library/` or
  `projects/` go through `scripts/jobs/land-journal-edit.sh`, which applies
  the change in the producer clone on the current tip, with the same CAS loop
  and a verify-pushed guard. (This chapter was landed that way.)

## 2.2 The job lifecycle

### todo → doin → tada

The board has three lifecycle directories under `jobs/`:

| Directory | Meaning | Who writes |
|---|---|---|
| `jobs/todo/` | posted, claimable | producers via `post-job.sh` (and `promote-plan.sh`) |
| `jobs/doin/` | claimed, in flight | the claiming worker via `claim-job.sh` |
| `jobs/tada/YYYY/MM/DD/` | completed, holds the report | the worker via `complete-job.sh` |

A job file is Markdown: optional leading YAML frontmatter (`role:`, `tier:`,
`fallback-tier:`, `model:`, `handler-timeout:`, `requires:`, `market:`, …)
followed by the work body in prose.

**Post.** `scripts/jobs/post-job.sh [--identity <key>] <base> [body]` writes
`jobs/todo/<base>.md` and pushes, retrying on contention. Ordinary producers
get `tier: mentor` with `minion` fallback; explicitly requested `mentat`
work goes through `scripts/jobs/post-manual-job.sh`, which stamps
`dispatch: manual` (see [model-selection][model-selection]).

**Claim.** `scripts/jobs/claim-job.sh <id>` (called from the worker spine):

1. Refuses outright if the host is draining (`fleet_draining`, exit 3).
2. Fetches and hard-resets its clone to the tip.
3. Picks a candidate from `jobs/todo/` only, in lexical order offset by an
   id-derived index so that N workers do not all reach for the same first
   file. Candidates are filtered for eligibility: model/provider fit for
   this worker kind, and any `requires:` capability tokens (such as
   `requires: aws`) the host must satisfy. A `role: boatman` job is never
   claimed (§ 2.3).
4. `git mv jobs/todo/<base>.md jobs/doin/<base>.md`, stamps a `claim:` block
   (host, worker id, worker kind, provider, `claimed_at`), creates
   `work/<base>` and `inbox/<base>/`, and commits.
5. Pushes. **The accepted push is the claim.** On rejection it re-syncs and
   backs off to another candidate.

Jobs marked `market: bid` take a different route to the same push: a bounded
bid window followed by a deterministic Thompson-draw award that every worker
computes identically from the committed journal, resolved by the same
todo→doin CAS ([bid-auction][bid-auction]). Everything else, including every
`priority: urgent` job, stays on the race.

**Work.** The worker runs its handler with a wall-clock budget (below), in a
per-job worktree (§ 2.3). While it works it can read its inbox and message
the maintainer (§ 2.4).

**Complete.** `scripts/jobs/complete-job.sh <id> <base> <report>` removes
`doin/<base>.md`, `work/<base>`, and `inbox/<base>/`, writes the report to
`jobs/tada/YYYY/MM/DD/<base>.md` (UTC completion date; readers use
`tada_find` in `common.sh` rather than guessing the date), sweeps any
`jobs/bids/<base>/`, records a reputation event, and pushes, retrying until
it lands. After completion exactly one `tada/` report exists for the base and
nothing else.

Completion is keyed to an explicit signal, not to the agent ending its turn.
A worker's final report must end with the exact line `<<<GARDEN-JOB-COMPLETE>>>`;
an end-turn without it is treated as unfinished, nudged once in-process, and
otherwise left for requeue. Two optional signals precede it:
`<<<GARDEN-ORCHESTRATION-FAILED>>>` (finished, but a gated outcome was not
achieved; stamped as `orchestration-failed: true`) and
`<<<GARDEN-JOB-HANDED-OFF: successor>>>` (the deliverable is unfinished but a
named successor job or orchestration owns the rest;
`complete-job.sh --handed-off` verifies the successor exists and stamps
`handed-off:` plus `deliverable-complete: false`).

### Budgets and the reaper

Every handler runs under a resolved wall-clock budget. The default is
`GARDEN_HANDLER_TIMEOUT` = 2400 s; structurally long roles get 7200 s
(builder, web-builder, fixer, shepherd, conductor, botanist, review
directives, panel runs; table in `role_default_handler_timeout` in
`common.sh`). A `handler-timeout:` header in the job body overrides the role
default in either direction, capped at
`GARDEN_CLAIM_TTL − GARDEN_HANDLER_KILL_AFTER − 1` (14400 − 60 − 1 = 14339 s at
the defaults). The cap keeps the single-owner invariant: a handler is always
killed before its claim can be considered stale.

The leader-only **reaper** (`scripts/jobs/reaper.sh`, `garden-reaper.timer`)
scans only `jobs/doin/`. A claim older than the TTL, or one carrying a
known-dead `garden-reap-now` hint, is requeued to `todo/` (oldest first, at
most `GARDEN_REAP_MAX_PER_TICK` = 8 per tick, so a restart burst does not
re-form a thundering herd). A job that fails identically on every cycle is
**doomed**: parked in `plan/` with `doomed:` metadata and a maintainer notice
rather than requeued forever. Progress and token spend also inform that
decision; an over-budget job can be held as a `go-ahead` plan carrying
`park_reason: over-token-budget`, which `budget-refresh.sh` returns to
`todo/` when the quota window resets. `scripts/jobs/progress.sh <base>` shows
the read-only verdict.

### The plan category and its five gates

`jobs/plan/` sits beside the lifecycle, **outside** it. This is by
construction, not by a guard: `claim-job.sh` draws candidates only from
`todo/`, and `reaper.sh` scans only `doin/`, so a parked job is invisible to
the worker pool and never goes stale. It becomes work only when **promoted**,
which `scripts/jobs/promote-plan.sh <base>` does by moving
`plan/<base>.md` to `todo/<base>.md`, stripping the plan frontmatter, and
clearing the reaper's cycle markers so that a previously doomed job gets a
genuinely fresh run.

A plan job's frontmatter names its **gate**, which determines who may promote
it:

| Gate | Parked because | Promoted by |
|---|---|---|
| `go-ahead` | needs the maintainer's authorization | the **liaison** (or the **proxy**, within its bounds) when the maintainer says go ahead; never auto-selected. The mechanically marked `over-token-budget` subset is also promoted by **`budget-refresh.sh`** on quota reset. |
| `deferred` | parked behind higher-priority work | the **foreman** (`scripts/jobs/foreman.sh`), which on idle promotes the top deferred job by `priority:` (FIFO within a priority) in preference to generating new work. A `not_before:` timestamp hides it from ranking until then. |
| `awaiting-maintainer` | waits for the answer to a specific question at a recorded URL (`maintainer_question:`, `asked_at:`) | only an explicit `promote-plan.sh --maintainer` after the answer lands; every automatic caller omits that flag |
| `blocked` | waits for an artifact named in `blocked_on:` (a PR or another job) | only the **unblock watcher** (`scripts/jobs/unblock.sh`), passing `--unblock` after verifying the blocker completed |
| `orchestrated` | is a child of an orchestration (`orchestrated_by:`) | only the **orchestrate watcher** (`scripts/jobs/orchestrate.sh`, leader-only `garden-orchestrate.timer`), in the orchestration's serial or parallel order |

The producer-side primitives are `post-plan.sh` (park; the default gate is
`--deferred`; `--blocked --blocked-on <x>` and
`--orchestrated --orchestrated-by <orch>` select the other gates),
`annotate-plan.sh` (append a note or retune `priority:`/`roadmap:`/`role:` on
a job that is already parked, deduped by key), and
`post-orchestration.sh [--serial|--parallel] [--on-child-failure halt|continue] <orch> <child>…`,
which writes the orchestration record to `jobs/orch/<orch>.md`. The gate
fields themselves are not editable through `annotate-plan.sh`; re-gating is a
separate act with its own primitive (`promote-plan.sh`, `block-job.sh`,
`post-orchestration.sh`), with one atomic repair exception for moving a job to
`awaiting-maintainer`.

The orchestrate watcher is a good example of the garden's preference for
deterministic, `claude`-free machinery. Each tick it reads the orchestration
record and the board, promotes the next child (serial) or all children
(parallel), watches each reach `tada/`, and treats a child that vanished
without a `tada/` report, or whose report carries
`orchestration-failed: true`, as a failure to be handled by the record's
policy (halt and surface to the maintainer, or continue). This very book is an
orchestration, `garden-book-orch`, running eight chapter children in
parallel.

## 2.3 The gardener fleet

### What a gardener is

"Gardener" names the **shared worker role and spine**, not a particular kind
of process. The spine is `scripts/jobs/gardener.sh`: a loop that polls the
bus, passes a pre-claim health gate, claims a job, runs a handler, and
completes the job. The spine is backend-pluggable; the **worker kind**
decides which agent CLI the handler drives:

| Kind | Unit | Handler | Backend |
|---|---|---|---|
| monk | `garden-monk@<id>.service` | `scripts/jobs/handlers/monk-claude.sh` | native Anthropic (`claude -p`) |
| cleric | `garden-cleric@<id>.service` | `scripts/jobs/handlers/cleric-codex.sh` | OpenAI (`codex`) |
| others (mystic, opencode, …) | per-kind units | `mystic-kimi.sh`, `opencode.sh`, … | other providers |

All kinds are rendered from one template (`scripts/systemd/garden-worker@.service.in`)
and all share the prompt builder in `scripts/jobs/handlers/worker-common.sh`,
so every backend receives the same completion contract, worktree note,
messaging discipline, and verbatim job spec. The standing brief every worker
reads is [`roles/gardener/AGENT.md`][gardener-role], on top of
`roles/COMMON.md`.

Per-host pool size is journal state (`hosts/<GARDEN>`), set with
`scripts/jobs/set-workers.sh monk|cleric <count>` on the host in question, or
remotely through that host's sysop (§ 2.5). Each host's
`garden-gardener-scaler.timer` reconciles its local unit pool to that record.
Pool sizing against quota and backend health is covered in
[`context/operations/scaling.md`][scaling] and the cybernetics chapter.

**The pre-claim health gate.** Before claiming, the spine checks that it can
actually run a job: that its kind's agent CLI resolves
(`worker_health_gate` in `common.sh`). A worker that fails the gate does not
claim; it idle-polls on backoff and resumes by itself when the binary
reappears. This matters because a broken worker fails each job in about a
second and so wins claim races disproportionately. In the 2026-07-27/28
incident, one host with an unresolvable CLI held all 52 `doin/` claims and
produced zero completions while healthy hosts sat idle. Peers cannot take
such a host out of rotation (`set-workers.sh` refuses cross-host writes and
the drain marker is host-local), so the gate must live in the spine.

### How `role:` selects the posture

A job's `role:` frontmatter field (read by `plan_role` in `common.sh`) names
the posture the gardener wears: `builder`, `fixer`, `designer`, `shepherd`,
`conductor`, and so on, each with its own `roles/<role>/AGENT.md`. The body
of the job directs the worker to that brief, and the gardener reads it (and
the skills it links) just-in-time; role files are named `AGENT.md`, not
`CLAUDE.md`, precisely so that Claude Code does not auto-load them. The
`role:` field also drives machinery around the handler:

- **Model tier.** Absent an explicit `model:`, the handler resolves a
  per-role default through `role_default_model` / `role_default_tier`,
  subject to role floors (canonical map:
  [model-selection][model-selection]).
- **Handler budget.** `role_default_handler_timeout` gives builder, fixer,
  shepherd, conductor, and botanist their 7200 s defaults (§ 2.2).
- **Environment.** The handler exports `GARDEN_JOB_ROLE`, which, for
  example, gives a `botanist` a scripts-disabled dependency install in
  `ensure-project-worktree.sh` and labels the worker's journal entries.
- **Completion edges.** When a `role: builder` job completes with an open
  draft PR authored by the bot, `scripts/jobs/auto-gauntlet-handoff.sh` posts
  the idempotent `<build-base>-gauntlet` job before the build can move to
  `tada/` ([`designs/gardening-state-machine.md`][design-gsm] § Build handoff
  invariant).
- **Refusals.** `role: boatman` is refused by `post-job.sh`, `claim-job.sh`,
  and `gardener.sh`. Ferrying lands commits under the maintainer's identity,
  so it runs only off-board via `scripts/ferry.sh` on the credentialed host.

PR work inside a job follows the **gardening state machine**
(`scripts/jobs/gardening/garden-pr.sh`), which the gardener supervises rather
than executes step by step. The script runs deterministic stages itself
(safe rebase, sense-gated automations, pre-push gates, the always-on
`local-verify.sh` evaluation gate, push) and shells to `claude -p` only for
small decisions such as "loop or stop?". It is quiet on success, so routine
progress stays out of the supervisor's context, and `GARDEN_TRACE=1` sends
`set -x` output to a file for a dedicated debugging subagent rather than to
the supervisor ([`designs/gardening-state-machine.md`][design-gsm]).

### Per-job worktrees, and why never the root

A job never works in the deployed garden root. The spine gives each job two
kinds of isolated checkout ([`WORKTREES.md`][worktrees] § Per-job v2
worktrees):

- **Garden worktree:** `scratch/gardener-wt-<base>`, a checkout off
  `origin/main2`, which is the handler's cwd. Garden development (roles,
  skills, scripts) happens here and is pushed straight to `main2` with a
  rebase CAS loop under `garden_repo_lock`.
- **Project worktree:** `scripts/jobs/ensure-project-worktree.sh <base>
  <owner/repo> <branch>` prints a detached checkout at
  `scratch/project-wt-<base>-<digest>`, created from the bare clone
  `worktrees/<owner>-<repo>.git`. It is keyed by the **job base**, not the
  repo or PR number, so two peers working the same PR never share a working
  tree (concurrent pushes to the same branch still race, correctly, at the
  push CAS). It also populates `node_modules` from a warm per-repo cache.

Both are stable across a requeue on the same host, because uncommitted work
may be the only resumable copy. Teardown follows board state rather than age:
a successful completion removes the job's project worktree, a doom removes it,
an ordinary requeue preserves it, and the per-host
`garden-worktree-sweeper.timer` collects anything missed.

The root is off-limits for three reasons:

1. **It is a deployed version** (§ 2.6). Editing it would dirty what the whole
   host is running and collide with peers.
2. **It shares one repository with the journal.** `<garden-root>/.git` backs
   both the root checkout and the `journal/` worktree. A stray `git checkout`,
   `remote set-url`, or `commit` run with that repo as the enclosing
   repository corrupts journal sync for the whole host. This happened on
   2026-07-17 and 2026-07-21 (HEAD moved onto a fixture branch; origin
   rewritten to an unrelated remote) and went undetected for days.
3. **Defense in depth.** The spine sets `GIT_CEILING_DIRECTORIES=$GARDEN_ROOT`
   so git cannot ascend into the root from a subdirectory, every worker prompt
   forbids running git there, and the `garden-root-repo-guard.timer` (every
   host, about every 30 minutes) asserts the root's invariants (canonical
   origin, HEAD detached at a `main2` ancestor, a maintainable object store)
   and repairs and alerts on drift ([`designs/root-repo-guard.md`][root-guard]).

The retired v1 route, in which the liaison dispatched subagents into a
`dispatches/<role>--<id>/{garden,journal,project}/` triple, survives in
`WORKTREES.md` and the [dispatch-worktree][dispatch-worktree] skill only where
a role still needs that shape. (`WORKTREES.md` also still calls the journal
branch `journal`; the live branch is `journal2`.)

## 2.4 The message bus

The bus is the journal, even for two processes on the same host, because the
fleet spans hosts. Every send and every read-state move is a commit pushed
with the same CAS discipline as the board. There are four kinds of address
([message-bus][message-bus]).

### Directed inboxes (one doer)

`inbox/<doer>/{unread,read}/<id>.md`, where `<doer>` is a job base. The
inbox is **created at claim and destroyed at completion**, so it exists for
exactly the lifetime of one job's doer.

- Send: `scripts/jobs/inbox-send.sh <doer> [body]` CAS-appends to `unread/`
  with frontmatter `from_host`, `from`, optional `reply_to`, and `sent_at`.
  It refuses if the doer is not active.
- Read: `scripts/jobs/inbox-read.sh <doer>` prints unread messages and
  CAS-moves them to `read/`. The doer is the only mover, so the move always
  eventually lands.
- Discovery: `scripts/jobs/inbox-list.sh` lists which doers are alive.

A message addressed to a doer that has already completed is dead-lettered,
and the leader-only `garden-deadmail` service (`scripts/jobs/deadmail.sh`)
promotes it to a fresh job, so its intent is not lost. Machine-generated
deadline warnings arrive here too (`kind: deadline-nudge`), and a running job
sees them only when it next reads its inbox; they do not interrupt a turn.

### The maintainer inbox (the human, via the liaison)

`inbox/maintainer/{unread,read}/` is a **standing** inbox that is never
destroyed. A gardener writes to it with
`scripts/jobs/message-user.sh <its-base>`, which tags the message
`reply_to: <base>`. On the leader, the liaison runs
`scripts/jobs/maintainer-watch.sh` under a Claude Code Monitor, surfaces new
messages, and disposes of each with `maintainer-reply.sh <msgid>` (which
routes the reply into the originating doer's inbox via `reply_to` and
archives the original) or `maintainer-archive.sh <msgid>`. The gardener, still
working, picks up the reply with its own `inbox-read.sh`. An empty reply
simply archives.

Repeated notices do not pile up. With `GARDEN_MSG_COALESCE=1` and a stable
`GARDEN_MSG_ID` (the episode key), a repeat **amends** the still-unread entry
(bumping `notice_count` and refreshing `last_seen`) under a one-hour per-key
throttle; once the recipient reads it, the next occurrence posts a fresh
entry. `message-user.sh` defaults a per-job, per-content episode key, so a
worker re-reporting the same status folds while distinct messages stay
distinct.

### Topics: role channels and broadcast (many readers)

`msgs/role/<r>/` and `msgs/broadcast/` are fan-out topics. Senders use
`scripts/jobs/send-msg.sh role/<name>|broadcast [body]`. Readers use
`scripts/jobs/read-msgs.sh <seen-key> <addr>…`, which prints unseen messages
and advances a per-reader cursor. The cursor lives under `$GARDEN_STATE`,
outside any worktree, so a `reset --hard` of a journal clone never loses it.
Every working gardener polls `role/gardener` and `broadcast`; the watchman
uses `broadcast` to announce role and skill evolution on `main2`, so a lesson
reaches running agents mid-flight; liaisons coordinate leadership handoffs on
`role/liaison` (§ 2.5).

### Host channels (the sysop)

`msgs/host/<GARDEN>/` is addressed to one host's sysop daemon rather than to
an agent. Senders use `scripts/jobs/send-host-op.sh <GARDEN> op=… key=…`.
Section 2.5 describes the receiver.

### Summary

| Address | Cardinality | Lifetime | Reader | Primitive |
|---|---|---|---|---|
| `inbox/<doer>/` | one job doer | claim → completion | that doer | `inbox-send.sh` / `inbox-read.sh` |
| `inbox/maintainer/` | the human | standing | the leader's liaison | `message-user.sh` / `maintainer-watch.sh`, `maintainer-reply.sh` |
| `msgs/role/<r>/`, `msgs/broadcast/` | many | standing | every subscriber, own cursor | `send-msg.sh` / `read-msgs.sh` |
| `msgs/host/<GARDEN>/` | one host | standing | that host's sysop | `send-host-op.sh` / `sysop.sh` |

One hygiene rule is enforced mechanically on every author-written send:
issue and PR references must be fully qualified (`owner/repo#N` or a full
URL). `check-issue-refs.sh` rejects a bare `#N` outside code spans before the
push.

## 2.5 Fleet topology: leaders, followers, and the sysop

### Why there is a leader at all

Gardeners are safe to run anywhere: two workers on two hosts racing for the
same job are deduplicated by the push CAS. The garden also runs **producers
and supervisors** that are not safe to duplicate, because none of them
coordinate with a second copy of themselves:

- two **foremen** would double-pump the board (each promoting or generating
  work on idle);
- two **schedulers** would double-dispatch every recurring job;
- two **watchers** would double-post the same PR comment or CI failure;
- two liaison **maintainer-inbox Monitors** would double-answer the human.

So the fleet is **leader/follower** ([`designs/multibot-leader-follower.md`][multibot],
operator procedure [`context/operations/leader-follower.md`][leader-follower]).
Each host has a unique `GARDEN` identity (`<hostname>-<basename>-<hash8>`,
derived from the checkout path). The journal file `leader` holds the
leader's identity, and `scripts/jobs/is-main-host.sh` exits 0 on the leader
and 1 elsewhere.

### What runs where

**Leader-only singletons** include `garden-foreman`, `garden-scheduler`,
`garden-bulletin`, `garden-deadmail`, `garden-reaper`,
`garden-deadline-nudge`, `garden-follow-up`, `garden-proxy`, `garden-mentor`,
`garden-mirror-closer`, `garden-orchestrate`, `garden-rolling-deploy`, the
watchers (`garden-{comment,ci}-watcher@*`, `garden-triager@*`,
`garden-approval-reconciler@*`, `garden-comment-latency-watch`,
`garden-mention-watcher`, `garden-issue-inbox`), and the liaison's
maintainer-inbox and deploy-on-upgrade Monitors.

**Every host** runs its worker pool (`garden-monk@*`, `garden-cleric@*`, …)
and its local infrastructure: `garden-gardener-scaler`,
`garden-upgrade-monitor`, `garden-self-deploy`, `garden-sysop`,
`garden-root-repo-guard`, `garden-worktree-sweeper`, `garden-clone-keeper`,
`garden-journal-worktree-keeper`, `garden-journal-contention-watch`,
`garden-container-hardening`, `garden-repo-watcher`, `garden-unblock`, and the
maintenance half of `garden-watchman` (its reread broadcast is gated to the
leader in-process). The audited per-unit list is
`context/operations/systemd-units.md`.

**The gate.** Each timer-driven singleton carries `is-main-host.sh` as an
`ExecCondition=`. On a follower the timer still fires, but the tick is skipped
cleanly (condition-failed, not Failed), and every firing re-evaluates the
marker, so promotion and demotion need no restart. Long-running singletons
such as the bulletin gate the same predicate in-process.

### Designation is raising

There is **no automatic failover**. `scripts/jobs/set-main-host.sh <host>`
CAS-writes the `leader` marker, and every host's liaison runs a standing watch
on it. When the marker comes to name this host, the liaison stands itself up
as leader: it arms the two leader-only Monitors, and the systemd singletons
begin running as `is-main-host.sh` starts returning 0. Re-pointing the marker
therefore *raises* the new leader.

The systemd singletons follow the marker on their own, so the only pieces a
handoff must sequence are the two liaison Monitors, which live in a Claude
session and have no `ExecCondition=`. The preferred handoff is initiated by
the incoming host on `role/liaison`: the outgoing liaison stands down its
Monitors and confirms, then the incoming host moves the marker, then arms its
own Monitors. That ordering guarantees there are never two live
maintainer-inbox Monitors. If the leader is dead, the marker is re-pointed by
hand.

### The sysop: the deliberate every-host exception

Followers are often unattended, yet operators need to change them: throttle a
pool, drain, clear failed units, deploy. `set-workers.sh` correctly refuses to
write another host's count. The **sysop** (`scripts/jobs/sysop.sh`,
`garden-sysop.{service,timer}`, [`designs/sysop.md`][sysop]) is the daemon
that "sits at" each host and runs the command there, driven by a bus message.

- **Deterministic, no LLM.** It runs no `claude` and claims no jobs; the
  `roles/sysop/AGENT.md` stub only redirects to the design.
- **Closed vocabulary.** `set-workers`, `drain`, `reset-failed`, `restore`,
  `unit`, `deploy`, `local-model`, `maintain`. Each op delegates to the
  existing hardened same-host tool. Ferrying and identity switches are
  permanently outside the vocabulary.
- **Every host, not leader-gated, and it ticks under drain.** A drained host
  must still be able to receive its own `drain off`; otherwise a fleet could
  be wedged undrainable from the bus.
- **Host-scoped by construction.** Each sysop reads only
  `msgs/host/<its-own-GARDEN>/` and only ever mutates its own host. It does
  not bypass `set-workers.sh`'s cross-host refusal; it satisfies it by running
  on the target.
- **Authorization.** Journal push access is the boundary: any garden host may
  originate an op for any other (`from_host` is self-asserted). The
  destructive ops (`unit`, `deploy`, `local-model`, `maintain`) additionally
  require an `authorized_by:` attestation naming someone on
  `maintainers/allowlist`.
- **Idempotent and acknowledged.** Every op is recorded to
  `sysop-log/<GARDEN>/<msgid>.md` and acked, so a sender can tell "done" from
  "never arrived".

### Capacity and the foreman brake

Capacity is a per-host count (`set-workers.sh`, or the sysop's `set-workers`
op). `scripts/jobs/drain-fleet.sh on|off` writes or removes the host-local
marker `$GARDEN_STATE/draining`: a draining host's workers finish their
in-flight claim and then stop claiming (`claim-job.sh` exits 3), so a drain is
a claim brake, not a kill. `scripts/jobs/brake-foreman.sh on|off|status` is a
separate, journal-backed brake on the foreman alone: it stops the foreman
from promoting or generating work without stopping workers from draining the
existing board. The shipped foreman active target is 10;
`GARDEN_TOKEN_BACKOFF_FRACTION` is the spend brake. Budget pacing is covered
in [`context/operations/cybernetics.md`][cybernetics].

## 2.6 The deliberate deploy

### The root checkout is a deployed version

`<garden-root>` is not a development tree. Nothing fast-forwards it
continuously; the old `garden-deploy-sync` path is retired. It holds a
specific, recorded `main2` SHA, and every unit on the host runs that code.
Development happens only in per-job worktrees (§ 2.3), which push to
`origin/main2`; the root moves only when that host **deploys**
([`designs/deliberate-deploy.md`][deliberate-deploy], procedure
[`context/operations/deploy.md`][deploy]).

The reason is that a running fleet must not change underneath itself. A
worker mid-job, a watcher mid-tick, or a unit mid-restart should see one
consistent version, and a bad commit on `main2` should be stopped before it
reaches every host at once.

### One host's deploy: `deploy-garden.sh`

`scripts/jobs/deploy-garden.sh` is the per-host deploy, run the same way
whether triggered by hand, by the self-deployer, or by the rolling conductor.
Its sequence is:

1. **Candidate gate.** Unpack the target SHA into an isolated candidate tree
   and run the configured deterministic gate suites (one retry in a fresh
   tree). Persistent failure rejects the candidate without touching the root;
   diagnostics stay under `$GARDEN_STATE/deploy/candidate-gate-diagnostics/<sha>`.
2. **Drain and quiesce.** Engage the same drain as `drain-fleet.sh` and wait
   up to 600 s for in-flight work to finish. If a live worker has been busy
   for more than 300 s, the deploy **defers** instead (a 7200 s build cannot
   be outlasted); operators pre-drain with `drain-fleet.sh on` and wait for
   the `busy` markers to clear.
3. **Advance** the root to the tested candidate and **record** the deployed
   SHA, which clears the upgrade-ready signal.
4. **Lift the drain and restart** the fleet, so every unit picks up the new
   code.

A deploy is always **pinned** when orchestrated
(`GARDEN_DEPLOY_TARGET=<sha>`), and the target must lie on `origin/main2`. A
deploy that changes the Dockerfile or its inputs also needs an image rebuild
(`./garden check` reports staleness); `deploy-garden.sh` does not rebuild the
container.

### The trigger: `upgrade-ready`

The per-host `garden-upgrade-monitor` service writes
`$GARDEN_STATE/deploy/upgrade-ready` when `origin/main2` is ahead of the
host's deployed SHA. That file is a **host-local fact** derived from git
ancestry, not a bus message, and it is the only thing that can start a deploy
automatically. A message on the bus cannot make a host deploy.

### The fleet-wide roll: canaries first, leader last

Two daemons act on that fact ([`designs/follower-self-deploy.md`][self-deploy]):

- **`garden-rolling-deploy`** (`scripts/jobs/rolling-deploy.sh`, leader only)
  is the conductor. Each tick it reads local signals and journal state and
  advances the roll **at most one step**. It releases one follower at a time
  as a **canary** by writing a journal release token `deploy/roll/<GARDEN>`
  pinned to a target SHA. It then validates that canary: unit health
  (excluding advisory units), a host-pinned **round-trip probe job** that must
  reach `tada/` within 10 minutes, and a job-processing regression check.
  Only after the canaries pass does it deploy the **leader itself, last**,
  and it never does so on a failed canary.
- **`garden-self-deploy`** (`scripts/jobs/self-deploy.sh`, every host) is the
  follower half. It deploys its host only when **both** its own
  `upgrade-ready` fact and a release token for it exist, and only to the
  released SHA. If there is no live leader to orchestrate, a leaderless-grace
  fallback lets a follower advance on its own.

The release token is deliberately weak. It is not a sysop op and not a deploy
trigger: a follower still needs its own `upgrade-ready` fact to move, and
`deploy-garden.sh` refuses any target that is not on `origin/main2`. A forged
or stray token can therefore only let a host reach a point on the canonical
branch. The only bus messages the conductor sends are **benign** `drain` ops
(for example, the `rolling-deploy-quiesce` drain it sends after a canary has
deferred for 30 minutes behind a long job). The attested sysop `deploy` op is
never on the rolling path; it remains the maintainer's manual escape hatch for
an unattended host.

Failure handling is equally deterministic. A follower that holds a release
for 20 minutes without deploying raises a `rolling-deploy-canary-stuck-<host>`
notice. A canary still deferring three hours after release fails normally.
When the leader's own candidate gate rejects a SHA, the conductor records a
target-keyed marker under `$GARDEN_STATE/rolling-deploy/rejected/<short-sha>`
and skips that SHA quietly until a new target appears, instead of re-paging
the maintainer every tick. Once the leader is current, followers left behind
receive catch-up releases to the leader's SHA.

The liaison's deploy-on-upgrade Monitor is now an **observer and
kill-switch** on the leader: it reports `upgrade-ready` and lets a human
intervene (`drain-fleet.sh on` halts a host; a hand-run `deploy-garden.sh`
overrides, skipping canaries). A host with no liaison session still advances.

### Guarding the deployed root

Because the root and `journal/` share one repository, the deploy model is
paired with the `garden-root-repo-guard` described in § 2.3. It also checks
that the object store stays maintainable: a failed `git gc` leaves a `gc.log`
that disables automatic cleanup permanently, after which packs grow without
bound and every journal sync slows. The guard repairs losslessly, alerts on
drift, and watches for a stalled deploy.

## 2.7 Summary of invariants

- **The accepted push to `origin/journal2` is the only serialization point.**
  A local move is never authoritative.
- **Claims back off; everything else retries.** Retrying a claim could steal
  a job; retrying a post, completion, send, or promotion only fast-forwards
  the caller's own files.
- **The basename is the spine and the idempotency key.** One-shot work stays
  bare; recurring verbs get a date suffix; PR directives also carry an
  identity.
- **`plan/` is outside the lifecycle.** Nothing claims or reaps it; each gate
  names exactly who may promote it.
- **Every job runs in its own worktrees, keyed by its base.** The deployed
  root is never a working tree, and git never runs there.
- **Duplicating a singleton is a bug.** Singletons run only where
  `is-main-host.sh` says; gardeners and per-host infrastructure run
  everywhere; the sysop runs everywhere and only touches its own host.
- **A host advances only on its own `upgrade-ready` fact**, to a pinned SHA
  on `main2`, followers before the leader, never past a failed canary.

[claude-md]: https://github.com/kriscendobot/garden/blob/main2/CLAUDE.md
[job-board]: https://github.com/kriscendobot/garden/blob/main2/skills/job-board/SKILL.md
[message-bus]: https://github.com/kriscendobot/garden/blob/main2/skills/message-bus/SKILL.md
[worktrees]: https://github.com/kriscendobot/garden/blob/main2/WORKTREES.md
[design-job-board]: https://github.com/kriscendobot/garden/blob/main2/designs/job-board.md
[design-gsm]: https://github.com/kriscendobot/garden/blob/main2/designs/gardening-state-machine.md
[model-selection]: https://github.com/kriscendobot/garden/blob/main2/skills/model-selection/SKILL.md
[bid-auction]: https://github.com/kriscendobot/garden/blob/main2/skills/bid-auction/SKILL.md
[gardener-role]: https://github.com/kriscendobot/garden/blob/main2/roles/gardener/AGENT.md
[scaling]: https://github.com/kriscendobot/garden/blob/main2/context/operations/scaling.md
[cybernetics]: https://github.com/kriscendobot/garden/blob/main2/context/operations/cybernetics.md
[root-guard]: https://github.com/kriscendobot/garden/blob/main2/designs/root-repo-guard.md
[dispatch-worktree]: https://github.com/kriscendobot/garden/blob/main2/skills/dispatch-worktree/SKILL.md
[multibot]: https://github.com/kriscendobot/garden/blob/main2/designs/multibot-leader-follower.md
[leader-follower]: https://github.com/kriscendobot/garden/blob/main2/context/operations/leader-follower.md
[sysop]: https://github.com/kriscendobot/garden/blob/main2/designs/sysop.md
[deliberate-deploy]: https://github.com/kriscendobot/garden/blob/main2/designs/deliberate-deploy.md
[deploy]: https://github.com/kriscendobot/garden/blob/main2/context/operations/deploy.md
[self-deploy]: https://github.com/kriscendobot/garden/blob/main2/designs/follower-self-deploy.md
