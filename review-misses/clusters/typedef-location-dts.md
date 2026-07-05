---
slug: typedef-location-dts
category: style-convention
status: closed
count: 1
members:
  - endojs-endo-but-for-bots-pr442-review-61c65980
prs: [442]
improvement_job: review-improve-typedef-location-dts
improved_by: commit 33a6994ef on main2: new deterministic probe scripts/jobs/gardening/pre-push-gates/probes/typedefs-belong-in-dts.sh (tier-1 gate); sharpened roles/builder/AGENT.md + roles/jurors/typist/AGENT.md to name the whole typedef-only-module shape; probe row + field note in skills/pre-push-gates/SKILL.md; probe added to builder/fixer gate enumeration. Verified fires on #442 pre-fix packages/platform/src/fs/types.js, abstains on #58 trace-aggregator.js.
---



Exported/shared type definitions authored as @typedef in a .js module instead of a hand-written .d.ts — a repeat of an explicit maintainer directive the garden already encoded as prose only.

**Threshold rationale:** Dispatched below the numeric floor (count=1, prs={442}) via the **severity bypass**:
a single `severity: major` miss whose grounds cite a standing rule that already existed
and did not bind. The `.d.ts`-for-type-definitions convention is written in both the
builder directive (`roles/builder/AGENT.md`) and the always-on typist seat brief
(`roles/jurors/typist/AGENT.md`), both encoded from an identical maintainer directive on
`endojs/endo-but-for-bots#58` (2026-07-02, "Adjust the garden to avoid this in the future
with builder directives and a reviewer"). It recurred on #442 two days later — a pure
sense-and-correct failure of an explicit maintainer prevention-request, spanning two
distinct PRs (#58 → #442). Waiting for a third maintainer complaint about a convention he
already asked to be prevented is the wrong trade. The #58 round delivered only the two
weakest tiers (prose + a panel seat that fires only when the gauntlet runs — and #442 ran
no gauntlet); the dispatched job adds the missing tier-1 deterministic pre-push gate that
cannot be skipped or forgotten.
