---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-23T20:37:40Z cleared=none -->

---
role: builder
priority: normal
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Explore a **Codex / OpenAI API-key** inference backend in minion.town

Repo: `kriscendobot/minion.town` (PRIVATE). Base: `main`. Follow the repo conventions.

Maintainer direction (kriskowal, 2026-09-23 muster): the Claude Agent SDK track
(kriscendobot/minion.town#106) is PARKED because we have no Claude API token yet; start **parallel
investigations of Codex, both subscription and API key** as inference backends for minion.town.

Prior art (read first, do not duplicate):
- **Track A, Claude CLI:** merged as kriscendobot/minion.town#87. It defines the swappable inference
  seam behind `ENDO_CLAUDE_ENABLED` and the formula-scoped confined-guest MCP projection.
- **Track B, Claude Agent SDK:** draft kriscendobot/minion.town#106 and its tada report
  (`jobs/tada/2026/09/22/build-minion-town-claude-agent-sdk-inference-20260922.md`). Pay attention
  to its gap list: token broker, inference lease, telemetry sink, real-daemon canary.
- The garden already runs Codex: the `cleric` worker kind uses the Codex CLI on a ChatGPT
  subscription (`codex login`) on the endolin hosts. Read `scripts/jobs/` for how clerics invoke
  `codex exec` and how the backend probe checks credentials.

Run under the garden skill `skills/gap-revealing-build/SKILL.md`: a **DRAFT PR that stays draft**
(via `scripts/jobs/gardening/ensure-pr.sh`), a working-but-tentative integration, and a structured
gap report. Drop into the **same seam** as the Claude backends so every backend can be compared.
Keep the confined guest's tool surface scoped to that guest by formula identifier, with Codex
built-ins (shell, file edits, network) denied or sandboxed. If Codex cannot preserve that
confinement, **stop and report** rather than building around it.

Never commit, log, or print any credential. Do not use the fleet's own subscription credentials
for end-user traffic in production. A local end-to-end demonstration is fine; say so plainly.

## This track: API key
Use an OpenAI **API key**: either the Codex CLI in API-key mode or the OpenAI Agents/Responses API with Codex-class models, whichever confines better. Compare both briefly. Answer:
- Does it work end to end for a confined guest? Tool confinement through function or MCP tools versus the CLI sandbox.
- The production path for **non-subscription service to end users**. This is the use case the Claude API token will eventually serve, so shape the token broker, inference lease, and telemetry pieces so they can be shared across providers. Say what a provider-neutral broker needs.
- Cost per typical guest turn, rate limits, and usage attribution.
- **If no OpenAI API key is available in this environment**, do not stop at "blocked". Build and test everything up to the network call with a stubbed client, state exactly which key and settings are needed, and report the gap, the way #106 did for Claude.

## Definition of done
A draft PR with the tentative backend behind a flag on the shared seam, local checks green, and a report covering the questions above, the provider-neutral broker shape, and the findings to back-fill into the Endo item-4 design. Complete the job via the normal completion path.
