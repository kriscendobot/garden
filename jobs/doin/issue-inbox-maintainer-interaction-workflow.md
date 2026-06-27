# Set up the issue-inbox workflow: maintainer interaction via the garden's own GitHub issues

Map: **design + build** (garden infra) on the garden's own repo, branch main2. Substantial —
the gardener may run a design pass (a design doc) and decompose into follow-on jobs. Build in
an isolated worktree off origin/main2; explicit-pathspec commits; push HEAD:main2 via a
git-rebase CAS loop. Per-instance config lands in JOURNAL state, not main2 (see below).

## Goal
A deterministic systemd service that turns the garden's OWN GitHub repository's **issues** into
a maintainer-interaction inbox: it watches for new issues and new comments and dispatches garden
jobs (or messages to the agent already handling an issue), so a maintainer can drive the garden
by filing/commenting on issues and get replies as issue comments.

## ‼️ MANDATORY SAFETY GATE (prompt injection) — design around this first
GitHub issues/comments on a public repo are attacker-writable text. Per the monitoring-safety
constraint (CLAUDE.md § Monitoring safety): no untrusted issue/comment body may reach a job, a
message, or `claude -p`. Use the SAME defense as `scripts/jobs/mention-watcher.sh`: a
**deterministic sender-trust gate that runs in plain code, NO LLM, BEFORE any issue/comment text
is read or dispatched.** An issue or comment is dispatched ONLY if its AUTHOR login is in the
instance's journal-tracked **maintainer set** (see config below); every other author is logged
and DROPPED, never triaged. This is the entire safety story — the gate, not repo-gating, makes
watching the public garden repo safe. This request is the maintainer authorization for it;
record it as a journal `message` entry per the constraint.

## Per-instance config in JOURNAL state (NOT main2)
The garden's repo identity and its maintainer set are PER-INSTANCE and live in the journal, so
main2 stays generic and "clone the garden repo (without the journal) is enough to start a new
garden" holds:
- A journal config location, e.g. `config/garden-repo` = the instance's own `owner/name` (this
  instance: `kriskowal/garden`; other instances configure their own).
- A journal-tracked **maintainer / trusted-submitter set** (logins). REUSE / align with the
  existing `trusted-senders/allowlist` mechanism the mention-watcher already reads, or a sibling
  `maintainers` list — one source of truth. Other instances track their OWN maintainers in their
  OWN journals (a different repo and different users).
- **Bootstrap:** a new garden is started by cloning main2 and initializing a fresh journal that
  sets `config/garden-repo` + the maintainer set; the watcher reads these at runtime and is inert
  until they exist. Provide the init step (a `set-garden-repo.sh` / `add-maintainer.sh` analogous
  to the existing producer scripts) and document it in the bring-up section of CLAUDE.md.

## The deterministic watcher service
A new `garden-issue-inbox` systemd service (poll cadence; durable cursors outside any reset-prone
worktree, like the other watchers). DETERMINISTIC — plain code, no LLM in the watcher:
- Read `config/garden-repo` + the maintainer set from a synced journal clone.
- Poll the repo's issues and issue-comments via `gh` (ETag / last-seen-id cursors per the existing
  watcher pattern; `--paginate`; `require_tools gh jq`; parse with jq — heed the silent-jq-outage
  lesson, fail LOUD on a missing binary).
- Apply the sender-trust gate (author-login ∈ maintainer set) BEFORE reading any body.
- For each NEW trusted interaction, dispatch (below). Advance cursors only after a successful
  dispatch so a crash re-processes, never skips.

## Dispatch model
Key each issue to a stable job spine, e.g. `issue-<owner>-<repo>-<number>`.
- **New issue (trusted):** post a generic job with that spine, carrying the **issue note** (below).
- **New comment (trusted) on an issue already in flight:** deliver it as a MESSAGE to the agent
  currently handling that issue — `send-msg.sh job/<issue-spine>` — so it folds the new comment
  into its in-flight work. **Deadmail caveat:** if that doer has finished (dead inbox), the message
  is undeliverable; the existing `garden-deadmail` service promotes it to a JOB (which must carry
  the issue note). Confirm deadmail preserves/propagates the issue note when it promotes; if not,
  teach it to.
- **Issue closed by the submitter:** stop — dispatch nothing further for it.

## The issue note (carried job-to-job)
Every dispatched job (and message) carries a structured **issue note**: the issue URL, the
submitter login, and the issue-spine. It is similar to a generic job but with this note so the
agent knows WHERE to follow up — the agent replies to the submitter by posting a COMMENT on that
issue URL (it must NOT email or act outside the issue thread). The note must be CARRIED FORWARD
from job to job as the issue progresses: when an agent handling an issue posts a FOLLOW-ON job
(the work chain), the follow-on inherits the same issue note, so any agent in the chain can comment
back on the right issue. Specify the note format and the propagation rule (follow-on jobs copy the
parent's issue note) so it survives the whole chain.

## Closing etiquette
The agent **defers to the issue submitter to close the issue** when satisfied. The agent posts its
follow-up comment and LEAVES THE ISSUE OPEN; it never auto-closes. The watcher treats a
submitter-close as the terminal signal.

## Reconcile with existing machinery (reuse, don't duplicate)
`mention-watcher.sh` (the sender-trust gate model + `trusted-senders/`), `comment-watcher.sh`
(issue/PR comment polling + `comment-source` handler — reuse the gh/jq comment-source plumbing),
`deadmail.sh` (undeliverable→job promotion), `send-msg.sh job/<base>` (route to the in-flight doer),
`post-job.sh` (dispatch). Add a `roles/`/`skills/` note if a new role/skill is warranted (e.g. an
issue-inbox skill describing the note format + comment-back + defer-to-submitter etiquette).

## Tests
Extend run-test.sh: an issue/comment from a NON-maintainer is DROPPED (no job, no message, no LLM);
from a maintainer → a job with the issue note; a new comment on an in-flight issue → a message to
the doer, and on a dead doer → a deadmail-promoted job carrying the note; the issue note propagates
to a follow-on job; the agent never closes the issue. Stub `gh` deterministically.

## Deliverable
A `garden-issue-inbox` deterministic watcher + journal config (`config/garden-repo` + maintainer
set, with bootstrap/init scripts) + the issue-note job/message model with deadmail routing + the
defer-to-submitter-close etiquette + a design doc capturing the decisions + tests + CLAUDE.md
bring-up docs. The sender-trust gate is mandatory and proven by tests.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot
  gardener: 3
  claimed_at: 2026-06-27T18:44:49Z
