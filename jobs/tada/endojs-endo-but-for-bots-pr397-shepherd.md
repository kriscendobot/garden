## Diagnosis complete — escalating

I re-fetched live state and traced every failing check to root cause. No fix is pushed: the failures are **not** in this PR's own diff, and the correct remedy is a decision that spans the whole stack.

### What I found

PR #397 (DRAFT, `design/gateway-package-phase-9`, head `32c2f742`, untouched since 2026-06-03) is phase 9 of the 9-PR gateway stack (#343→#388→…→#396→**#397**). Its own diff touches **only `packages/gateway/*`** — none of those files is broken.

Failing checks and their causes:

| Check(s) | Cause |
|---|---|
| `lint` (1 error) | `packages/ocapn/test/netlayer-tcp-syrup.test.js:7` imports `makeClient` from `../src/client/index.js`, which at this head exports `makeOcapn` instead — a mid-refactor `makeClient`→`makeOcapn` breakage in **`@endo/ocapn`** |
| `test` (all 6 matrices), `cover` (20.x, 24.x) | Same breakage: `@endo/ocapn#test` exits 1 (`command failed in workspace @endo/ocapn`) |
| `test-xs` | Separate transient infra flake: *"Error installing XS or V8: exit code 1"* during toolchain install — class-A operational, not code |

**Key evidence this is inherited, not introduced:**
- The base branch #396 (`design/gateway-package-phase-8`) shows the **identical** failing-check set (lint, all test matrices, cover 20/24, test-xs) — the breakage lives throughout the stack, below #397.
- On **current master**, `packages/ocapn/src/client/index.js` exports `makeClient` and the test passes — master already fixed this.
- The branch is **192 commits behind master** (1142 ahead). It branched off a stale master state where ocapn was mid-refactor.

### Why the shepherd does not push here

The substantive remedy is a **coordinated bottom-up restack of the entire gateway chain (#343→…→#397) onto current master**, which clears the inherited ocapn breakage for free. That is beyond a per-PR shepherd push:
- Patching ocapn on #397's head alone would be scope creep (a package unrelated to the PR), would duplicate a fix that already exists on master, would diverge from the maintainer's explicit "restacking discipline," and would leave the 8 PRs below still red.
- No comment authorization is present in the job body, so I did not post to the PR.

### Escalation

**`next: liaison`** — a deeper-than-fixer, stack-wide decision. The whole gateway phase stack is a month stale and 192 commits behind master; its shared base carries an `@endo/ocapn` `makeClient`→`makeOcapn` breakage that master has already resolved. The maintainer (or a weaver sweep the maintainer authorizes) should restack the chain onto current master bottom-up, rather than patch the top PR. `test-xs` is a separate transient XS-install flake that a re-run after the restack will likely clear on its own.

Follow-ups: (1) surface the stale-stack restack decision to the maintainer for #343→…→#397; (2) after restack, a plain re-run should confirm `test-xs`; no code change to #397's gateway diff is needed.
