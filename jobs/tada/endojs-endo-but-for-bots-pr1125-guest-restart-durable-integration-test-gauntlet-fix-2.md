All 19 active checks pass, 15 skip (path-filtered), 0 fail/pending. The fix is pushed and CI is green.

## Completion report

**Job:** Gauntlet FIX round 2 — endojs/endo-but-for-bots PR #1125 (guest-owned invitation primitive).

**What I did:** Recovered the full round-2 panel findings from the durable panel-run record (the GitHub-posted verdict was a truncated reconstruction), then applied the actionable must-fix items and pushed four review-feedback follow-up commits to the PR head (`kriscendobot/endo-but-for-bots@bot/build/endo-guest-invite-primitive`, `d9297be4..cda861b2`):

- **`fix(daemon): tolerate per-pin reincarnation failures on mail delivery`** — `reincarnateMailboxPins` ran under `Promise.all` between persisting a message and publishing its notification, so one broken pin rejected an already-committed delivery and silently dropped the live notification (engine-realist/assessor must-fix). Switched to `Promise.allSettled`, matching the established `revivePins`/`reviveNetworks` idiom.
- **`fix(daemon): rename guest nets option to networks and split guest options`** — renamed the freshly-authored `nets` option to `networks` (stylist/typist must-fix; `@nets` special-name string untouched), and split `MakeHostOrGuestOptions` into a guest-only `MakeGuestOptions` carrying `pins`/`networks` so the shared type no longer advertises options the `provideHost` path silently drops (typist/curator must-fix).
- **`test(daemon): cover concurrent, superseded, and validation invitation paths`** + endo.test.js additions — new coverage the panel flagged missing: two concurrent `accept()` calls redeem at most once (exercises the new `invitationJobs` serial queue), a superseded invitation is unredeemable, `provideGuest` rejects non-daemon-minted and wrong-typed `pins`/`networks`, `EndoDirectory.readOnly()` read-equivalence + mutator rejection, and a guest `invite` at a nested path (corner-prober/prover/fast-checker/wire-watcher must-fix).
- **`docs: trim invitation changeset to release-note bullets`** — dropped internal broker/locking/test narration per releaser; kept the user-facing API facts, one sentence per line.
- **PR body** rewritten (integrator must-fix): it had claimed `@pins` "is not walked on every mail delivery" while the code does exactly that; the bullet now matches the shipped `reincarnateMailboxPins` behavior and distinguishes it from #1227's bot-supervision mechanism.

**Verification:** `lint:types`, `lint:eslint`, and `prettier --check` clean; all new tests pass locally (worked around the known long-socket-path limit for the single-daemon suite, reverted before committing). CI reached terminal GREEN (34 checks, 0 failed) after re-running one flaky `test (22.x, ubuntu-latest)` leg that failed on a daemon-teardown `"Termination requested"` unhandled rejection in the unrelated `readLog follow` path (3 of 4 matrix legs green on the first run; my diff touches none of that code).

**Deferred (noted, not applied):** breaker's `readOnly()` deep-traversal attenuation (nested directories returned live-mutable) is design-sensitive and the security seats locksmith/warden approved the current shallow contract; the maintainer already has open designer jobs (`design-endo-daemon-storage-capability-matrix`) covering this attenuation tier, so I did not pre-empt it. engine-realist's per-delivery reincarnation amortization is a should-fix that conflicts with the maintainer's explicit "reincarnate on every message receipt" directive. The panel re-run (panel-3) is the driver's responsibility.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 264 tokens (20899990 cached reads)
- Output: 68867 tokens
- Cost: $14.405053999999993
- Wall-clock: 3229s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
