The follow-up shepherd is posted. The weave job's deliverable is complete.

## Completion report

**Job:** weave endojs/endo-but-for-bots PR #987 (`design/endor-git-bindings-zig` → `llm`).

**What I did:**
- Rebased the PR head (was `f265f98c1`) onto `origin/llm` (`c6b70e8fd`) in an isolated per-job project worktree.
- Resolved the sole conflicting file, `designs/README.md` — three conflict hunks, all in the shared design index that many PRs append to:
  1. **"Layered on" note stack** — kept both notes in date order (llm's newer 2026-08-16 endo-claude note, then the PR's 2026-08-14 endor-git-bindings note).
  2. **Design table (dates row)** — took the PR's `endor-git-bindings` row (updated 2026-08-14) and llm's newer `ironhorse-snapshot-store-seam` row (updated 2026-08-18).
  3. **M11 design table (descriptions)** — took the PR's new `endor-git-bindings` description (libgit2/Zig cross-builds) and llm's much longer, newer `ironhorse-snapshot-store-seam` description (phases 5–10, wave 3).
- The other two commits rebased cleanly (rerere). `designs/endor-git-bindings.md` was untouched by conflicts.
- Force-pushed with a lease (`f265f98c1` → `43dc5bae3`) to the PR head branch.

**Result / verification:**
- PR #987 is now `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE` (was `dirty`/no merge ref). Head at `43dc5bae349c18b4d396554f1df066e2503cf469`.
- CI **dispatched** — 6 checks now present and running (previously `statusCheckRollup: []`). The conflict blocker is cleared exactly as the "Done when" required.
- Net PR diff still scoped to the two design markdown files.

**Follow-up:** Posted `endojs-endo-but-for-bots-pr987-shepherd-20260819` to drive the freshly-dispatched CI to green (PR is already APPROVED, review #4968601303, so green CI clears it for merge).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr987-weave-20260819.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1199528 cached reads)
- Output: 13518 tokens
- Cost: $1.4574600000000002
- Wall-clock: 207s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
