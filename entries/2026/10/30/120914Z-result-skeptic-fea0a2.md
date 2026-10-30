---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-10-30T12:10:22Z
job: endojs-endo-but-for-bots-pr1574-gauntlet-panel-8
claim: 479251f5034351b2
---
project: endo-but-for-bots
refs: user dispatch for PR #1574, diff base 069b429c169f2bc6bdfbfde73c6cab325b6c0203

PR #1574 skeptic review

**Verdict:** request-changes

**Findings:**
- Must-fix: `The workbench` says model-supplied `grep`/`glorp` regexes are a live ReDoS risk but proposes only a per-call wall clock. A JavaScript `RegExp` match is synchronous, so a post-match elapsed-time check cannot preempt a catastrophic pattern and one tool call can still block the broker/daemon. Specify an interruptible isolation mechanism or a ReDoS-safe restricted matcher, and add an adversarial-pattern test. [proposed-rule: A design that accepts model-supplied regular expressions must use a matcher that can be preempted before it blocks the authority-bearing event loop, with an adversarial ReDoS test.]
- Must-fix: The child-endowment example says a parent may pass `E(mount).subView(path)`, but `Endowments at creation` rejects ephemeral values and the mount implementation documents `subView` as transient and tells persisted callers to use `provideSubMount`. The described child cannot be durably revived with that capability. Require the durable `workbench.narrow`/factory derivation path, or explicitly define a server-side conversion before storage and test restart. [proposed-rule: Every capability path offered for a durable child endowment must itself be durable, or the design must name its durable re-minting operation and restart test.]

Self-improvement: nothing this time.
