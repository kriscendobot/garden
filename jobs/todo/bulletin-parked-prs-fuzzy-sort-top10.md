# Bulletin "Parked for maintainer feedback": fuzzy-sort by recency + roadmap relevance, top ~10

Wear the **mentor** role. The bulletin's **"## Parked for maintainer feedback"** section
(added by `bulletin-restructure-latest-top-parked-prs`, now live in `scripts/jobs/bulletin.sh`)
currently lists **every** review-requested PR — ~35 entries, some waiting 789 days. That is
noise. Rank them with a **fuzzy score** and show only the top **~10**. Infrastructure on
`main2` (bot identity; isolated worktree off `origin/main2`; redeploy the bulletin loop).

## The fuzzy score (both factors heavily weighted)

Score each parked PR by a weighted combination of:

1. **Recency** — favor recently-active PRs. Derive from the PR's last activity (`updated_at`,
   or the "waiting <age>" already computed). Use a decaying function so a PR active in the last
   days scores near-max and one idle for hundreds of days scores near-zero (e.g. exponential
   decay or a tiered score). This is deterministic.
2. **Relevance to tasks high in the roadmap** — favor PRs tied to **high-priority roadmap
   items**. Map each PR to its roadmap milestone/design and weight by how **high in the
   roadmap** that item sits (earlier/critical-path milestones score higher). Use the garden's
   roadmap/plan data: prefer the journal plan/roadmap being built by `implement-plan-in-journal`
   (the reconciler's PR↔design/milestone mapping) as it lands; until then, approximate from the
   existing milestone classification (the journalist's Per-Design Estimates binning) and PR
   metadata (title/labels/linked design). Degrade gracefully if roadmap data is unavailable
   (fall back to recency-only) — never wedge.

Combine into one fuzzy score (a weighted sum; tune so a stale-but-on-critical-path PR and a
fresh-but-peripheral PR both surface, but ancient peripheral PRs drop off). **Sort descending,
take the top ~10.** Note the cutoff (e.g. "showing 10 of N parked").

## Constraints

- Keep the section's existing **throttled `gh` query + cache + graceful degradation** (do not
  hit the API per tick); the scoring runs over the cached set. Use gh built-in `--jq`, not
  external jq, and `require_tools`-guard per the hardening. Keep the bulletin's idempotent
  change-compare working (the parked section is deterministic given its inputs).
- If the roadmap-relevance step needs any claude-assist, gate/cache it heavily like the rest of
  the bulletin's claude usage; prefer a deterministic mapping from journal roadmap data.

## Tests & verification

- Given a fixture set of parked PRs with varied ages and roadmap positions, assert: recent +
  high-roadmap PRs rank top; ancient peripheral PRs fall off; output is capped at ~10 with a
  "showing 10 of N" note; recency-only fallback works when roadmap data is absent.
  `shellcheck`/`bash -n` clean. Redeploy `garden-bulletin.service` and confirm a tick renders
  the top-10 sorted section.

## Definition of done

The parked-for-maintainer-feedback section fuzzy-ranks by recency + roadmap relevance and is
capped at ~10 (with a count of the remainder), throttle/cache/degradation preserved, redeployed,
tests added — committed/pushed to `origin/main2`. Report the SHA, the scoring weights/decay, the
roadmap-relevance source used, and a sample rendering. If blocked, report diagnosis +
ready-to-apply change.

Posted by the liaison on behalf of the maintainer.
