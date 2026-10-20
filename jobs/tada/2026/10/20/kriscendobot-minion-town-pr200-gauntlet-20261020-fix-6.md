## Fix round 6 for kriscendobot/minion.town PR #200: pushed, CI green

I pushed five follow-up commits for panel review 5591715796 to `feat/beta-settings-simplify` (`fc7c1c33` → `aedd20ac`). CI is green: `ci-wait-merge` returned rc 0, and both "test (typecheck + vitest)" and "clip frame browser gate" passed. The test job includes the real-daemon guest-web suite, which can't run on this host.

One must-fix item is only partly closed, and I declined one.

**Must-fix items applied:**
- **locksmith:** the guest web backend no longer holds the daemon's top host. A new `connectBrowserGuestDirectory` in `root-host-socket.ts` gives it a frozen view that accepts only `web-…` and `coupon-…` root names.
- **saboteur:** the deletion marker name is now built from a digest of the guest's identifier. Only that exact name counts as a marker, so another formula filed under the `web-deleting-` prefix is never treated as a deletion to finish.
- **breaker:** a finished deletion now leaves a small text-only `web-deleted-<digest>` tombstone. If the final answer is lost, a retry succeeds, a repeated `DELETE` answers 204, and every other route refuses the credential.
- **engine-realist (partly closed):** each guest's handle is now canceled before its name is removed, which cuts peers' live references. The real-daemon test now introduces two guests before deleting one. In the pinned Endo daemon, though, cancel keeps the stored formula, so while `ENDO_GC` is off a peer's own pet name can still revive the handle. That needs daemon-side formula collection; the code comment and the PR summary say so.
- **typist:** the `deleteGuest` docs now separate refusals that change nothing from failures that leave a deletion pending.
- **purist:** `GET /api/guest/settings` is removed, so a guest credential alone no longer reveals whether any sign-in is bonded to it. Log out now appears only when the sign-in-gated `GET /account/guest-recovery` returns this browser's own guest.
- **transplanter:** Log out now goes to `GET /api/guest/sign-out`, which redirects to `WEB_SIGN_OUT_PATH`. That value is set in `minion-mcp.service`, with `%` escaped as `%%` for systemd, instead of hardcoded in `settings.js`.
- **prover:** the finish-deletion test now clicks the button with a mocked fetch and checks the `DELETE` request, the success path and the failure path.
- **archivist:** `DEPLOYMENT.md` now describes when the deletion audit actually writes lines. `ELEVATION_CONTACT` is now described as rendered by the 403 page only.

**Should-fix items applied:** the stylist renames, the spec-keeper hardening (with a hostile-array test), the cancel-fault tests from wire-watcher and corner-prober, a fast-check property for bond cleanup paging, the integrator docs sweep, "canceling" spelling in test titles, and the pruner's cut of the Release notes section from the PR body (the migration step moved into the operator section).

**Declined:** releaser's changeset request. The package is private and the repo has no `.changeset/` setup, which changeset-auditor also noted.

**Verification and posts:** I posted a SHA-anchored summary comment (issuecomment-6301835324), which covers the scribe item. Locally, `tsc` is clean and 180 tests pass across the affected suites. The full local run had one failure, `test/git-remote/capability.test.ts`. This PR doesn't touch that file, and the failure looks like a local git-environment issue. It passed in CI.

**Follow-up:** deleted guests can only be fully erased once Endo formula collection is enabled.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 160 tokens (13465500 cached reads)
- Output: 74887 tokens
- Cost: $5.970904000000002
- Wall-clock: 2679s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
