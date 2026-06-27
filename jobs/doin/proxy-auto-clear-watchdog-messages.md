# Proxy: auto-clear watchdog-class messages from the maintainer inbox (deterministic pre-pass)

Map: **build** (garden infra) on the garden's own repo, branch main2. Isolated worktree
off origin/main2; explicit-pathspec commit (`git commit -m … -- <paths>`); push HEAD:main2
via a git-rebase CAS loop.

Maintainer directive 2026-06-27: the proxy should **automatically clear watchdog messages
from the maintainer inbox going forward** (the maintainer just hand-cleared 11 of them —
10 comment-watcher inactivity false-positives + 1 self-heal-claude). They are autonomous-
monitor anomaly reports, not action requests, and pile up.

## Current behavior (scripts/jobs/proxy.sh + roles/proxy/AGENT.md)
The proxy only handles GATING questions (a message with a `reply_to` whose doer inbox is
still live, past grace, not already proxied) via its `claude -p` handler. Non-gating
messages — including `watchdog:*` reports — are explicitly left for the maintainer. The
cost gate runs the handler only when ≥1 eligible gating question exists.

## Required change
Add a **deterministic pre-pass** at the top of each proxy tick (after the sync, BEFORE
the gating-question enumeration and BEFORE the cost-gated handler) that, in plain code
(NO claude -p):
- Scans `inbox/maintainer/unread/` for messages whose frontmatter `from:` matches
  `^watchdog:` and ARCHIVES them (move unread→read; one commit; CAS push, same clone the
  proxy already syncs). Only `watchdog:*` senders — never gardener/maintainer/other.
- Logs a single deduplicated tally line to the proxy log (e.g. `cleared N watchdog
  messages: comment-watcher/kriskowal-garden×K, self-heal-claude×M`) so the suppression
  is AUDITABLE, but does NOT re-post anything to the maintainer (reducing the noise is
  the whole point).
- Is cheap (grep/jq + `git mv`); runs every tick. The `claude -p` gating handler is
  unaffected and still only runs on eligible gating questions.

## Safety / scope
- This is a SANCTIONED exception to the proxy's "always report to the maintainer"
  principle, scoped strictly to `watchdog:*` autonomous-monitor anomaly reports
  (informational, not action requests). Document it in roles/proxy/AGENT.md under a new
  "Watchdog auto-clear" section so the role brief matches the behavior.
- Gardener completion reports, gating questions, and any non-watchdog sender are
  UNTOUCHED.
- The tally log preserves an audit trail so a novel/distinct anomaly burst is still
  recoverable from the proxy's own logs.
- Backstop relationship: the root-cause fix `comment-watcher-no-inactivity-anomaly`
  (queued) stops the comment-watcher inactivity false-positives at the source; this
  auto-clear handles whatever watchdog noise remains, from any monitor.

## Tests
Extend the proxy subtest in run-test.sh: a `from: watchdog:*` unread message is archived
by the deterministic pre-pass with NO handler/`claude -p` call; a genuine gating question
still reaches the handler; a `gardener:*` completion report is left unread for the
maintainer; the tally is logged.

Deliverable: proxy.sh drains watchdog-class maintainer messages deterministically each
tick (auditable, no LLM), roles/proxy/AGENT.md documents it, and the run-test.sh proxy
coverage proves watchdog-archive vs gating-handler vs leave-for-maintainer.

---
claim:
  host: endolinbot
  gardener: 73
  claimed_at: 2026-06-27T16:49:26Z
