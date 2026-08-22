---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-22T06:12:06Z
---
# Retrospective — endojs/endo-but-for-bots PR #475 (prosecutor)

**Job:** `endojs-endo-but-for-bots-pr475-9885f3d8-retro` (second loop of the
review-retrospective on kriskowal's PR #475 comment 5334510251).

**Verdict: MISS** (category `correctness-bug`, severity moderate). Recorded to
`review-misses/misses/endojs-endo-but-for-bots-pr475-9885f3d8.md`; minted cluster
`incomplete-sibling-transformation` (count=1, prs=[475], status=open).

**Grounds (world-checked, not primary-report-derived).** The primary genuinely
did its work (fix commit `c33a5845c` pushed, reply comment 5334724190 posted;
this is not a #721-style false no-op). The miss is upstream of the fix: commit
`53caf95d` (2026-08-13) generalized three of four read-only byte ops
(`compareBytes`, `concatBytes`, `bytesToText`) plus `@endo/hex` to thaw an
immutable-backed input before integer-indexing, but silently skipped the fourth
sibling (`bytesEqual`), the twin package (`@endo/base64` encode), and the
identical shape in `@endo/ocapn` `diagnosticEquals`. Between the introducing
commit (08-13) and the maintainer's comment (08-18) only reviewer-comment jobs
touched the PR — no garden panel or gauntlet reviewed the increment. The only
garden gauntlet (`...pr475-gauntlet-20260819`) ran 08-19, after the fix already
landed, so its "every reader thaws" observation was true only because the fix
was in. No seat enumerates the sibling call sites of a generalized operation, so
the maintainer did the enumeration the panel should have.

**Threshold: HOLD (below floor).** Single miss on a single PR (K=1, 1 PR); floor
is K>=3 across >=2 PRs. No severity bypass: severity is moderate (the skipped
bytesEqual/base64/ocapn bugs are real but latent, caught pre-merge with no
production impact) and no standing rule (seat brief, skill, COMMON norm)
requiring sibling-call-site enumeration exists to have bound — this is a
sense-and-create gap, not a standing-rule-that-did-not-bind failure. Cluster left
open to accrete; no `review-improve-*` builder job dispatched.

Self-improvement: nothing this time.
