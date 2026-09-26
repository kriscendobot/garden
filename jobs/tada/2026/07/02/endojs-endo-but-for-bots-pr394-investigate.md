Fix pushed and confirmed on the remote branch. Work complete.

---

## Completion report: investigator on PR #394 (Node-20 panic CI crash)

**Verdict: the prior diagnosis was wrong. The failure is a toolchain/Node-version incompatibility, not a panic-test bug — and it is fully diagnosed and fixed.**

### What I found (verified, not guessed)
I obtained Node 20 in-sandbox (downloaded and extracted `node-v20.18.1` to scratch — the "only Node 22 available" assumption was wrong) and reproduced the real ava@8 + emittery@2.0.0 setup:

- **The crash is systemic, not panic-specific.** The 20.x CI log shows `results.values(...).filter is not a function` at `emittery/index.js:780` under `@endo/where`, `@endo/panic`, `@endo/base64`, and others. `@endo/where#test` is just the first package to fail the turbo run.
- **Root cause:** the `dev` catalog pins `ava: ^8.0.1` → **emittery@2.0.0**, whose `emit` calls `Iterator.prototype.filter/map/toArray` — helpers absent on Node 20. ava@8 `engines.node` is `^22.20 || ^24.12 || >=26`; emittery@2 is `>=22`. The `.filter` call is **unconditional** (independent of any listener rejecting), so any ava run aborts on Node 20.
- **Not the 4 added panic tests.** On Node v20.18.1 the panic test crashes identically for *both* this branch and `master` (which lacks the added tests). On Node v22.23.1 the branch's panic suite passes **5/5**. Running each added test body in isolation passes on both Node 20 and 22. `packages/panic/index.js` is byte-identical to master. This is exactly why a plain fixer re-poisoned 5× — guarding a panic test can't green a lane where every ava package crashes.
- **master already fixed this the right way:** its `test`/`cover` matrices are `[22.x, 24.x]` (Node 20 dropped) and CI is green. This branch's `ci.yml` predates that change.

### What I changed
Commit `4714a4a26` on `design/gateway-package-phase-6` (pushed): dropped `20.x` from the two ava-running matrices in `.github/workflows/ci.yml`, aligning with master.
- `test`: `[20.x, 22.x, 24.x]` → `[22.x, 24.x]`
- `cover`: `[20.x, 24.x]` → `[24.x]`
- Left `test262 (20.x)` and `viable-release (20.x)` on Node 20 (they don't run ava and already passed).
- Validated the file parses as YAML; confirmed resulting matrices.

Posted a summary comment on #394 (`#issuecomment-4864602048`) with the full root cause and verification (standing comment auth for `endojs/endo-but-for-bots`).

### Verification status
- **Verified by real execution:** Node v22.23.1 + ava@8 → panic 5/5 pass; Node v20.18.1 → reproduces the crash on branch and master; ci.yml YAML valid with correct matrices. Confidence that CI's 20.x/cover-20.x lanes go green is high (they will no longer run).
- **Not re-tested (intentionally):** Node 20 itself — it's unsupported by the toolchain, which is the whole point.

### Follow-ups (out of scope for this job — a matrix change does NOT fix them)
The PR is **not** fully green after this commit; two independent failures remain:
1. `test (22.x)` / `test (24.x)`: `@endo/zip` — `AssertionError: null == true` in `test/zip.test.js`. A real regression on *supported* Node, unrelated to panic or Node version.
2. `lint`: reported failing on the same run.

Both are likely resolved by rebasing this branch onto `master` (it trails by ~127 commits), which would also have brought the Node-20 matrix fix for free. Recommend a rebase/weave before further gamut stages, and a separate investigation of the `@endo/zip` regression if the rebase doesn't clear it.
