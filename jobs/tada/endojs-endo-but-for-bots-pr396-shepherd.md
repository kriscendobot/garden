I have a complete diagnosis. Let me confirm the picture before finalizing:

- **PR #396** ("gateway ResourceLedger phase 8") is a **stacked design PR**: base = `design/gateway-package-phase-7` (#395), which bases on phase-6, etc.
- #396's **own delta is 2 commits touching only `packages/gateway/**`** — and **all gateway/resource-ledger tests pass** in CI.
- The red checks (`lint`, `test` ×6 matrix, `cover` ×2, `test-xs`) fail on files **#396 does not touch**: the `lint` error is `makeClient not found in '../src/client/index.js'` in `packages/ocapn/test/netlayer-tcp-syrup.test.js`; the `test` jobs die with "Exiting due to SIGINT" (a worker crash aborting the run).
- The base PR **#395 has the identical failure set** — so these are **inherited base failures**, not introduced by #396.
- **master is green** on exactly these checks (lint, full test matrix, cover, test-xs).
- The whole phase stack is **192 commits behind master**.

This is stale-base drift: the gateway phase stack is 192 commits behind a green master, and the red is entirely in files the current phase doesn't own. A shepherd cannot fix this from #396's own head — the fix is a bottom-up rebase of the phase stack onto current master, a structural, multi-PR operation, and rebasing #396 alone onto master would detach it from its #395 base (restructuring the stack). That is a hard escalation point (structural decision + never-push-outside-scope), not a shepherd push.

No inbox messages, nothing settling. I've made no commits/pushes — correct for an escalation rather than a fix.

---

**Shepherd report — PR #396 (endojs/endo-but-for-bots), head dc18b3d90**

**Live CI state (re-fetched):** RED. Failing: `lint`, `test (20/22/24 × ubuntu/macos)`, `cover (20.x, 24.x)`, `test-xs`. Passing: `build`, `build-wasm`, gateway's own `test` job, and all others.

**Root cause: inherited stale-base failures, not #396's diff.**
- #396 is phase 8 of a stacked design PR (base `design/gateway-package-phase-7` = #395 → phase-6 → …). Its own delta is 2 commits touching only `packages/gateway/**`, and **every gateway / resource-ledger test passes** in CI.
- The red checks are all in files #396 doesn't touch: `lint` error `makeClient not found in '../src/client/index.js'` (`packages/ocapn/test/netlayer-tcp-syrup.test.js`); `test` matrix aborts with "Exiting due to SIGINT" (worker crash) in non-gateway packages.
- Base PR **#395 carries the identical failure set** → the failures are inherited from the stack base.
- **master is green** on lint, the full test matrix, cover, and test-xs. The stack is **192 commits behind master**.

**Diagnosis:** the gateway phase stack has drifted 192 commits behind a now-green master; the red is entirely stale-base API/test drift (e.g. an ocapn client API that master has since changed) plus a base-level test crash master has fixed. Nothing to fix in #396's own content.

**Why the shepherd stops (hard escalation point — structural + scope):** the fix is a bottom-up rebase of the whole gateway phase stack (phase-6 → #395 → #396) onto current master. Rebasing #396 alone onto master would detach it from its #395 base and restructure the multi-PR stack. That is outside a shepherd's push-to-own-head scope and is a structural decision spanning several open PRs.

**next: liaison** — surface to the maintainer. Recommended remedy: a weaver-driven **bottom-up rebase of the gateway phase stack onto current master, starting at the lowest still-behind phase** (each phase's failures resolve once its base is on green master), rather than any per-#396 fix. The base PR #395 (and lower phases) need the same treatment first; #396 cannot go green until its base does. Do **not** auto-advance to a fixer/weaver on #396 in isolation — the stack must be advanced coordinated from the bottom. No commits or comments were made (job body carries no comment authorization; and there is nothing in #396's own diff to change).
