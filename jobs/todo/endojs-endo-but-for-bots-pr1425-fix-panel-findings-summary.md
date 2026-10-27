---
role: fixer
tier: mentor
arc: endo-ocapn-background
posted_at: 2026-10-27T17:44:07Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-27T17:50:08Z cleared=none -->

---
role: fixer
arc: endo-ocapn-background
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Post the fixer's top-level summary comment on draft https://github.com/endojs/endo-but-for-bots/pull/1425 for the round-6 panel findings (review submitted 2026-10-08T15:33:28Z). Write it per skills/pr-completion-summary-comment, citing the current head SHA and the CI status, which the preceding shepherd child should have made green. The comment must cover:

- **packager must-fix (unrelated CI commit):** isolated. The PR base is now `fix/zizmor-paths-filter-pin-comment`, the head of https://github.com/endojs/endo-but-for-bots/pull/1427, so `1b1ead43c8` is no longer in this PR's diff and zizmor still passes. Once #1427 lands, retarget the PR to `master-6ee3fda`. The PR body already says this.
- **purist should-fix 1 (the hook hands out the intrinsics record):** fixed in `c72a8f3564`. `repairIntrinsics(options, onShimStartCompartment)` now builds `freeze(makeCompartmentConstructor(makeCompartmentConstructor, intrinsics, markVirtualizedNativeFunction))`, marks it, and passes only that constructor. The callback never sees the intrinsics or the marker. Reusing `globalThis.Compartment` is still declined for the reason given in round 6: it has `enforceNew`, and `adaptCompartmentConstructors` calls the shim constructor as a function.
- **purist 2 (family consistency):** frozen and marked (since `2fa058354a`, now inside lockdown.js). It deliberately lacks `enforceNew`.
- **packager should-fix (changeset):** the hook is internal. `src/lockdown.js` is not exported, and the global `lockdown`/`repairIntrinsics` don't forward it, so `patch` stands.
- **purist 4 (added-global assertion):** already in `test/_xs.js` (`addedBeforeLockdown`).

Also check https://github.com/endojs/endo-but-for-bots/pull/1425 for inline threads that need replies. Do not re-request review from the bot itself. The PR stays draft.

