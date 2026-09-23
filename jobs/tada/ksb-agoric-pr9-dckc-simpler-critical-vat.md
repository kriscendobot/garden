Inbox empty. No garden-repo changes to commit (I deliberately left the prototype code unchanged — rationale below), so nothing to push to `main2`. Work complete.

---

## Completion report — `ksb-agoric-pr9-dckc-simpler-critical-vat`

**Task:** Evaluate dckc's "simpler approach" review comment on kriscendobot/agoric-sdk PR #9 (fork; in-scope) and reply on the thread; implement if clearly better-and-safe, otherwise explain the tradeoff.

**What I did**
1. Read PR #9's current mechanism (schema v3→v4 migration in `upgradeSwingset.js` + a chainID-gated `writeCriticalPromotionDirective` host hook in `launch-chain.js` + a directive kvStore key + Go audit switch) and located dckc's comment (r3538037898), anchored on **line 67** — the `kvStore.set(CRITICAL_PROMOTION_DIRECTIVE_KEY, …)` directive-write.
2. Verified the technical substance against the kernel source:
   - The current v4 step already performs dckc's proposed write — `options.critical = true; kvStore.set(`${vatID}.options`, …)` (upgradeSwingset.js:450-452).
   - That in-place poke is **sound**: `critical` lives only in the `${vatID}.options` blob and is read **fresh** at termination via `vatKeeper.getOptions().critical` (kernel.js:366 → vatKeeper.js:166-169) — no RAM cache, no derived/consensus copy; the rewrite lands before the controller is built; writing through `kernelStorage.kvStore` keeps the export-data/consensus hash consistent.
   - dckc's line-67 target is specifically the **directive-key indirection** (host writes a key two lines before the migration reads it, same kvStore), which is collapsible.
3. **Posted a threaded reply** as `kriscendobot` (discussion_r3538524116, `in_reply_to_id` = 3538037898), verified rendered intact. It: confirms the rewrite is sound and is in fact the mechanism used; agrees the directive indirection is an avoidable hop that can be collapsed into an `upgradeSwingset(kernelStorage, { promoteCriticalVatIDs })` argument; and frames the deeper question (keep the schema-version bump vs. a pure host-side one-shot) as the real tradeoff = the PR's open-question #1, laying out both sides and asking dckc which vehicle the SwingSet team prefers.

**Decision: left the code unchanged.** The suggestion isn't a *clear* better-and-safe unilateral win. Its minimal form is already what the PR does; the directive-collapse is a modest improvement but a structural refactor spanning the migration, two test blocks, and `launch-chain.js` that I cannot execute/verify here (no yarn/xsnap toolchain, matching the PR's own "tests written but not executed" status); and the maximal form (drop the schema version entirely) is a genuine design call — open-question #1 — that belongs to the SwingSet team, not to a unilateral push onto a prototype they're evaluating. Per the task's fallback branch, I explained the tradeoff in the reply instead.

**Changed:** nothing in code (fork branch and garden `main2` both untouched).

**Follow-ups**
- If dckc/SwingSet answers "one-shot," implement: move the options rewrite into `launch-chain.js`, drop the v4 step, `CURRENT_SCHEMA_VERSION` bump, directive key, and `writeCriticalPromotionDirective`; re-home idempotency on the cosmos upgrade-name once-only guard.
- If they answer "keep the migration," implement the narrower cleanup dckc flagged: pass resolved vatIDs into `upgradeSwingset` and delete the directive key + `writeCriticalPromotionDirective` round-trip (updates upgrade-swingset.test.js's two directive-based blocks).
- Either path needs a fork-CI run to exercise the tests.
