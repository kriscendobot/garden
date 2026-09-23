---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T06:58:24Z
---
# Retro: endojs/endo-but-for-bots #475 review 4998406945 (prosecutor)

Second-loop retrospective on the maintainer review that produced primary
`endojs-endo-but-for-bots-pr475-review-f66ed689`.

**Grounded in the world, not the primary report.** Re-fetched the review: body
empty, one inline (erights) asking whether the TypedArray emulation shares the
DataView reverse-map problem. Confirmed the directive deliverable EXISTS and is
genuine — kriscendobot reply 3834924079 answers it, and fix commit 4dbe5ffff
("pair buffer maps at creation") is real and touches lib.js. No false-peer
no-op discrepancy.

**Verdict: MISS** (correctness-bug). The immutable-arraybuffer bidirectional
weak-map invariant was installed forward-only at buffer creation and reverse-only,
separately, in each of two sibling constructors (DataView + TypedArray). The
maintainer probed the DataView site, then had to ASK whether the TypedArray twin
had the same gap — it did. No panel seat enumerates the sibling call sites that
jointly maintain an invariant. Joined cluster `incomplete-sibling-transformation`
(the exact prior pattern from member 9885f3d8).

**Threshold: HELD.** Cluster now count=3, status=open, but prs={475} — all three
members are facets of the same long-running byteArray/immutable-arraybuffer
campaign. The floor requires >=3 misses across >=2 DISTINCT PRs; the two-PR guard
exists precisely to stop one heavily-reviewed PR from reading as systemic. Severity
moderate, no standing rule that failed to bind, so no single-miss bypass. No
review-improve job dispatched. A first match on a second PR trips a fresh call.

Self-improvement: nothing this time.
