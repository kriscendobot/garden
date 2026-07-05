Garden's own repo (kriskowal/garden, main2): fix the reaper data-corruption bug where a job is requeued (~every 18 min against a 40-min handler wall) while the prior handler is left alive, producing two live writers in one worktree. Make the reaper either kill or wait for the live handler before requeue. Build in an isolated worktree off origin/main2. High priority — data-corruption class.

---
claim:
  host: endolinbot
  gardener: 18
  claimed_at: 2026-07-05T20:49:14Z
