---
handed-off: endo-but-for-bots-ocapn-tcp-syrup-framing-open-pr
deliverable-complete: false
---
## Completion report: endo-but-for-bots-ocapn-tcp-syrups-framing-build

No feature code was written, because this design is already implemented on `llm`. I pushed a docs-only fix for the stale design status. The draft PR is not open yet: this host cannot create PRs on endojs, so I posted a successor job to open it.

**Why there was nothing to build:** the job was queued because the design doc's header still said "Not Started". The work landed on `llm` on 2026-05-20:
- **The package:** commit 38fe6787d added `@endo/syrup-frame` (the comma-less `<length>:<payload>` framer), with adversarial chunk-boundary tests.
- **The netlayer:** commit bdb9ddc50 made syrup framing the default for the `tcp-testing-only` netlayer. `makeTcpNetLayer({ framing })` defaults to `'syrup'`, and `'none'` is kept only for the Python test suite. `packages/ocapn/test/netlayer-tcp-syrup.test.js` tests it.
- **The index:** `designs/README.md` already listed the design as **Complete**.

The work left in the design all lives in files the other M4 builds own, or waits on other PRs:
- **Chunk loops:** removing the leftover loops in `client/handshake.js` and `client/ocapn.js` needs the Python suite on syrup framing (PR #242) and the handshake extraction.
- **Phase 4:** the upstream OCapN proposal is outside this roadmap.

Building more here would have duplicated shipped code or collided with those builds.

**What I changed:** one commit, c5bcbca27, on head `docs/ocapn-tcp-syrup-framing-status`. I also pushed the frozen base `llm-61cd656` (= origin/llm 61cd656cb).
- **`designs/ocapn-tcp-syrup-framing.md`:**
  - Status is now **Complete**, updated 2026-10-16.
  - A new *Implementation Status* section covers the two places the shipped code differs from the design: the package name is `@endo/syrup-frame` rather than `@endo/syrups`, and the framing went on `tcp-testing-only` rather than a new `tcp-syrups` identifier.
  - The section also lists the remaining pieces and which work owns them.
- **`designs/README.md`:** the M4 row named a `tcp+syrups` identifier that was never built. I corrected it and bumped the Updated date.
- **Checks:** Prettier passes and the probes-only pre-push gates printed nothing. The full gate run timed out on repo-wide lint, so it was not completed.

**PR not opened:** `ensure-pr.sh` failed with a 403 (`createPullRequest`, "Resource not accessible by personal access token"). This is the known limit of this host's token on endojs. I posted successor job **`endo-but-for-bots-ocapn-tcp-syrup-framing-open-pr`**, pinned to `requires: host=endolin-garden-ece02cb4`. It has the full PR body, including the phase/evidence ledger. It will run `ensure-pr.sh` with this job's base so the `garden-job` marker matches, then name the PR so the gauntlet gets staged.

**Follow-ups:**
- PR #741 edits the old filename `designs/ocapn-tcp-syrups-framing.md`, which has since been renamed. The new PR mentions this overlap. #741 should probably be closed or rebased.
- I added a note to the host memory: `ensure-pr.sh` must be run from the project worktree, or the phase-evidence gate stops with `governing-design-unresolved`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-tcp-syrups-framing-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3033669 cached reads)
- Output: 16499 tokens
- Cost: $1.6893137999999996
- Wall-clock: 1004s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
