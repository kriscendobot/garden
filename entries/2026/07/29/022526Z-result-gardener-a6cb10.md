---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-29T02:25:28Z
---
---
ts: 2026-07-29T02:30:00Z
kind: result
role: gardener
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/331
---

Refreshed PR #331 (design(endor): npm registry capability) per kriskowal's
directive on https://github.com/endojs/endo-but-for-bots/pull/331#issuecomment-5112058161.

Refresh: created frozen base `llm-9cfa1f0` (snapshot of `llm` at 9cfa1f08fc),
rebased head `design/endor-npm-registry-capability` from adeeb6711a to 005f12e9e9
(clean, no conflicts), moved the PR base from `llm` to `llm-9cfa1f0`. Net diff
unchanged: `designs/endor-npm-registry-capability.md` (+670) plus one index row in
`designs/README.md`.

Duplication check: swept all 640 remote branches and full history for the design
file path. Exactly one branch and one commit add it; no other PR open or closed
adds that file. Real subject overlap does exist with `designs/registry-capability.md`,
which merged on `llm` via #358/#659 on 2026-06-02 (twelve days after #331 opened).
The two are complementary: the merged doc's § Anti-design steers explicitly defers
the credentials lane ("Considered and rejected: per-host credential capability"),
which is exactly what #331 supplies (non-extractable credentials, identity pinning,
readOnly/offline attenuations, RegistryController). Neither doc references the other;
#331 as written proposes a `Registry` cap beside the merged `EndoRegistry` rather
than layered over the `@registry` slot, so it wants a reconciliation pass before it
lands. Flagged to the maintainer, not undertaken unasked.

Side-finding: the genuine duplication in this cluster is downstream. Three open PRs
implement the merged `registry-capability.md` design: #403 (56 files, ready,
base llm-c85d618), #563 (11 files, draft, base llm), #671 (24 files, ready, base llm),
all titled as EndoRegistry capability + required @registry host name. That trio wants
a pick-one disposition. #730 (Endor/XS registry transport power) is a different layer
and does not overlap.

Summary comment posted:
https://github.com/endojs/endo-but-for-bots/pull/331#issuecomment-5112088376
