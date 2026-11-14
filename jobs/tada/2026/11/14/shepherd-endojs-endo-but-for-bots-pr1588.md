## Shepherd report — endojs/endo-but-for-bots PR #1588 (M3 endo-fetch confined-plugin split)

**Diagnosis (stall root cause).** The gauntlet had been stuck at the FIX stage for 3 iterations. Every CI attempt went red on the same blocker: a `TS2883` declaration-emit error in `packages/exo-http-client/src/http-client.js` at lines 330/720/969 — the three exported factories `makeTrustOnFirstBindPolicyAdapter`, `makeHttpClientAndControl`, `makeHttpClientKit`. Their `delay` parameter is typed `Delay`, which `exo-http-client/src/types.ts` obtained via a transparent re-export (`export type { Delay } from '@endo/http-confine'`). That re-export resolves back to `@endo/http-confine/src/types.js` — a path no package export names — so `tsc` refused to emit portable declarations. This was a direct fallout of the fetch/confined-fetch split moving `Delay` into `@endo/http-confine`. The failure manifested identically in three red checks: `lint`, `viable-release (22.x)`, `viable-release (24.x)`.

**Clearance.** The fix is to declare `Delay` as a genuine local type alias in `exo-http-client` (a self-contained 3-line function type) instead of a re-export, so declaration emit can name it via the portable `./types.js` specifier. I reproduced the failure locally (`tsc --build tsconfig.build.json` → TS2883) and confirmed the local-declaration fix clears it (build exit 0, `lint:types`/eslint/prettier all clean).

A concurrent gauntlet `fix-3` worker independently derived and pushed the **identical** fix while I was verifying (commits `7d34a420e0` "keep a local Delay declaration so declarations emit" + changeset `7ea9ab3c58`). My redundant local change was therefore discarded; the correct fix is already on the PR head `7ea9ab3c58`.

**Verification.** On the fixed head, the three previously-red checks are now **green**: `lint` ✅, `viable-release (22.x)` ✅, `viable-release (24.x)` ✅. At report time: 22 checks passing, **0 failing**, 4 `test` matrix legs still `in_progress` (the normal long monorepo suite, running 19–37 min, never the blocker and showing no failures).

**Gauntlet.** The stall is cleared. Gauntlet resumption is automatic: the `fix-3` handler that pushed the fix runs its own `ci-wait-merge` and will emit `fix=done` on full green, advancing the driver to panel-4. No manual resume needed from this job.

**Changes:** none committed by me (fix already landed by the peer worker). **Follow-ups:** none — the remaining test matrix is healthy; if any leg flakes, the gauntlet's own CI watcher handles the retry.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1588.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 154 tokens (9165505 cached reads)
- Output: 58792 tokens
- Cost: $7.6523924999999995 (2 engagement(s) unpriced)
- Wall-clock: 8287s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
