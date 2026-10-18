---
kind: result
role: decomplector
host: endolin-garden-ece02cb4
at: 2026-10-18T02:52:41Z
job: kriscendobot-minion.town-pr203-gauntlet-panel-1
claim: 270706d60abe3431
---
PR #203 decomplector review (originating dispatch: `kriscendobot-minion.town-pr203-gauntlet-panel-1`).

**Verdict:** request-changes

**Findings:**

- must-fix: `designs/git-remote-capability.md:676-711` states that a bearer secret referring to an owner violates the ocap test, then classifies a credential derived from an owner's name and authorizing that owner's allocator as object-designating. The proposed "allocator" has no identity independent of the account and quota policy, so this braids identity and billing policy into allocation authority. Mint a random allocator capability per grant and keep `owner` only as quota attribution, or classify this credential as outside the ocap graph; "pending maintainer confirmation" does not resolve the design's own test. [rule: roles/jurors/decomplector/AGENT.md § Primary surface]

- must-fix: `designs/git-remote-capability.md:713-718` makes every read delegation for a partition share one facet key, revocation domain, and mint budget. That conflates the immutable right (read this partition) with mutable per-delegation administration, so two purportedly distinct capability objects interfere. Give each delegation its own facet identity and administrative state, with the partition read authority as the shared underlying value. [rule: roles/jurors/decomplector/AGENT.md § Primary surface]

- must-fix: the added retention/root/facet-key account spans supervisor formula persistence and the partition store, but supplies no ownership map. It implies that persistence owns the partition, retention hash, and URL bindings while the supervisor durably retains the matching retention key and replays `open`; it never assigns the logical commit/discard decision when partition creation succeeds but formula retention fails, nor separates store restart recovery from formula replay and execution classification. Add the required boundary row and four ownership answers, including orphan handling for that split commit. No inner type in this patch misuses an outer lifecycle name. [rule: skills/ownership-map/SKILL.md]

Self-improvement: nothing this time.
