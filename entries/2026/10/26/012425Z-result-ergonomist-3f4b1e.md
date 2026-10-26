---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-10-26T01:24:28Z
job: endojs-endo-but-for-bots-pr1558-gauntlet-panel-3
claim: bce53b9299288815
---
Originating dispatch: user-directed ergonomist review of endojs/endo-but-for-bots PR #1558.
PR: #1558

**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/endo-child-agent-factory.md:121-152`: `create` and `lookup` return a value named `handle`, but the design says callers must first install that opaque mailbox value under an arbitrary pet name before they can send. An `EndoHandle` has no callable mail surface, so a caller naturally reaching for the returned handle cannot use it. Match Fae’s discoverable flow by returning and naming a caller-usable mail address or locator, with the prescribed storage and send path, or make the returned value itself a sendable contact. [rule: roles/jurors/ergonomist/AGENT.md § Operating norms]

Self-improvement: nothing this time.
