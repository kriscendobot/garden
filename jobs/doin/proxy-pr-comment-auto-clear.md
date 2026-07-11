Role-author job: add a **PR-comment auto-clear** standing behavior to the proxy,
per maintainer directive (kriskowal, 2026-07-11): *"clear every message in the
maintainer inbox that is or could be a comment on one or more pull requests and
acknowledge all such messages as read — make this a standing instruction for the
proxy."*

Land on `main2` (direct push, no PR, per CLAUDE.md § Conventions). Build on CURRENT
`origin/main2`, not any stale deployed checkout.

## Shape — mirror the existing § Watchdog auto-clear exactly

There is already a sanctioned deterministic pre-pass sibling to copy:
`clear_watchdog_messages()` (scripts/jobs/proxy.sh ~L76) and `park_blocked_jobs()`
(~L132), both invoked at ~L218–219, both **plain code, NO `claude -p`**, run BEFORE
the gating enumeration and the cost-gated handler, each logging a single
**deduplicated tally** line and **never re-posting** to the maintainer. Add a THIRD
sibling, e.g. `clear_pr_comment_messages()`, invoked alongside them.

Also add the doc section `roles/proxy/AGENT.md` § **PR-comment auto-clear**
(sibling to § Watchdog auto-clear), citing this 2026-07-11 directive, describing the
criterion and guardrails below, and noting the suppression stays auditable via the
proxy's own tally log.

## Criterion — what to archive (unread → read)

Archive an unread maintainer message when it **references one or more pull
requests** AND it is safe to clear (guardrails below). PR-reference signals
(deterministic, case-insensitive):

- a GitHub PR URL: `github.com/<owner>/<repo>/pull/<n>`;
- `pull request`, `PR #<n>`, `PR#<n>`, `PR <n>`, `pull-request-<n>`;
- a **PR-scoped `from:` or `reply_to:` job base**, e.g. `*-pr<n>-*`,
  `*-pull-request-<n>-*`, `shepherd-*-pr<n>-*`, `gauntlet-*-pr<n>-*`, `*-review-*`
  on a PR.

The maintainer's intent is **inclusive** ("is or could be a comment on a PR"), so
lean toward clearing genuine PR references — but a **bare `#<n>` alone is NOT a
sufficient signal** for the standing rule: it also matches kriskowal/garden issues
(`garden#33`, `garden#4`) and README item numbers, which must not be silently
swept. Require a real PR context as above. (The one-time bulk clear the liaison ran
on 2026-07-11 was deliberately broader and human-reviewed; the standing rule must
be safer because it runs unattended forever.)

## Guardrails — what must NEVER be auto-cleared by this rule

1. **Live gating questions.** A blocked gardener's message with a `reply_to` whose
   doer inbox is **still live** is the proxy's core input — the handler must still
   answer it. The PR-comment pre-pass must **skip any eligible gating question**
   (same live-doer test the enumeration uses), even if it references a PR. Only
   **non-gating** PR messages (completion reports / notices from a finished or
   absent doer — "the maintainer's to read") are eligible for auto-clear. Blocked
   messages carrying a structured `blocked_on:` are already handled by
   `park_blocked_jobs()`; do not double-handle.
2. **Non-PR infra/progress senders.** Never archive messages that carry no PR
   reference — `watchdog:self-heal*`, `gardener:self-heal-fix-*`,
   `gardener:finbot-progress-*`, `triager:*` circuit-breakers, and foreman messages
   naming only a job base or a garden issue. (These have no PR signal, so a correct
   detector leaves them untouched — assert this in tests.)
3. **Ordering.** Run this pre-pass after `clear_watchdog_messages` /
   `park_blocked_jobs` (so watchdog and blocked-on are handled by their own rules
   first) and before the gating enumeration.

## Output / audit

Like the watchdog sibling: move each matching message `unread → read`, one atomic
commit+push (`proxy: auto-clear N PR-comment message(s)`), and log ONE deduplicated
tally line (`cleared N PR-comment messages: <label>×K, …`) so the suppression is
recoverable from the proxy's logs. Never re-post to the maintainer.

## Tests

Extend the proxy pre-pass test suite the same way the watchdog auto-clear is
tested (look for its test; if the harness stubs `GARDEN_PROXY_HANDLER` /
`GARDEN_PROXY_CLONE`, reuse it). Cover: (a) a PR-URL message and a `PR #n` message
and a `shepherd-*-pr<n>-*` sender are archived; (b) a live gating question that
references a PR is PRESERVED; (c) `self-heal*`, `finbot-progress*`, a `garden#33`-only
message, and a bare-`#2`-README message are PRESERVED; (d) the tally line is emitted
and nothing is re-posted.

## Definition of done

`main2` carries the new `clear_pr_comment_messages()` pre-pass wired into proxy.sh,
the `roles/proxy/AGENT.md` § PR-comment auto-clear section, and green tests. After
deploy, the proxy autonomously acknowledges PR-comment maintainer messages every
tick, leaving live gating questions and non-PR traffic for the maintainer.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  claimed_at: 2026-07-11T05:53:11Z
