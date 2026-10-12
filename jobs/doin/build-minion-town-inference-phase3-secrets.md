---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: item 4 phase 3 on minion.town — Claude credentials onto `@secrets`

Arc: https://github.com/kriscendobot/garden/issues/89 (item 4). Design: `designs/endo-claude-inference-backends.md` on endojs/endo-but-for-bots `llm`, § Phased Implementation, phase 3. Phases 1 and 2 landed: endojs/endo-but-for-bots#1403 and #1412 (merged 2026-10-12 21:51Z; `llm` at `204033b398`).

Repo: kriscendobot/minion.town, base `main`. Review is inverted for minion.town (maintainer standing order 2026-10-07): carry the PR through the gauntlet yourself; no maintainer review ask.

1. Bump minion.town's synchronized Endo pin copies to an `llm` commit at or after `204033b398`. Verify the bump against a real daemon built from that pin before relying on it; a blind re-pin crash-looped prod once (see the #104/#110 history on the arc).
2. Move minion.town's Claude credential store and `setup-token` capture onto the daemon's `@secrets` (`@secrets/create` root-side), per phase 3 and the design's credential decisions. Consume `@endo/inference` / `@endo/claude` from the pin where minion.town currently carries its own copy, and drop the duplicate where that is safe.
3. Wrap the root user's backend in the prompt-origin gate so it serves root-authored prompts only. Keep it dark behind `ENDO_CLAUDE_ENABLED`; do not enable production traffic.
4. Do NOT run the root canary or gate 1. The parked `minion-town-claude-kriscendobot-canary-after-connect-20261006` owns that and waits on the maintainer's "connected" reply.

Open a DRAFT PR; successful completion stages the gauntlet. CI must be green.

<!-- garden-terminal-handler-failure -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-12T22:23:47Z
