---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design job. Source: liaison-bus structural finding, 2026-08-12 (sent by endolin-garden2-5bcdff64), following the fleet independently building @endo/sha256 twice (endojs/endo-but-for-bots#836 merged into frozen base `llm-bfc91f5`, invisible from live `llm`; endojs/endo-but-for-bots#903 built from scratch ~10 days later against live `llm`). Disposition of those two PRs was already handled in the originating job (endojs/endo-but-for-bots#903 is the carrier, cross-referenced against #836); this job is only the structural fix.

Root cause: a producer scoping a brand-new package/feature reads live `llm` to check "does this exist yet", but a same-named package merged into a FROZEN base (e.g. `llm-bfc91f5`) is invisible from live `llm` until the frozen stack rebases forward. This is not isolated — `llm-bfc91f5` alone currently strands 3 PRs (endojs/endo-but-for-bots#836, #888, #943) 254 commits behind live `llm`, and the fleet has separately hit frozen-base drift on endojs/endo-but-for-bots#621, #503, #475, #910.

Two candidate fixes were proposed (design and choose/combine, don't just pick blindly):

1. **Supersession / new-package check at build-scoping time** (recommended first cut): before a producer starts a brand-new package or feature, query open + recently-merged PRs fleet-wide for the same package name / changeset slug across ALL bases (not just the target base), e.g. `gh pr list --search` on the package path or `.changeset` slug. A hit surfaces "this may already be built on base X" for a human/liaison decision before work starts. Narrow, additive, no policy change.
2. **A policy on merging into frozen bases**: new packages / net-new features land only on the LIVE base; frozen bases take only fixes to work already on that base. At minimum, a merge into a frozen base should emit a fleet-visible note ("package/feature X now exists on frozen base Y") so the next scoping read can find it. This is a fleet-wide policy call — flag it for the maintainer rather than landing it unilaterally.

Produce a design (`designs/<slug>.md` per repo convention) that specifies where in the build-producer flow the supersession check runs, what it queries, and how a hit is surfaced/actioned. Weigh whether (2) is worth proposing to the maintainer as a followup even if out of scope to land here.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-14T05:29:02Z
