# PR #277 — shepherd the remaining failure to green + reply (maintainer directive)
Repo: endojs/endo-but-for-bots (bot). PR #277 — *feat(daemon): EndoMount.followNameChanges live
entry-name stream* — https://github.com/endojs/endo-but-for-bots/pull/277 — base `llm`.
kriskowal directive (2026-06-28T06:59Z, comment): **"@kriscendobot Shepherd."** — got no reply.
Current CI: 23 pass, **1 fail: `test (22.x, macos-15)`**; mergeable=UNKNOWN (likely needs a refresh/rebase onto current `llm`).
Task: shepherd to green — refresh/rebase onto `llm` if stale, diagnose the **macos-15** test failure (real bug, or platform flake/pre-existing?), drive it green or explain it as a deliberate pre-existing/flaky red. Escalate to a fixer if out of shepherd scope (standing auto-chain). Then post a **status reply comment** on #277 (what was red, what you did, final CI + mergeable). Bot fork; no upstream contact.

---
claim:
  host: endolinbot2
  gardener: 51
  claimed_at: 2026-06-30T23:06:35Z
