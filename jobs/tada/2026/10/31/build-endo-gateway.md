I found draft PR #1347 already open for this job, so I didn't open a new one. It is mostly done, but the main CI test legs were still running when I stopped.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1347, "feat(gateway): register per-user daemons with the host gateway". It is still a draft. Its base is the frozen `llm-9a14ddf`, which matches the current `llm` tip, so no weave is needed.

**What's in it** (from a prior claimant of this job, already pushed on `build/endo-gateway`, head `c8c654e2d5`):
- It builds the bootstrap registration part of the gateway design (`designs/gateway-package.md` Feature 4). The old standalone `endo-gateway` design was merged into that one.
- The host gateway challenges each per-user daemon to prove it holds its Ed25519 key. It then routes only the weblets that daemon publishes, and cancelling the connection withdraws the daemon and its weblets.
- The package README, public types, a changeset, and a separate `chore: Update yarn.lock` commit are included.
- The acceptance tests cover sign-in, keeping daemons apart, routing published weblets, withdrawal, cancellation, and hostile challenges. They use real Node Ed25519 keys.
- **Affected package:** `packages/gateway` (plus `.changeset/` and `yarn.lock`).

**What I checked this attempt:**
- **Local tests:** the gateway suite passes, 124 of 124.
- **CI passing:** lint, build, cover (24.x), test-xs, test-hermes, sandbox-drivers, viable-release, and familiar-bundle.
- **CI still running:** the four `test (22.x/24.x, ubuntu/macos)` legs and `test-ironhorse-macos`, after about 40 minutes.
- **CI failing:** `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`. I don't think the PR caused these. It touches no Rust, and running `scripts/ci-changes.py --paths` on the PR's actual diff doesn't select either job. On `llm` the oracle job was skipped, and recent PR runs skip it too. My best guess is that the force-push over earlier stacked work widened the changed range CI compared. Someone should rerun them or ignore them; don't change the PR's diff for them.

**Follow-ups:**
- An earlier review pass on this PR halted after the review panel itself errored three times. That was a failure of the reviewers, not a verdict on the code. Finishing this job should start a fresh review pass on the current head.
- **Overlap:** #388 ("UDS bootstrap registrar + proof-of-possession", #343 phase 2) is still open and covers the same ground. Once #1347 lands, the maintainer should close #388 as superseded.
- The transport listener and the daemon-startup wiring are still to do, as the PR body says.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `8f85b41bb307e512e4f810070dcfd67450d15c32`; this job presented `c8c654e2d5251ab5175226190b4cd8b59394f6c9`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-gateway.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (1 unmetered)
- Input: 162 tokens (8102951 cached reads)
- Output: 43403 tokens
- Cost: $4.194642199999999 (1 engagement(s) unpriced)
- Wall-clock: 12070s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
