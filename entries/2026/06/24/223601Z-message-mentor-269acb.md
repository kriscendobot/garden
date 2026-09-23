---
kind: message
role: mentor
host: endolinbot
at: 2026-06-24T22:36:01Z
---
## Maintainer authorization — GitHub-wide @kriscendobot mention watch (sender-gated)

The maintainer (via the liaison, job `build-github-mention-watcher`) authorizes a
GitHub-WIDE watch for @kriscendobot mentions, implemented as
`scripts/jobs/mention-watcher.sh` (single instance `garden-mention-watcher`).

This is a deliberate widening of the monitoring posture beyond the gated-repo set
(CLAUDE.md § Monitoring safety constraint). It is safe GitHub-wide **only** because
the watch's prompt-injection defense is **not** repo-gating but a **deterministic
sender-trust gate** that runs in plain code with **no LLM**, before any mention
text reaches a job, a reactji, or `claude -p`:

- A mention is passed onward ONLY if its author is a verified trusted contributor:
  on the journal allowlist (`trusted-senders/allowlist`) OR a current member of the
  **endojs** or **Agoric** org (read-only `gh api orgs/<org>/members/<login>`).
- Any other sender's mention is logged and discarded — never triaged.

Verifying a sender is an *Agoric contributor* is a read-only trust check; it does
**not** authorize any work on agoric-sdk, which stays off-limits per the standing
scope rule.

Seed allowlist (resolved): kriskowal, erights, gibson42, kumavis, 0xpatrickdev,
mhofman (Mathieu Hofman = `mhofman`). The allowlist is journal data, extensible by
appending a login to `trusted-senders/allowlist` and pushing — no code change.

Armed: 2026-06-24. Code on main2 @ 5ee69791. Recorded per the constraint's
"explicit maintainer authorization recorded in a journal message entry" rule.
