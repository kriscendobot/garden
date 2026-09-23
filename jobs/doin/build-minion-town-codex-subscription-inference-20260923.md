---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-23T20:37:07Z cleared=none -->

---
role: builder
priority: normal
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Explore a **Codex on ChatGPT subscription** inference backend in minion.town

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

## This track: subscription
Use the Codex CLI (`codex exec`, non-interactive) authenticated by a ChatGPT subscription login. Answer:
- Does it work end to end for a confined guest? What confinement does the CLI actually give (sandbox modes, approval policy, MCP config)?
- Terms and policy: can a subscription credential legitimately serve end users, or only the operator? Cite the current OpenAI terms and flag any doubt; do not assume.
- How would per-user subscriptions work (each end user brings their own ChatGPT login via device auth or OAuth) compared with one operator subscription? What would the broker look like?
- Quota and rate-limit behavior, how usage is attributed, and how it compares with the Claude CLI track.

## Definition of done
A draft PR with the tentative backend behind a flag on the shared seam, local checks green, and a report covering the questions above plus the findings to back-fill into the Endo item-4 design. Complete the job via the normal completion path.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-23T21:13:05Z -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-23T21:13:19Z
