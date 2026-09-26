**Completion report — `xs-upstream-watch-20260728-225002`** (weekly XS-upstream watch → xs2rust-endor)

**Verdict: NO-OP.** No new engine-relevant XS changes since endo's synchronized version `23b4d6b0` (moddable 8.3.1). No job posted, no garden changes, no project changes.

**Step 1 — synchronized XS/Moddable version.** The port's differential oracle is the `c/moddable` submodule on `endojs/endo-but-for-bots` branch `xs2rust-endor`; its pinned commit is **`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` = moddable 8.3.1** (verified read-only via `gh api repos/endojs/endo-but-for-bots/contents/c?ref=xs2rust-endor` → `moddable 23b4d6b0…`). Unchanged from last week.

Correction to the job spec's step 1 phrasing: **`endojs/endo` no longer contains an `xsnap` package** (verified — `packages/` listing has no `xsnap`; `contents/packages/xsnap` 404s on both `endojs/endo` and the `endo-but-for-bots` fork). The XS vendoring lives in `Agoric/agoric-sdk` `packages/xsnap/build.env`, which pins the *agoric-labs* fork (`MODDABLE_COMMIT_HASH=f6c5951fc055e4ca592b9166b9ae3cbb9cca6bf0`, `xsnap-pub 105bc686…`) — a different lineage from the port's oracle. The operative "synchronized version" for this watch remains the port's `c/moddable` pin, as in prior weeks.

**Step 2 — upstream watch (read-only).**
- `Moddable-OpenSource/moddable` `public` HEAD = `23b4d6b0…` ("version bump 8.3.1", 2026-07-07) — **byte-identical to the oracle pin** and to the last three watch dispatches (07-07, 07-14, 07-21).
- `commits?sha=public&since=2026-07-07T18:58:52Z` → **0 commits**.
- Repo `pushed_at` = `2026-07-07T21:34:45Z` — no push to *any* branch in three weeks.
- Latest release is **8.3.1** (published 2026-07-07); no newer release or tag (tag list is stale `OS22*` naming, unrelated to the 8.x release line).
- Other branches checked and dismissed: `master` @ `48ee02d8` = 8.2.3 (behind public); `XS-14.1/14.2/14.3` are 2023-vintage (`compare public...XS-14.3` → ahead_by 0, behind_by 2582); `idf-v5`/`zephyr`/`pebble`/`matter_esp32`/`mcrun` are platform branches.

**Step 3 — engine-relevant delta.** None new. The most recent XS-path commits (`df9b6909cd` fxGet prototypes in `xs.h`, `a3da68e484` private property in module namespace, both 2026-07-04/07) are ancestors of `23b4d6b0` and already inside the classified 8.0.1→8.3.1 range.

**Steps 4/5 — no post.** A projection for this range would carry the deterministic basename `project-xs-changes-to-endor-23b4d6b0`, which already exists (completed, `jobs/tada/`), as does its follow-up `port-endor-oracle-bump-8-3-1` — so posting would duplicate. Inbox drained (empty). Read-only on Moddable upstream and endo throughout; no upstream PRs or comments; nothing written to any project repo.

**Follow-ups.** Next week: re-compare `public` HEAD against `23b4d6b0` and key any new projection by the newer sha. The deferred port items (disposal protocol, immutable ArrayBuffer/DataView/Atomics, `Array.from`/`fromAsync` mapFn guard, private property in module namespace, trim fast path) stay tracked in the port's `rust/engine/README.md` delta table and land with the VM stages that reach them — no watch action. Worth noting for a future dispatch: if the port ever needs to track what *xsnap* actually runs, that is the agoric-labs fork pin above, not `Moddable-OpenSource/moddable` `public`; the two have diverged and only the latter is currently watched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/xs-upstream-watch-20260728-225002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 23 tokens (559218 cached reads)
- Output: 7828 tokens
- Cost: $0.894613
- Wall-clock: 118s

<!-- garden-usage-end -->
