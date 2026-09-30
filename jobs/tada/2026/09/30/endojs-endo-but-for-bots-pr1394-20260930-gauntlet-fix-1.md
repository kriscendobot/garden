PR #1394 round-1 fix: I applied the panel's two should-fix items and pushed them. CI was still running when the 1-hour limit ran out (`ci-wait-merge` rc 4), so this stage ends as still-pending.

**What I pushed** to `build/sturdyref-captp-wire` (`c2d1f93e5` → `9a9aa310f`, via `safe-push-pr-head.sh --mode advance`):

1. **`47735f3e3` fix(ocapn): keep the enliven-binding SturdyRef mint internal.** Before this, the public `makeSturdyRef` from `@endo/ocapn` accepted a custom enliven function. A caller could record `(location, secret)` for the wire codec while enlivening locally to something else (breaker attacks 1 and 2).
   - The 3-argument mint is now the internal `makeBoundSturdyRef`, used only by the client's `makeSturdyRefTracker`.
   - The public `makeSturdyRef(location, secret)` binds no client, so enlivening it rejects. This is the "leave no custom enliven" option the breaker offered.
   - New test: passing a decoy enliven to the public mint has no effect, and the recorded details stay `(location, secret)`.
2. **`9a9aa310f` fix(captp): allocate and import SturdyRef slots outside the tables.** The `s` slot kind existed only in the default import/export tables. With custom tables, a SturdyRef went out as an `o+` slot and the peer got a Remotable presence instead.
   - `convertValToSlot` now allocates `s+N` next to the `t+` trap slots.
   - `convertSlotToVal` builds the imported SturdyRef itself (`makeSturdyRefForSlot`), so custom tables never see the `s` kind.
   - The default tables are back to handling only `o`, `p` and `t`.
   - New test: a SturdyRef crosses CapTP through tables that only know `o` and `p`, arrives with pass style `sturdyRef`, and enlivens at its origin.

**Local checks:** captp 43/43 tests pass, ocapn 562/562 pass, and lint (including types) has 0 errors in both packages.

**CI:** at the deadline, 32 of 33 checks were done, and every finished check passed or was skipped. The only one still running was `test (24.x, macos-15)`.

**Not fixed:** the breaker's comment-only item. Nothing yet rejects a slot whose kind prefix doesn't match the marshal encoding that decoded it, such as an `s+N` slot sent as a remotable. The breaker rated the damage as limited to type confusion, since `passStyleOf` still reports the true kind. Adding a check and a test for it is a possible follow-up.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2376765 cached reads)
- Output: 14610 tokens
- Cost: $1.3539370000000002
- Wall-clock: 5041s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
