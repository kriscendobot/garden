Done. Final state confirmed and escalation surfaced. Writing my report.

---

## Shepherd report — endojs/endo-but-for-bots#1327 (hashline edit phase 2, DRAFT)

**Live check re-fetch** found three reds: `lint`, `test (24.x, ubuntu-latest)`, `test (24.x, macos-15)`. PR is `MERGEABLE` (not conflicting).

**Fixed inline (real, pushed, verified green):**
- `lint` was a Prettier formatting red — an unwrapped `path.join(...)` call in `packages/daemon/test/endo.test.js` (introduced by the PR's own feat commit). Ran `prettier --write`, authored it as `fixup! feat(daemon): hashline edit phase 2…` (commit `561ab6f66`) per the retconned-PR fixup convention, and pushed to the head branch `kriscendobot/endo-but-for-bots:ebfb-pr256-hashline-phase2` with `--force-with-lease`. (Caught and reverted a stray `packages/hex-test/package.json` churn from the install before committing.)
- Re-run confirms **lint, node-20, node-22, and every other leg are now GREEN**; the only remaining reds are the two Node-24 test legs.

**Escalated (out of shepherd scope) — `next: weaver`:**
- The two `test (24.x, *)` failures are **base-staleness, not this PR's diff**. The diff touches only `packages/daemon/*`; the failing tests are in the **untouched** `packages/cli` (`counter-example.js` → `endo restart` → "Daemon failed to spawn … exited null"). This is the `better-sqlite3@11` Node-24 teardown abort (`Assertion (env) != nullptr` in `RemoveEnvironmentCleanupHook`).
- llm already fixed it in `725a6b1911` (bump `better-sqlite3` → ^12) and `427952c23f` (unpin Node 24). The PR's **frozen base `llm-c36b4249`** predates both (~3977 commits behind llm), so it inherits the crash; **llm HEAD passes node-24**.
- Correct fix is a **frozen-base repin** past `725a6b1911` — a weaver "pin the merge base" op. I did **not** cherry-pick the sqlite bump onto the head because it would pollute the deliberately-minimal Phase-2 review diff (dep change + lockfile regen on a stale base) and the snapshot choice intersects the design's Phase-1/Phase-2 phasing (a reconstruction, not a mechanical rebase). Flagged to the maintainer via `message-user` rather than auto-posting the repin, since the base-snapshot choice needs a deliberate decision and the PR is a **non-blocking draft** (repin should precede "run the gauntlet").

**Follow-up:** weaver base-repin of #1327 past `725a6b1911`, before the PR is promoted to a gauntlet. Surfaced to the maintainer (inbox delivered).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1327-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2253827 cached reads)
- Output: 27472 tokens
- Cost: $3.072421500000001
- Wall-clock: 1945s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
