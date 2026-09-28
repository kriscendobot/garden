---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
token-budget: 300000
---
# Add a "dispatch tier system" section to README.md

Follow-up to yesterday's `mentat-garden-docs-refresh-20260927` pass. That
refresh touched many surfaces but never gave the tier vocabulary
(`mentat`/`mentor`/`minion`/`myrmidon`) a standalone explanation for a
maintainer reader. Today it appears only in passing mentions —
"`myrmidon`-tier americanizer", "Workers become differentiated (by role,
skill mix, and model tier)" — with no single place a reader lands to
understand what the four tiers ARE, what backs each one, or when automatic
dispatch picks which.

Repository: `kriscendobot/garden`, branch `main2` — land direct, no PR, per
CLAUDE.md's own-repo convention (unless you find real open questions). Work
in an isolated project worktree (`ensure-project-worktree.sh <base>
kriscendobot/garden main2`). Never run git against `$GARDEN_ROOT`.

## Source of truth — read it fresh, don't trust a summary

`skills/model-selection/SKILL.md` is canonical and drifts (it was already
updated once, 2026-09-13, since creation). Read its current content in full,
including the tier table, the per-provider model rows, the automatic
dispatch boundary (`mentor` ceiling, `minion` fallback, `myrmidon` as an
expedient non-escalation tier, `mentat` as **manual-only** via
`post-manual-job.sh`), and the collision/fallback notes (the Fireworks
GLM-5.2-vs-K3 collision, the retired local-Qwen hermit lane) — summarize
faithfully, don't invent detail it doesn't state, and don't copy stale
specifics that may have since changed.

## What to write

A new `README.md` subsection — `### The dispatch tier system` reads well
under `## 3. How it works`, near where role/model differentiation is already
discussed (see the "Workers become differentiated..." line, § Going deeper,
line ~414) — but use your own judgment on placement after reading the whole
document's flow; a maintainer skimming top-to-bottom should hit it before or
right alongside the first tier-name mention it currently has no context for.

Cover, at a level a maintainer (not necessarily a garden internals expert)
can follow in one read:
- The four tiers in descending thoughtfulness (mentat, mentor, minion,
  myrmidon) and roughly what each is for.
- That `mentat` is manual-only — no automatic producer ever reaches it; a
  human (or a liaison acting on an explicit maintainer directive) posts it
  via `post-manual-job.sh`, and it's claimable by whichever provider's
  worker is live for that model.
- That automatic/producer-posted work has a ceiling at `mentor` with
  `minion` as the fallback, and `myrmidon` is a distinct expedient tier, not
  an escalation step.
- That a tier is multi-provider (which concrete model backs it varies by
  which worker kind claims the job — monk/cleric/mystic/fireworker/etc.),
  pointing to `skills/model-selection/SKILL.md` and
  `scripts/jobs/model-tier-inventory.tsv` as the live, authoritative,
  closed inventory rather than duplicating the per-model table in README
  (a duplicated table is the thing that drifts; a pointer doesn't).
- One or two concrete, already-familiar examples grounded in verbs the
  reader has already seen in the Key vocabulary table (§ 1) —
  `americanize`/`deslop` as myrmidon-tier, `design`/`build` as the Opus/mentor
  ceiling — rather than inventing new examples.

Keep it proportionate to the rest of README's style: prose + maybe one small
table, not a re-export of the skill file's full tier table.

## Validate

Run whatever doc-gate checks `mentat-garden-docs-refresh-20260927` used
(look at its landed commits / the CI run it references for the gate names —
relative-link resolution, frontmatter/whitespace checks) before completing.
Confirm the new section's internal links resolve.

## Report

Quote the section you wrote (or its final heading + first paragraph) in your
completion report, and name the commit that landed it.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T05:30:50Z
