---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Automatic production validation for Claude-on-minion.town arc items 1 and 5

Arc https://github.com/kriscendobot/garden/issues/89 has two checked items, but neither has an
automatic production validation. Under the maintainer's 2026-10-07 standing order, an objective
counts as done only while it is validated automatically in production.

- **Item 1, harness installed with an upgrade policy:** the deployed host carries the Claude
  Code harness at the pinned version recorded in the repo (and its signed manifest, if
  https://github.com/kriscendobot/minion.town/pull/122 has landed).
- **Item 5, a stdio MCP scoped to one guest:** the connect-time confinement probe
  (`src/endo/claude/wiring.ts` `runConfinementProbe`) passes: a positive `writeText` through the
  probe guest's stdio MCP, verified from the guest's store, plus the negative probe.

Extend the scheduled, deterministic, no-LLM production probe that
https://github.com/kriscendobot/minion.town/pull/166 adds (`deploy/probe/prod-objectives.mjs`,
`.github/workflows/prod-probe.yml`). Do not build a second probe framework. If #166 has not
merged, stack on its head branch `feat/prod-objectives-probe` and say so in the PR body.

- Add one named check per item. Item 1 can likely run through the existing deploy-time AWS/SSM
  access. Pick the least-privileged route that works and document it.
- Item 5 needs a root (kriscendobot) MCP session, which the fleet does not have yet. Root-canary
  principal design https://github.com/kriscendobot/minion.town/pull/167 is waiting on maintainer
  answers. Wire the check so that it reports `skipped: no root canary credential` until that
  credential exists, and make it take that credential's environment variable once
  defined. Do not invent a credential channel.
- Run it against production and post the evidence in the PR. Open a DRAFT PR on
  kriscendobot/minion.town through ensure-pr.sh. The gauntlet follows automatically.

Do not edit the arc issue body. The press updates it.
