Assessment complete — this dispatch is a progress observation. Nothing on the byte-array arc is unblocked for me to build: both fronts are green, fully addressed, and waiting on human re-review, and the registry follow-up stays blocked on #671.

## Press report — passable/immutable byte arrays (endojs/endo-but-for-bots, dispatch 2026-07-22)

**State of the arc: both front PRs are review-complete on our side, CI-green, with re-review formally requested from kriskowal and erights. No unblocked artifact to build this dispatch; ball is in the reviewers' court.**

**What I assessed (evidence):**
- **#503** (freezable-TypedArray emulation + byteArray brand check): OPEN, `CHANGES_REQUESTED` (kriskowal, 06-25), but both unresolved inline threads carry landed fixes (`set`→native memcopy in `c84d059`/`e4a905f2d`, banner-rule removal). erights' 07-20 question about the "read delegate" wording was answered same day by a garden job (description-only correction at head `453f6ef0d`). CI: `gh pr view 503 --json statusCheckRollup` → **15/15 SUCCESS**. Re-review requested: kriskowal, erights.
- **#475** (narrow byteArray to plain frozen Uint8Array — the mega-front): OPEN, all **13 unresolved threads have substantive landed responses**, including the two big asks: the Node+XS `@endo/ascii` benchmarks kriskowal requested (run on Node v22.23.1 and xst/Moddable 5.0.0; native transcoders won decisively, landed in `d6149e72`), and the `rankOrder.js` emulated-wrapper integer-index bug (fixed in `e5825b4eb` with runtime verification). Rebased 07-17 onto the `master-2708cac` reflection per kriskowal's 07-16 base-branch norm; head `1b1dc75ba9`. CI: `gh pr view 475 --json statusCheckRollup` → **17/17 SUCCESS**. Re-review requested: kriskowal, erights.
- **Redesign supremacy confirmed:** #475 carries the byteArray-as-frozen-Uint8Array-view shape (design #572) end to end — it touches `pass-style`, `marshal`, `bytes`, `ascii`, `captp`, `daemon`, and the test262-runner Node/XS preludes, so the CapTP-boundary passability piece is in-flight inside #475, not a missing artifact. The Proxy-emulation spike #602 remains DRAFT-for-comparison as intended (last touched 07-10).
- **Registry follow-up:** #671 is still OPEN (`CHANGES_REQUESTED`, updated 07-18), so `registry-immutable-byte-array-followup` stays parked — the unblock watcher will promote it when #671 lands. Not started, per standing instruction.
- **No live peer** is working either front (`inbox-list.sh` shows only unrelated presses); no take-the-wheel needed because the stall is on human re-review, not on us. My inbox was empty.

**What changed this dispatch:** nothing pushed — no code change was warranted; any rebase or comment would have churned a diff that reviewers were explicitly asked to re-review five days ago.

**Follow-ups:** next dispatch should check for fresh review feedback on #503/#475 first (that is the only thing that can unblock the arc), and watch for #671 landing, which arms the registry conversion automatically.
