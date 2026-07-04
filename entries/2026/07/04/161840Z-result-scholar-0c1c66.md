---
kind: result
role: scholar
host: endolinbot2
at: 2026-07-04T16:18:41Z
---
---
project: garden
repo: MylesBorins/athanor
refs:
  - https://github.com/kriskowal/garden/issues/24
---

Scholar study of **MylesBorins/athanor** for issue kriskowal/garden#24 ("where it fits in the Garden and Endo"). Analysis posted as an issue comment (kriskowal/garden#24, comment 4883025983); issue left open per the ask.

**Sources ingested (3, first-pass):**
- `athanor--readme` (README.md @ `eb7b004`, 2026-05-29) — 5 sections: overview, registry-and-stable-ports, mlx-capabilities-and-flavor-routing, supervisor-and-observability, pi-agent-sync.
- `athanor--agents` (AGENTS.md @ `cd595f1`, 2026-05-24) — 2 sections: invariants (the ten load-bearing), layout-and-state.
- `athanor--context-arch-map` (context/ARCH_MAP.md @ `cd595f1`) — 1 consolidated section: architecture-map.

**Library structure written:**
- New topic `local-model-serving` (genuinely new domain: local LLM inference-runtime management; 8 sections). Filed under the "External code repositories (sibling implementations)" source shelf.
- New concept `athanor` + `keywords.md` shortcuts; cross-linked to `llm-agent-frameworks` (consumer layer) and the endopi provider-registry cluster.
- Index rows added: topics/README (local-model-serving, count 8), sources/README (3 athanor rows), concepts/README (athanor bullet), llm-agent-frameworks topic (pi-agent-sync cross-file row).

**Analysis summary:** athanor is a model-serving/provisioning layer beneath an agent harness (pi-agent / badlogic/pi-mono). Garden fit = candidate self-hosted-model backend for the fleet (adjacency, not integration; single-machine Apple Silicon; no code dependency). Endo fit = no SES/ocap lineage; the link is through pi-agent — athanor writes providers INTO pi's registry while endo-but-for-bots' `endopi` provider-registry-and-oauth design re-implements pi's registry SHAPE under least authority. Cousins pointing at the same reference implementation from opposite ends.

**Integrity gate:** `library-link-check --source-slug` passed for all three athanor clusters + `--nav` (exit 0); `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` re-landed (sections index + topics counts current).

**Follow-ups recommended (not posted as jobs):** (1) a model-selection↔athanor-endpoint spike if self-hosting is wanted; (2) ingest pi-mono provider-registry docs to seat the athanor↔endopi comparison; (3) track athanor as a second point in the pi ecosystem endopi already references. No deferred backlog — the three core docs are the faithful first pass; deeper source-code ingest is optional, not queued.

Self-improvement: The live `/home/kris/journal` worktree's git dir was severed mid-job ("not a git repository: .../garden2/.git/worktrees/journal") — the known journal-worktree-severed symptom. Worked around cleanly by reading tips through the producer clone (`$GARDEN_STATE/producer/journal`) instead; landing was unaffected since land-journal-edit uses the producer clone by design. No role/skill change warranted; the existing keeper/repair path owns the fix.
