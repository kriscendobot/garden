CI is green (rc 0, 28/28 checks, 0 failed) on the fix head. The job is complete.

## Completion report

**Gauntlet FIX round 2 — endojs/endo-but-for-bots PR #1124** — applied panel round-2 must-fix items, pushed as review-feedback follow-up commit `54da570a9`, CI terminal **GREEN** (28/28 checks, 0 failed).

**Blocking findings addressed:**
1. **Pipelining bypass** — the session locator now **serializes** its lookups (each presentation's miss settles before the next begins), so a pipelined burst of `fetch` frames can no longer clear the gate before the first miss resolves. The bound counts every settled miss.
2. **Overstated crossing indistinguishability** — dropped the false claim that the bound-crossing miss flushes a byte-identical uniform rejection (engine-dependent turn-counting). Reworded the ocapn `abortSession` comment, the module doc, and the PR body to the honest property: every presentation *below* the bound is uniform; the crossing severance is observable but discloses only that the bound was exceeded.
3. **Forged `NodeNumber` cast** — typed `localNodeNumber` as `NodeNumber`, dropped the unchecked brand cast.
4. **Narrow return type** — exported a named `FormulaNonceLocator` typedef whose `get` is `(string | Uint8Array) => Promise<unknown>`.
5. **`EndoMountControl` not re-exported** — added to the daemon `types.d.ts` import + export lists.
6. **Bare `catch {}`** — now logs the failing stage via an injected `logger` (defaults to `console`) so an internal defect isn't swallowed.
7. **Stale `spell-out-exempt: swissNum` marker** — deleted (the term is absent from the file).
8. **Unpinned crossing behavior** — added an over-the-wire assertion that below-bound misses share one uniform rejection.
9. **Design reconciliation** — added a "Related designs (seam)" section to the PR body reconciling with #1013 (relative routing) and #1116 (guest-native invitation), stating why the locator seam is orthogonal.

**Should-fixes also applied:** reject NaN/negative/non-integer `missBound` at construction; narrowed the `string | Uint8Array` union up front (dropped both `get`-body casts); fixed the inert `/// <ref …>` directive; qualified the `remoteDesignator` doc (authenticated only under `verifyPeerLocation`); corrected the README `locator` example.

**Verification:** `lint:types` (daemon + ocapn) rc 0, eslint on changed files 0 errors, all 11 locator tests pass. Both `@endo/daemon` and `@endo/ocapn` type-check and lint clean.

**Note:** No panel re-run (per stage contract — the driver re-posts panel-3). The `sturdyref`/`ocapnPassStyleOf` should-fix was left for a follow-up as it requires a new `@endo/ocapn` package export path; noted but out of scope for this round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-nonce-locator-endo-mechanism-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 166 tokens (7899333 cached reads)
- Output: 51204 tokens
- Cost: $7.526100750000001
- Wall-clock: 1114s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
