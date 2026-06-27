# Authorize the proxy to park blocked jobs + auto-unblock when the blocker completes

Map: **build** (garden infra), branch main2. Isolated worktree off origin/main2; explicit-pathspec
commits; push HEAD:main2 via a git-rebase CAS loop. This is a MAINTAINER-AUTHORIZED extension of the
proxy's bounded authority (directive 2026-06-27) — record the authorization in roles/proxy/AGENT.md
and a journal `message` entry.

## Authorized new behavior
When the maintainer inbox carries a notification that a particular job is BLOCKED on an artifact (a
pull request, or another job), the proxy scrubs it from the inbox by, in one autonomous move:
1. **Park the blocked job** — move it to `jobs/plan/<base>` under a new **`gate: blocked`** with a
   `blocked_on: <artifact>` field (the artifact = a PR URL or a job basename). A blocked plan is
   never claimed by gardeners (it's in plan/) and is NEVER auto-promoted by the foreman (see gate
   semantics below) — it waits for its blocker.
2. **Leave a note on the blocking artifact** that completing it should promote the blocked plan back
   to todo:
   - blocker is a JOB → record the edge on that job and in a machine-readable dependency record;
   - blocker is a PR → post one informational comment on the (bot-fork) PR ("completing this PR
     promotes garden plan `<base>` back to todo") AND write the machine-readable record. The PR
     comment is courtesy; the deterministic record is the load-bearing trigger.
3. **Archive the maintainer notification** (scrub the inbox), like the watchdog auto-clear sibling.

## Gate semantics — the new `blocked` gate
- `plan_gate` recognizes `blocked` alongside `go-ahead`/`deferred`.
- `plan_deferred_ranked` (the foreman's auto-promote selector) must NOT select `blocked` plans (it
  already selects only `deferred`, so this holds — assert it in a test so a future refactor can't
  regress it).
- Only the unblock mechanism (below) promotes a `blocked` plan, via `promote-plan.sh`.
- Bulletin: add a **"blocked (awaiting <artifact>)"** group to `render_plan_queue` so the maintainer
  sees what is parked-blocked and on what.

## The deterministic unblock mechanism (the trigger)
A deterministic check — a small `garden-unblock` watcher, or folded into an existing periodic service
(reaper/foreman tick) — that for each `gate: blocked` plan reads its `blocked_on:` and:
- blocker is a JOB basename → if that job is in `jobs/tada/` (completed) → promote `plan/<base>` →
  `todo/` and clean up the dependency record/edge.
- blocker is a PR URL → `gh` check whether the PR is merged or closed → if so, promote → todo and
  clean up (and, if a courtesy comment was posted, optionally note the promotion). `require_tools gh
  jq`; deterministic, NO LLM; fail LOUD on a missing binary (silent-jq-outage lesson).
Store the machine-readable dependency records in journal state (e.g. `jobs/blocked-on/<key>` or the
`blocked_on:` field itself is sufficient if the watcher scans the plan dir) — pick the simplest
single source of truth and document it.

## Where the LLM is vs isn't
Detecting/classifying a free-text "blocked on X" maintainer message and extracting (blocked-job-base,
blocker-artifact) MAY use the proxy's existing `claude -p` handler (it already triages gating
questions). PREFER a structured signal: teach the blocking convention so a gardener that blocks posts
its notification with a `blocked_on:` field (artifact) — then the proxy acts deterministically with no
extraction. The PARK + NOTE + ARCHIVE and the UNBLOCK trigger are deterministic; only the free-text
classification fallback is LLM.

## Reconcile / reuse
`promote-plan.sh` (plan→todo), `plan_gate`/`plan_deferred_ranked`/`render_plan_queue` (common.sh +
bulletin.sh), the watchdog auto-clear sibling (`proxy-auto-clear-watchdog-messages` — same inbox-scrub
shape), `pr-dependency-graph` / `pr-dependency-topo-sort` skills (existing dependency vocabulary —
align), the deadmail/message-bus patterns. roles/proxy/AGENT.md gets a new "Blocked-job parking"
section under its authorized behaviors.

## Safety / bounds
This stays within the proxy's progress/direction authority (parking + auto-resume keeps work moving;
it makes no policy/authority decision). The only outward action is one informational PR comment on a
BOT-FORK PR (reversible) — gated to bot repos; never agoric-sdk, never a state change to the PR.

## Tests
Extend run-test.sh / the proxy subtest: a "blocked on PR #N" maintainer message → the job is moved to
`plan/<base>` with `gate: blocked` + `blocked_on`, a dependency record is written, the inbox message is
archived; a `blocked` plan is NEVER selected by `plan_deferred_ranked`; the unblock watcher promotes
`plan/<base>` → `todo/` when the blocker job is in tada / when the PR is merged (stub `gh`), and not
before; the bulletin shows the blocked group. 

## Deliverable
The proxy parks blocked jobs as `gate: blocked` plans with a deterministic unblock trigger (promote on
PR-merge / blocking-job completion), scrubs the blocked notifications from the maintainer inbox, surfaces
the blocked queue in the bulletin, records the authorization in roles/proxy/AGENT.md + the journal, with
tests proving park → no-auto-promote → unblock-on-completion.
