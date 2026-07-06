# Garden-library change: surface would-be maintainers from the issue-inbox watcher

This is a change to the GARDEN'S OWN code (scripts/jobs/), landed on `main2`
directly (no PR — see CLAUDE.md § Conventions). No project-repo or upstream work.

## Motivation

The issue-inbox watcher (`scripts/jobs/issue-inbox-watcher.sh`) gates every issue/
comment author against the maintainer allowlist (`maintainers/allowlist`,
allowlist-only, no org fallback). Today a NON-maintainer author is dropped with only
a `log` line the operator never sees — so a genuine collaborator asking to interact
(the real case: mhofman on issue #29) is silently ignored until a human notices out
of band. Close that gap: when the watcher drops a non-maintainer, surface it ONCE to
the maintainer inbox so the operator can notice and decide (add them, or ignore).

## What to implement

In `issue-inbox-watcher.sh`, in the MAINTAINER-TRUST GATE drop branch (the
`if ! is_maintainer "$author"; then ... slide "$created"; continue; fi` block, ~line
473): in addition to the existing log + drop + cursor-slide (all UNCHANGED), emit a
deduped maintainer-inbox message naming the individual.

Requirements:
- **One message per would-be maintainer**, not per comment. Dedup with a per-author
  marker file under `$GARDEN_STATE`, e.g.
  `$GARDEN_STATE/issue-inbox/notified-nonmaintainers/<lowercased-login>` (GitHub
  logins are `[A-Za-z0-9-]`, filesystem-safe). Create the marker ONLY after a
  successful send, so a failed send is retried on the author's next interaction
  (no silent loss), and a subsequent comment from the same author sends nothing.
- **Producer:** send via `inbox-send.sh maintainer` (body on stdin), with
  `GARDEN_SENDER="issue-inbox-watcher"`, exactly as `identity-drift-guard.sh`
  emits its `kind: error` report. **Route the call through a new overridable
  variable** (mirror the existing `GARDEN_ISSUE_POST` / `GARDEN_ISSUE_MSG` seams),
  e.g. `: "${GARDEN_ISSUE_MAINT_SEND:=$HERE/inbox-send.sh}"`, so the test can stub
  it. Also honor a suppression escape hatch consistent with the codebase (e.g. skip
  when `GARDEN_NO_MAINTAINER_ALERT=1`) if that keeps tests/other callers clean.
- **Message content — STRUCTURED FIELDS ONLY. Never include the untrusted comment
  body** (prompt-injection discipline, roles/COMMON.md; the whole point of the gate
  is that the TEXT is untrusted). Use only: the author login (`@<author>`), `$REPO`,
  the issue `#<number>`, and `$url`. First body line tags the kind (e.g.
  `kind: access-request`), mirroring the drift guard's `kind: error` convention.
  Body should: name the individual; say they interacted but are not on the
  allowlist so it was dropped; give the exact add command
  (`scripts/jobs/add-maintainer.sh <author>`); note that FUTURE comments will then
  dispatch but THIS one was already dropped (re-post if wanted); note it is shown
  once per individual; and that reply/archive dismisses it.
- Keep the existing drop semantics intact: still `log`, still `dropped=$((dropped+1))`,
  still `slide "$created"`, still `continue`, still dispatch NOTHING. Only ADD the
  surfacing.

## Test (required)

Extend `scripts/jobs/test/issue-inbox-watcher-test.sh`:
- Add a stub for `GARDEN_ISSUE_MAINT_SEND` (like the POST/MSG stubs) that records the
  body it receives to a log file.
- Assert: (1) a non-maintainer comment produces EXACTLY ONE maintainer message that
  names the author login and does NOT contain the comment body text; (2) a SECOND
  comment from the SAME non-maintainer produces NO additional message (dedup marker);
  (3) a comment from a DIFFERENT non-maintainer produces its own (separate) message;
  (4) the existing behavior is unchanged — the comment is still dropped, dispatches
  nothing, logs `non-maintainer` + id, and slides the cursor (extend/keep test D).
- Run the full test and any related suite; the change must be green before commit.

## Land

Commit to `main2` directly with a clear message; push. Garden-meta change, so no
project worktree and no PR. Out of scope (mention in your report as a possible
follow-up, do NOT do here): applying the same "surface the sender once" idea to the
GitHub-wide mention-watcher's sender-trust gate.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 9
  claimed_at: 2026-07-06T23:08:39Z
