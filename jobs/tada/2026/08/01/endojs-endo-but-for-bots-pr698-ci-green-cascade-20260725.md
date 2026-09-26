Job complete.

## Report: cascade child — PR #698 (bridge cut 1)

**Live state re-verified first.** PR #698 (`build/sturdyref-bridge-1-bytes-wire-read` → `build/sturdyrefs-endor-syscall-retention`) is OPEN, DRAFT, `MERGEABLE`/`CLEAN`, head `c19fdd96cc8157a8f34587ccb9ee698489a0baba`.

**1. Rebase (weaver): no-op, nothing pushed.** #698's head already sits directly on #541's *current* head `fd60a74b0b6a706acbab2baa364e855e5dc8eb5e` — `git merge-base --is-ancestor` returns YES and `698..541` is empty. An earlier run of this same cascade (2026-07-25T05:29, before the job was parked and re-promoted 2026-08-01) had already done the rebase, and the predecessor has not moved since. The #737 child's stack-wide fixes are all in ancestry: `8db9355a2` (ocapn composite tsconfig), `0b62d25a1` (actions/checkout → v6.0.2, the zizmor `stale-action-refs` repin), `fd60a74b0` (daemon composite tsconfig). Arbitrated shapes intact — `@endo/sturdyref` shim home, `getSturdyRefLocator` (`packages/ocapn/src/client/sturdyrefs.js:40`), camelCase `'sturdyRef'` discriminator (`packages/pass-style/src/sturdyref.js:21`). The marshal `l` prefix belongs to cut 2 (#700) and has no surface in this cut's diff. No force-push was needed or made; draft preserved.

**2. CI (shepherd): green, `next: none`.** All 24 checks pass on the head SHA — including `test`/`cover` on 22.x and 24.x across ubuntu and macos, `lint`, `zizmor`, `check-action-pins`. Run 30145846142, `conclusion: success`, `head_sha` matches the current head. The real test failures the job flagged for "#700 and above" do not appear here, so nothing was passed downstream.

**3. Confinement suites (load-bearing): all green, re-run locally rather than inferred from the aggregate CI check.**
- `packages/ocapn/test/codecs/passable.test.js` — 85 tests × 3 ses-ava configs (lockdown/unsafe/endo), including this PR's own `sturdyRef with non-ASCII byte secret` case, whose prototype-chain byte-sweep asserts the 24-byte secret unreachable with a non-vacuity guard.
- `packages/sturdyref/test/` — 8 tests, incl. *no location: leaks no locator*, *no identification: same locator mints distinct sturdyrefs*, *withheld: a child compartment does not see the SturdyRef global*.
- `packages/daemon/test/sturdyref-resolution.test.js` — 10 tests, incl. all four `confinement:` cases.
- `packages/pass-style/test/sturdyref.test.js` — 10 × 2 configs (opaque, stringifies via tag only, forgery rejected).
- `packages/ocapn/test/sturdyref.test.js` — 7 tests.

All four properties hold: a confined guest cannot read a locator, cannot correlate two tokens of the same locator, gets no URI via `toString`, and sees zero own properties.

**Artifacts.** Evidence comment with command + output posted (repo standing authorization covers it): https://github.com/endojs/endo-but-for-bots/pull/698#issuecomment-5150928820. Journal result entry `entries/2026/08/01/095918Z-result-gardener-a19701.md`.

**Follow-ups.** None for #698 — it is ready for the #700 child to cascade on top. Note for whoever runs that child: #700's own checks were also all passing at the time I looked, so its pre-cascade test failures appear to have already cleared. No garden-library changes were needed, so nothing was committed to `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr698-ci-green-cascade-20260725.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1832477 cached reads)
- Output: 19700 tokens
- Cost: $2.1922695000000005
- Wall-clock: 346s

<!-- garden-usage-end -->
