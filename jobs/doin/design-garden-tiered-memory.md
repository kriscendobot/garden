---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: a two-tier, fleet-coordinated garden memory

Maintainer decision (kriskowal, liaison session 2026-10-17): memories the liaison keeps must be capturable **in the garden** so the fleet and every host can coordinate on them, with **tiers** so nothing sensitive is published. Today the liaison's memory lives in `.claude/projects/-home-kris-garden/memory/` (gitignored, host-local, ~82 one-fact files plus a `MEMORY.md` index; frontmatter `name`, `description`, `metadata.type` of user|feedback|project|reference). The garden repo `kriscendobot/garden` is PUBLIC and `journal2` is pushed to the same origin, so anything put in the journal is published.

Design (spec only, in `designs/`; apply the carve-out in CLAUDE.md § Conventions if it carries open questions):
1. **Tiers.** A shared tier: a `memory/` tree on `journal2`, one fact per file in the same frontmatter shape plus `shareable: true|false`, a README index per skills/context-library discipline. A private tier stays host-local. Default is private; sharing is an explicit act.
2. **Write path.** One script is the only way the liaison saves a shared memory; it refuses unmarked files and scans for secret-shaped content (tokens, keys, account ids, private-matter markers) before any push.
3. **Read path.** How gardeners and the liaison on every host load the shared index at claim time (cost-bounded; think the MEMORY.md one-line-per-fact index), how conflicts between hosts resolve, how stale or wrong memories are retired.
4. **Roles and docs.** What changes in roles/liaison/AGENT.md, roles/COMMON.md, and CLAUDE.md so the liaison and workers follow it.
5. **Migration plan** for the existing ~82 memories: propose a classification rubric and classify each as shareable / private / needs-maintainer-decision, with a one-line reason. Do NOT copy or push any memory yet; deliver the classification table to the maintainer inbox for veto. Memories about credentials, AWS account facts, registrar or DNS matters, subscription and quota internals, and identity details default to private.
6. **First shared entry candidate** (safe): the ruling that bearer tokens are coherent with object capabilities; the test is whether the token designates a specific object or an identity (memory `bearer-tokens-vs-ocaps`).

Also decide whether the shared tier should be a private repo instead if the secret-scan cannot be made trustworthy, and list that as an open question if unsettled.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T08:04:07Z
