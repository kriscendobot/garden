# Press report — npm-via-CAS registry proxy (tick 2026-07-27, 05:35Z)

## Assessment

All five design phases remain merged; the arc's press work is now landing the known-gap drafts. The tick's decisive new fact: **kriskowal APPROVED #862** (registry maintenance CLI) on 07-26 with no requested changes — the maintainer's promotion signal. All five gap drafts (#857, #859, #860, #862, #873) were green and MERGEABLE; no live peer held any of them (the older press inboxes are completed prior ticks). #864 (XS quiesce flake fix) remains an open green draft, unmerged, unclaimed — unchanged from the last follow-up check.

## What I did — landed PR #862 into `llm`

Verified locally on the exact merged tree first, since the repo's CI never compiles `rust/endo`:

- Built `endor` from #862 merged onto `llm` HEAD (`f6d2efbbb9`); `cargo test -p endo` **174/174 green**.
- **Real-execution evidence** (cold isolated state under `/tmp`): `endor run entry.js` for an ESM app depending on `semver: ^7.5.4` fetched `semver@7.8.5` from registry.npmjs.org, stored it content-addressed in the CAS (`28e493d4b3…`), recorded it in the registry table, and executed in XS printing the expected output (`semver reports 1.2.9`, `coerce 42.6.7`) — no npm CLI, no `node_modules`, no lockfile.
- **#862's new CLI exercised end to end**: `registry list`/`meta`/`verify` all correct; `registry refresh semver` invalidated the metadata row, after which `run --offline` correctly refused the network, an online rerun repopulated only the metadata (tarball from the CAS), and the offline replay then ran green in 19 ms — the registry-table-as-lock-file semantics working as designed.

Then un-drafted and merged: **#862 is MERGED to `llm`** as merge commit `7f8c08d74f` (bot identity, matching #276/#740 precedent). Posted a provenance comment with the evidence: https://github.com/endojs/endo-but-for-bots/pull/862#issuecomment-5087717333. Test-merged all four surviving drafts (#857, #859, #860, #873) onto the new `llm` HEAD locally — **all merge clean**, no rebase work created.

## Findings worth recording

- **Build-path gap at `llm` HEAD** (noted in the #862 comment; owned by the xs2rust arc, not duplicated here): the xsnap crate's `ses_boot.js`/`worker_bootstrap.js` inputs cannot be generated from `llm` alone — the restored generators live on PR #600 (`xs2rust-endor`, commit `03656bac9d`), and the daemon bundler fails on unexcluded `node:` externals reached via `packages/git`/`host-spawner`/`platform` (a side effect of the git-CAS arc's packages landing).
- A false alarm en route: an "invalid import" failure turned out to be my own test fixture missing `"type": "module"` — the CJS/ESM classification is faithfully Node-shaped, not a regression.

## Follow-ups for the next tick

- Four gap drafts remain (#857 peer/optional deps, #859 process shim, #860 npmrc auth, #862 ~~CLI~~ done, #873 workspace protocol) — all green, clean against the new HEAD, held draft awaiting maintainer promotion; watch for further approvals and land on the same pattern.
- #864 still open/green/unmerged; it only affects parallel-test flake.
- The bundler-generators gap rides PR #600; if that stalls, a minimal restore-the-generators PR would make `endor run` reproducible from a fresh `llm` checkout.
