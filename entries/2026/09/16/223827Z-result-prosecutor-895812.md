---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-09-16T22:38:29Z
---
---
project: endo-but-for-bots
refs:
  - jobs/doin/endojs-endo-but-for-bots-pr1072-review-c8a0f42b-retro.md
  - endojs/endo-but-for-bots#1072:review:5059889251:retro
---

# Retrospective on endojs/endo-but-for-bots PR #1072 review 5059889251 — MISS

Recorded a moderate `spec-violation` review miss. The reviewed OCapN-Noise
design encoded connection hints in query parameters, while the repository's
authoritative `designs/daemon-locator-reference.md` had specified
`@`-delimited path components since commit `5bd2f09d6` (2026-06-25) and
explicitly reserved the query string for alleged attributes. That document was
present at reviewed commit `da0428084`, so the feedback enforced an existing
protocol contract rather than introducing new direction.

World-grounded review history: PR #1072 was draft and had no gauntlet/panel job
or panel PR comment, consistent with the manual-trigger workflow; this was not
evaluator avoidance. The failure was the preceding review-feedback edit
(`endojs-endo-but-for-bots-pr1072-review-73226ec0`) not reconciling the related
authoritative locator design, plus no spec-keeper/integrator cross-check before
the draft returned to the maintainer. The primary job genuinely resolved the
directive in commit `8e3e7ef62` and replied on the inline thread, so there is no
false no-op discrepancy. A prior retrospective's assertion that no standing
locator grammar existed is contradicted by the repository history above; this
retrospective does not repeat that report's unsupported conclusion.

The writer recorded
`review-misses/misses/endojs-endo-but-for-bots-pr1072-review-c8a0f42b.md` and
minted open cluster `related-design-contract-cross-check` with `count=1`,
`prs=[1072]`, `recurrence=0`. Threshold evaluation was recorded on the cluster:
held below the default floor (one moderate miss on one PR); the major-severity
bypass does not apply. No improvement job was dispatched.

Evidence: GitHub REST review and inline-comment APIs; journal #1072 job/panel
history; `git show da0428084:{designs/daemon-locator-reference.md,designs/ocapn-noise-network.md}`;
`git log --follow -- designs/daemon-locator-reference.md`; writer outputs
`recorded=... verdict=miss ... count=1 status=open prs=1072 recurrence=0` and
`status=open`.

Self-improvement: nothing this time.
