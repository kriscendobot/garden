---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-22T06:34:41Z
---
refs: endojs/endo-but-for-bots#475:review:4955643812:retro

# Retrospective — endojs/endo-but-for-bots#475 review 4955643812 (erights)

**Verdict: review-miss** (category `docs-drift`).

erights' inline review on `packages/immutable-arraybuffer/README.md` corrected a
false doc claim: the README recommended the `immutable` accessor as the
"canonical brand check" for emulated-vs-genuine immutable views, when that axis
answers only mutable-vs-immutable. The correct semantics were already documented
in the repo's own reference code (`@endo/pass-style` `byteArray.js`), which the
wrong paragraph — introduced by this PR's own build commit `a93262fd47` —
contradicted. A doc claim contradicting authoritative in-repo code is catchable
by a docs/spec review lens, so it is a miss, not new direction.

Verified in the world (not the primary report): re-fetched the review and inline
comment; confirmed the primary's fix (`cae5509130`, README-only) and the reply
(`r3799770902`) genuinely exist. The primary loop closed correctly.

**Recorded** to `review-misses/misses/endojs-endo-but-for-bots-pr475-review-41c12eb0.md`,
minting new cluster `docs-claim-contradicts-code-semantics` (count=1, prs={475},
status=open).

**Threshold: held, no dispatch.** count=1 on a single PR is below the floor of
K≥3 across ≥2 distinct PRs. Severity is minor and no pre-existing standing rule
required cross-verifying doc claims against reference code, so the single-major
bypass does not apply. Await recurrence past the floor before dispatching a
`review-improve-*` job.

Self-improvement: no friction; the retrospective loop and store writer behaved
as documented.
