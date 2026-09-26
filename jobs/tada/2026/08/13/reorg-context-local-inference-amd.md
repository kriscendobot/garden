Inbox empty. The work is complete.

## Completion report

Split the largest main2 context document — `context/operations/local-inference-amd.md` (670 lines / ~39.7 KiB, 8 level-two sections) — into a single-topic directory tree per the [context-library](skills/context-library/SKILL.md) discipline, matching the flat sibling pattern under `context/operations/`.

**What changed (landed on `main2`, commit `7a85a3b036`, pushed `d46badb6e9..1f97b707f0`):**

- **New `context/operations/local-inference-amd/` tree**, each child opening with its own abstract:
  - `README.md` — directory index: specific abstract (what the tree covers, in query terms) + the carried-over verify-by-doing status note + a pick-by-intent routing table naming each child.
  - `host-and-rocm.md` — §0 (host, as probed) **+** §1 (ROCm/gfx1151) merged, since both are "getting the base platform working on this host" (the merge the job explicitly invited; a "which ROCm version?" query lands here unambiguously).
  - `serving-endpoint.md` — §2 (the three `/v1` serving paths, which-unit-is-serving, container GPU access).
  - `model-selection.md` — §3 (MoE-vs-dense throughput table + raising the GPU memory budget).
  - `worker-backend.md` — §4 (the `hermit` worker kind).
  - `cost-model.md` — §5 (bid-auction pricing).
  - `durability.md` — §6 (image bake + follow-ups).
  - `sources.md` — `## Sources (primary)` promoted to its own child, since the bibliography spans every sibling (chose this over folding into one child).
- **Cross-reference fixes:** the doc's internal `§ …` pointers (e.g. "§ Container GPU access", "§ 6 Durability", "§ Raising the GPU memory budget") repointed to the sibling files; relative design links deepened one level (`../../designs/` → `../../../designs/`) for the new depth; verified all targets resolve.
- **Parent index:** `context/operations/README.md` row repointed at `local-inference-amd/README.md` with an abstract accurate to the new directory entry point.
- **Old flat file deleted** via `git rm` (content preserved verbatim in the children; history preserves the file).
- Body prose migrated verbatim (a move, not a rewrite); the only authored text is the abstracts and index, which follow house style.

**Verification:** no inbound refs to the old flat path remain in `roles/`/`skills/`/`context/` (only the intended new-directory row); design link targets exist and resolve from the new depth; push succeeded via rebase-CAS.

**Follow-up (out of this main2 land's scope):** `journal/` hits are on the `journal2` branch and are append-only history (periodicals, `tada/` reports, inbox messages) that should not be rewritten. The one *live* journal pointer — `journal/paused-schedules/qwen-model-watch.md`, which tells a reader to "Read `context/operations/local-inference-amd.md`" — would benefit from a journal-side edit to point at the new directory README; that requires the journal mechanism, not a main2 commit, so it is left as a small journal-side follow-up rather than touched from this worktree.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/reorg-context-local-inference-amd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 39 tokens (1687163 cached reads)
- Output: 32146 tokens
- Cost: $2.4913954999999994
- Wall-clock: 399s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
