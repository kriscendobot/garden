---
role: weaver
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-13T18:43:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weave endojs/endo-but-for-bots PR #943 onto live `llm`

PR #943 (`feat(ascii): add @endo/ascii`) is APPROVED by kriskowal and green,
but the conductor's merge guard blocks it: its base is the FROZEN snapshot
`llm-bfc91f5`, which is SHARED by open draft PR #888
(`registry-immutable-byte-array`). Forwarding #943 to live `llm` alone via the
conductor's unfreeze is refused while a sibling shares the frozen base
(scripts/jobs/gardening/ci-wait-merge.sh, unfreeze_base_if_frozen, exit 10).

Resolution (the guard's own first remedy — "weave the stack forward"): rebase
#943's head branch `build/endo-ascii-7bit` onto the CURRENT tip of live `llm`
and retarget the PR base to `llm`. This removes #943 from the shared frozen base
so the conductor can merge it, and leaves draft #888 undisturbed as the sole
occupant of `llm-bfc91f5`.

Context that makes this a CLEAN weave:
- Live `llm` ALREADY contains `packages/sha256` and `packages/hex` (from the
  merged #836 lineage), so #943's only real additions are the new
  `packages/ascii` and a small edit to `packages/sha256/test/_xs.js` that swaps a
  local helper for `@endo/ascii`. Most of `llm-bfc91f5`'s commits are
  patch-equivalent to what is already on `llm` and should drop out of the rebase.
- `llm` is ~286 commits ahead of the frozen snapshot; expect the only possible
  conflict at `packages/sha256/test/_xs.js` (if it moved on `llm`) and generated
  tsconfig / lockfile artifacts. Resolve honoring BOTH sides
  (skills/conflict-resolution) — never `-X ours/theirs`. Regenerate composite
  tsconfigs and yarn.lock rather than hand-merging them.

Steps:
1. Get an isolated project checkout for THIS job base
   (scripts/jobs/ensure-project-worktree.sh <this-base> endojs/endo-but-for-bots
   build/endo-ascii-7bit).
2. Rebase `build/endo-ascii-7bit` onto `origin/llm`; resolve conflicts.
3. `yarn install` if needed; re-run `generate-composite-tsconfigs.mjs --check`;
   run the @endo/ascii and @endo/sha256 local verifies (ava/tsc/eslint, and
   `yarn test:xs` for sha256) to confirm still green.
4. Force-push-with-lease to `build/endo-ascii-7bit`.
5. Retarget the PR base to `llm`:
   `gh pr edit 943 -R endojs/endo-but-for-bots --base llm`.
6. Confirm the PR is still mergeable and CI re-runs; do NOT merge (the conductor
   follow-up does that). Do NOT modify PR #888.

There is no branch protection dismissing stale reviews on `llm`, so kriskowal's
approval persists across the force-push.

ORCHESTRATION GATE: if the rebase reveals #943's premise no longer holds (e.g.
@endo/ascii already landed on `llm`, or an irreducible conflict), emit the
orchestration-failed signal so the conduct step does not fire on a broken weave,
and surface the reason.
