---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-13T02:55:41Z
---
---
kind: result
role: warden
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
pr: 977
---

Panel seat `warden` on endojs/endo-but-for-bots#977 (`test(daemon): pin guest host-authority boundary`, base `origin/llm-0ac48c5`, head `dad2cf084e`). Diff is test-only: +100 lines, one new test in `packages/daemon/test/endo.test.js`.

### warden (SES / hardened-JS boundary)

**Verdict:** approve

**Findings:**

- `packages/daemon/test/endo.test.js:6267-6276` (should-fix) — the `@host` probe pins only `makeUnconfinedFromTree` against `parentHandle`, while the guest's own surface is pinned across all 40 host-only names. The reserved `@host` handle is the strongest confused-deputy candidate in this test (it is the guest's only standing reference to the privileged parent), so the thinnest coverage sits on the highest-value target: a regression that delegated an `EndoHost` facet through that handle would still pass 39 of 40 ways. One line closes the whole surface, keeping the existing `throwsAsync` as the live-call proof: `t.deepEqual((await E(parentHandle).__getMethodNames__()).filter(n => hostOnlyMethodNames.includes(n)), [])`. [rule: skills/adversarial-tests/SKILL.md]

- `packages/daemon/test/endo.test.js:6241` (should-fix) — `E(guest).endow(0n, {})` sends a non-frozen record across the CapTP boundary. It survives only because `@endo/captp` hardens the payload for you (`packages/captp/src/captp.js:549`, `serialize(harden([prop, args]))`), so the assertion rests on a transport convenience rather than on the test's own harden discipline. Every other argument record in this file hardens at the call site (lines 4092, 4135, 4232). Write `harden({})`. [rule: roles/jurors/warden/AGENT.md, § Operating norms, harden across the boundary]

- `packages/daemon/test/endo.test.js:6249,6260` (comment-only) — two brittleness nits in the same assertion pair. The exhaustive `t.deepEqual` relies on `getMethodNames`'s sort (`packages/eventual-send/src/local.js:74`) agreeing with a hand-sorted hardened literal, where this file's precedent at line 5742 sorts explicitly against a plain array literal; and `new RegExp(methodName)` is unanchored and drops the `u` flag its sibling literal at line 6274 carries. Prefer `.sort()` plus a plain literal, and `new RegExp(methodName, 'u')`. [proposed-rule: an exhaustive method-surface assertion sorts explicitly rather than depending on the producer's ordering, so a producer-side sort change reads as a producer change and not as a security regression.]

**Notes (out of scope but worth flagging):**

- No SES violations in the diff: no `globalThis` assignment, no `Object.prototype` touch, no prototype walking, no proxy or intrinsic-shadow trust. `guestMethods` / `hostMethods` arrive as hardened copyArrays across CapTP, so the `.filter` / `.includes` calls are genuine intrinsics on frozen inputs, not attacker-controlled traps. The two `harden` calls on the test's own fixtures are correct and match file convention.
- The `hostOnlyCalls` selection is well-chosen for this seat: the seven probed methods are exactly the ones that escape the compartment (`makeUnconfined`, `makeUnconfinedFromTree`, `makeFromTree`, `makeArchive`, `stageTree`) or mint further authority (`endow`, `provideHost`). The comment at lines 6227-6230 states that rationale rather than restating the code.

**Evidence.** Static check, run in the worktree: the host-only name set derived from `HostInterface` minus `GuestInterface` in `packages/daemon/src/interfaces.js` is exactly the 40 names in the literal at lines 6184-6222, in that order, and that order matches the sort in `packages/eventual-send/src/local.js:74`. **Not verified by execution:** this checkout cannot start the daemon (`npx ava test/endo.test.js -m 'host-only capabilities*'` fails with `ENOENT ... endo.sock`), and the pre-existing neighboring test `provideHostPath is an EndoHost-only capability ...` fails identically, so the failure is environmental (unbuilt / incomplete deps in this worktree), not a defect in the new test.

Self-improvement: nothing this time. The cite-or-propose discipline and the harden-across-the-boundary norm both applied cleanly to a test-only diff, and no gap in `roles/jurors/warden/AGENT.md` surfaced.
