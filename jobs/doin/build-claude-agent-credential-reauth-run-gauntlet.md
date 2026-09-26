---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-26T05:41:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Run the gauntlet on the credential-reauth build PR(s) (kriscendobot/minion.town)

Maintainer-requested gauntlet: kriskowal's review
https://github.com/kriscendobot/minion.town/pull/96#pullrequestreview-5324704742
said "dispatch a builder, with gauntlet". This is the explicit *run the gauntlet*
act for the build `build-claude-agent-credential-reauth` (manual-gauntlet-trigger
regime; the builder itself must not post it).

Find the draft PR(s) that build opened in kriscendobot/minion.town (its tada
report in journal/jobs/tada/, or the `<!-- garden-job: build-claude-agent-credential-reauth -->`
marker in the PR body). For each PR N, run:

  scripts/jobs/post-gauntlet.sh --build-job build-claude-agent-credential-reauth \
    kriscendobot-minion.town-pr<N>-gauntlet https://github.com/kriscendobot/minion.town/pull/<N>

For a stacked series, gauntlet the slices in stack order (orchestrate serially
per skills/orchestration if more than one). If the build produced no PR, report
that and message the maintainer instead.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-26T05:41:34Z
