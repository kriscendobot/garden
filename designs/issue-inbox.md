# Design: the issue inbox — driving the garden from its own GitHub issues

A deterministic systemd watcher that turns the garden's **own GitHub repository's
issues** into a maintainer-interaction inbox. A maintainer files or comments on an
issue; the watcher dispatches a garden job (or folds the comment into the agent
already handling that issue); the agent replies as an **issue comment**. So the
garden is drivable from GitHub, not only from the maintainer inbox on the message
bus.

Sibling to the two existing watchers: `mention-watcher.sh` (the @-mention,
GitHub-wide) and `comment-watcher.sh` (one gated repo's PR/issue **comments**).
This one watches **new issues and new issue-comments** on the garden's own repo.

Code: [`scripts/jobs/issue-inbox-watcher.sh`](../scripts/jobs/issue-inbox-watcher.sh),
the source handler
[`scripts/jobs/handlers/issue-source-gh.sh`](../scripts/jobs/handlers/issue-source-gh.sh),
the init producers
[`set-garden-repo.sh`](../scripts/jobs/set-garden-repo.sh) /
[`add-maintainer.sh`](../scripts/jobs/add-maintainer.sh), the unit
[`garden-issue-inbox.service`](../scripts/systemd/garden-issue-inbox.service)+`.timer`,
and the consumer contract [`skills/issue-inbox/SKILL.md`](../skills/issue-inbox/SKILL.md).

---

## 1. The safety gate is the whole story

GitHub issues/comments on a **public** repo are attacker-writable text. The
monitoring-safety constraint (CLAUDE.md § Monitoring safety) forbids feeding
untrusted issue/comment text into a job, a message, or `claude -p`. The garden's
own repo is public, so repo-gating cannot make it safe.

The defense is identical in shape to `mention-watcher.sh`'s: a **deterministic
maintainer-trust gate that runs in plain code, with NO LLM, BEFORE any
issue/comment body is read or dispatched.** An issue or comment is dispatched only
if its **author login** is in the instance's journal-tracked **maintainer set**.
Every other author is logged and **dropped**, never triaged. The watcher invokes
no `claude` at all.

The gate here is **stricter** than the mention/comment watchers': **allowlist-only,
no org-membership fallback.** Driving the garden by filing an issue is more powerful
than leaving a comment on a watched PR, so the trust set is an explicit,
journal-tracked allowlist (`maintainers/allowlist`) and nothing else.

This document, and the job that produced it, is the maintainer authorization for
the widening; it is recorded as a journal `message` entry per the constraint.

---

## 2. Per-instance config lives in the journal, not main2

So that main2 stays generic — "clone main2 + init a fresh journal" is enough to
start a new garden — the repo identity and the maintainer set are **per-instance
journal state**:

- `config/garden-repo` — the instance's own `owner/name` (this instance:
  `kriskowal/garden`). Set with `set-garden-repo.sh <owner/name>`.
- `maintainers/allowlist` — the maintainer set, one login per line (`#` comments
  and blanks ignored, case-insensitive). Append with `add-maintainer.sh <login>`.

The watcher reads both from a synced journal clone (the committed copy via
`git show origin/journal2:…`, the same read path the allowlists use) and is
**inert** until both exist — it logs and exits 0, dispatching nothing. Enabling the
unit is therefore harmless; **writing the config is the deliberate per-instance
arming act.** A different garden instance points at a different repo and tracks its
own maintainers in its own journal.

The maintainer set is a **sibling** of `trusted-senders/allowlist`, not a reuse of
it: the two surfaces authorize different powers (driving the garden vs. being heard
on a watched PR), so they are kept as distinct one-source-of-truth lists with the
same proven loader mechanism.

---

## 3. The watcher pipeline (deterministic)

Per tick (`garden-issue-inbox.timer`, ~120s):

1. Read `config/garden-repo` + `maintainers/allowlist` from a synced journal clone;
   stay inert if unset/empty.
2. Poll issues + issue-comments since a **durable journal cursor**
   (`cursors/issues/<owner>-<repo>`, `last_seen` = max processed `created_at`) via
   the source handler. The handler `require_tools gh jq`, `--paginate`s, and parses
   with jq; a missing jq fails **loud** (the 2026-06-24 silent-outage lesson), and
   its stderr is surfaced on failure rather than swallowed.
3. For each row, ascending by `created_at`:
   - **Steady-state dedup:** skip rows at or before `last_seen` (the source selects
     `created_at >= since` inclusively so a boundary interaction is never missed;
     the watcher's strict `> last_seen` filter dedups the boundary).
   - **MAINTAINER-TRUST GATE** on the author — drop (log, slide cursor) if not a
     maintainer, **before any body is used**.
   - **Closing etiquette:** if the issue is `closed` and `closed_by == submitter`,
     that is the **terminal** signal — dispatch nothing, slide the cursor.
   - **Dispatch** (below).
   - **Verify** the dispatch landed on `origin/journal2`; advance the cursor only
     over the successfully-handled prefix, so a crash re-processes (never skips).

The watcher itself touches GitHub only through the source handler; all gh/jq lives
in the handler, so the watcher's logic is exercised with a deterministic stub.

### TSV the source emits

```
kind  created  id  number  author  submitter  state  closed_by  url  body
```

`kind ∈ issue | issue-comment`. PRs are excluded (GitHub folds PRs into the issues
API; a `.pull_request` member marks them). For comments, the source **joins the
parent issue** once per distinct issue (cached) to supply `submitter`/`state`/
`closed_by` and to drop PR comments.

---

## 4. Dispatch model and the issue note

Each issue keys to a stable **job spine**: `issue-<owner>-<repo>-<number>`.

- **New issue (trusted):** `post-job <spine>` carrying the **issue note** and a
  generic body. Idempotent by spine (a re-poll/prior tick no-ops).
- **New comment (trusted) on an in-flight issue:** delivered as a **message** to the
  issue's doer via `inbox-send <spine>` (the doer's job basename *is* the spine).
  `inbox-send` reaches a live inbox, or **dead-letters** when the doer has finished;
  `garden-deadmail` then promotes the dead letter to a job. Either path is success.
  - *Why inbox-send, not `send-msg job/<spine>`:* the dead-letter→deadmail→job
    promotion that the spec requires for a finished doer is a property of
    `inbox-send` (it dead-letters to `inbox/dead/`); the bus topic `job/<base>` has
    no such fallback. `inbox-send <spine>` is the route that both reaches the
    in-flight doer and survives a finished one.
- **Submitter-closed issue:** terminal — nothing further is dispatched.

### The issue note

Every dispatched job and every comment message carries a delimited block:

```
----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-<owner>-<repo>-<number>
issue_url:   https://github.com/<owner>/<repo>/issues/<number>
submitter:   <login>
----- END ISSUE NOTE -----
```

It tells any agent in the chain **where to follow up**: reply by commenting on
`issue_url`, never email or act outside the thread, and **never close** the issue
(the submitter closes it). The **propagation rule** (enforced by
`skills/issue-inbox/SKILL.md`): a follow-on job copies the block **verbatim**, so it
survives the whole work chain.

**Deadmail carries the note for free.** `deadmail.sh` promotes a dead-lettered
message by `cat`-ing the *entire* message into the job body; since the note rides
inside that body, the promoted job inherits it unchanged. No change to `deadmail.sh`
was needed — only a clarifying comment and a regression test that asserts the
promoted job carries `issue_url`/`issue_spine`.

---

## 5. Tests

`scripts/jobs/test/run-test.sh` SUBTEST 26 drives the watcher against a throwaway
journal with a stubbed source (and a stubbed `gh` for the source handler), asserting:

- a non-maintainer issue/comment is **dropped** (no job, no message, no LLM);
- a maintainer issue → a **job carrying the issue note**;
- a maintainer comment on an **in-flight** issue → a **message** to the doer;
- a maintainer comment on a **dead** doer → a **deadmail-promoted job carrying the
  note**;
- the issue note **propagates** into a follow-on job (the consumer rule);
- a **submitter-closed** issue dispatches nothing (terminal);
- the watcher stays **inert** with no `config/garden-repo`;
- the source handler excludes PRs and joins parent-issue metadata.

---

## 6. Bring-up

Per host, once the journal is initialized:

```sh
scripts/jobs/set-garden-repo.sh kriskowal/garden     # this instance's own repo
scripts/jobs/add-maintainer.sh  kriskowal            # one per maintainer login
scripts/jobs/install-units.sh   install              # render + reload units
scripts/jobs/install-units.sh   enable-services      # auto-enables the timer
```

The `garden-issue-inbox.timer` is a normal non-template timer with
`WantedBy=timers.target`, so `enable-services` derives and enables it
automatically; it no-ops until the config above exists.
