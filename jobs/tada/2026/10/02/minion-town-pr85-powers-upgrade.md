**Completion report: minion-town-pr85-powers-upgrade**

The maintainer replied on the thread (comment 5956098063): "happy to expand scope to both sides of upgrade, run a gauntlet, and retcon." So I implemented the powers upgrade rather than only fixing the stale rationale. It is pushed to `feat/clip-upgrade-in-place` as **5e0dbbc**, on top of af2d343.

**What changed**
- **The upgrade itself (`src/endo/gateway/daemon-site-registry.ts`):**
  - `resolvePowerReference(powerName)` now returns a frozen placeholder that just carries the power's name forward.
  - `writeDirectory` handles `changes.back` by running one evaluate in the **caller's own guest** (the new `guestRedesignateBackSource`). It gives the existing directory id a temporary name with `storeIdentifier`, runs `copy([power], [dir, 'back'])`, then removes the temporary name in a `finally`.
  - It refuses anything that isn't its own placeholder, and anything that isn't a valid formula id. It also fails loudly if the guest reports back a different directory id.
  - The upgrade still requires the `powers` right, and the `@`-name refusal still applies. Both are enforced in `publish.ts` before the authority is called.
- **Old rejection removed:** the "powers plane off" rejection is gone from `assertUpgradable` and `writeDirectory`. I rewrote module header R2 and the related comments in `publish.ts`. I also fixed the stale "not yet available" text in the `upgrade` tool description (`guest-tools.ts`) and the test comment at `test/gateway/gateway.test.ts:163`.
- **Tests:**
  - `publish.test.ts`:
    - a powers rewrite combined with a content change;
    - a powers-only rewrite, which doesn't charge and leaves `contentRoot` alone;
    - a content-only attenuation that is refused a powers rewrite before any evaluate or charge;
    - the `@`-name guard.
  - `daemon-site-registry.test.ts`: the `back` rewrite through `writeDirectory`, rejection of a foreign reference, and rejection of a mismatched directory id.
  - The wiring and registry tests now expect `assertUpgradable` to accept a `powers` input.
  - The ENDO_CHECKOUT integration test now rebinds `back` to `@agent` and checks that the live `back` read changes.
- **PR body:** I updated the description, the Changes list, Scope/residuals and the verification summary. One new residual is listed: sessions that are already open keep the bootstrap they got at connect time, and only new sessions get the new `back`.

**Checks run locally**
- `tsc --noEmit` passes. The repo has no lint script.
- `vitest test/gateway`: all 151 pass.
- Full `npm test`: 692 pass, 1 fails, 8 skipped. The failure is `test/git-remote/capability.test.ts > projectPartition > propagates a git failure…`, in code this change doesn't touch. I didn't confirm whether it also fails on the base branch.
- **The ENDO_CHECKOUT integration test was not run here.** It typechecks, but it needs a daemon checkout. One point is untested: it assumes that copying into an existing `back` entry overwrites it.

**Follow-ups**
- The maintainer also asked for a gauntlet and a retcon on #85, which were outside this job. The sibling attention job `kriscendobot-minion.town-pr85-101f9480` (in `todo/`) is routing that comment and should see this commit when it runs its preflight.
- I didn't wait for CI on 5e0dbbc. Its result still needs checking.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr85-powers-upgrade.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1527079 cached reads)
- Output: 15473 tokens
- Cost: $1.2174438
- Wall-clock: 175s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
