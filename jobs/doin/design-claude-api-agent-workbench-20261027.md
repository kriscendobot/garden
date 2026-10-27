---
role: designer
arc: minion-town-claude-api
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: the agent workbench on minion.town (chat clip, budgeted subagent spawner, git VFS tools)

Arc tracker: https://github.com/kriscendobot/minion.town/issues/227 (read it fresh; post your result there and add review asks to its table).
Foundation (read first, do not re-design): the API-key providers and pinned agents design, https://github.com/endojs/endo-but-for-bots/pull/1543 (`designs/api-key-inference-providers-and-pinned-agents.md`, its build phases 1-7 are in flight).

## The maintainer's scenario (kriskowal, 2026-10-27)

A guest creates an account, adds their Claude API key, creates an agent bound to that inference provider with endowments chosen from their inventory, and converses with it. Then:
1. The endowments may include a **token-budgeted subagent spawner**: agents create subagents ad nauseam, distributing their token budget and endowments among them, converse with them, and manage the **control facet** of each delegation (revoke, resize budget, pause).
2. Agents work in the **git virtual file system** using edit-with-hashline, grep, glob, glorp, and the rest of the tools the garden has been building, so this is a viable working environment.
3. All of that presumes a **chat conversation surface integrated as a Clip**.

## Your job: maximize reuse of designs already planned

Do NOT invent parallel mechanisms. Inventory what exists and compose it. Start with these (endojs/endo-but-for-bots, branch `llm`, `designs/`; check `designs/README.md` for the ranked roadmap and milestones, and say where each piece falls on it):
- Chat and weblet hosting: `familiar-chat-weblet-hosting.md`, `chat-components.md`, `chat-invariants.md`, `chat-inventory-create-menu.md`, `chat-slot-slash-commands.md`, `chat-pending-commands.md`, `daemon-weblet-application.md`, `weblet-next.md`; and garden `designs/minion-town-clip-gutter-plan.md`, `designs/clip-multiasset-and-art-generation.md` for the Clip side.
- Agents, lal/fae, transcripts: `lal-fae-form-provisioning.md`, `lal-reply-chain-transcripts.md`, `lal-transcript-memory-management.md`, `agentry-agent-builder.md`, `daemon-guest-bot-incarnation.md`, `agent-confined-application-makers.md`, `floot-daemon-owned-turns.md` (Floot's subagents are the nearest existing spawner idea), `hosted-agent-broker-oauth.md`, `hosted-agent-sandbox-unification.md`, `daemon-agent-network-identity.md`.
- Tools and VFS: `agent-tools-mount-fs-tools.md`, `daemon-agent-tools.md`, `endo-agent-tools.md`, `endopi-edit-tool.md` (hashline), `mount-stream-glob-grep.md`, `daemon-capability-filesystem.md`, `daemon-git-capability.md`, `daemon-git-next-steps.md`, `endo-fs-from-git.md`, `agentry-git-eval-scenarios.md`, `agentry-git-verb-gaps.md`, `agent-follow-stream-tool.md`; and garden `designs/minion-town-git-remote-plan.md`, `designs/cloudflare-artifacts-endo-vfs.md`. "Glorp" is not a name this brief can resolve: find what the maintainer means in the repo, designs and journal, and if it truly does not exist say so and ask the maintainer on the tracker rather than guess.
- Budgets: the provider spend-cap and per-agent accounting in the #1543 design (its caps, abuse controls, accounting phase). The spawner's token budget must be a real attenuation of that accounting, not a second ledger.

## Deliverable

A design (Endo-side parts in endo-but-for-bots `designs/` on its normal review path, minion.town-side parts in that repo or as a section, whichever the existing convention says) that:
- states which existing design supplies each capability and what small delta each needs, in a table;
- specifies the budgeted spawner and the delegation control facet (confinement: a child can never exceed the parent's endowments or remaining budget; revocation cascades; no key material ever reaches a child; recursion depth and fan-out limits as abuse controls);
- specifies how the chat Clip talks to a pinned agent (turn flow, streaming, sandbox constraints from the clip recipe);
- specifies the VFS tool endowment bundle given to an agent and its confinement;
- ends in builder-sized phases that slot after #1543's phase 5, with acceptance tests including a live end-to-end run of the scenario above using the dedicated canary key;
- lists unresolved maintainer questions explicitly (use the review-PR path for them).
Design only: do not implement. Do not touch the in-flight #1543 phases.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T04:37:07Z
