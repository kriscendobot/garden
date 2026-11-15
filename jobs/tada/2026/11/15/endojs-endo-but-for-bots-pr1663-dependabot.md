---
handed-off: endojs-endo-but-for-bots-pr1663-dependabot-after-pr1659
deliverable-complete: false
---
**endojs/endo-but-for-bots #1663**: the verdict is **MERGE-NOW**, but I did not merge. The `zizmor` CI check is red, and the merge gate never skips CI. The failure comes from the base branch, not from this PR, and PR #1659 already fixes it.

**What the PR does:** bumps `actions/setup-java` from v6.1.0 to v6.2.0. It changes one line, in `.github/workflows/floot-android.yml:31`.

**Checks:**
- **Base comparison (first step):** the base `llm` uses this action in one place, at v6.1.0 (`b843ebf9`). So the PR is still a real change, not superseded or a no-op.
- **Pinned commit:** the `v6.2.0` tag resolves to `77dd5b2c`, which matches the diff. Upstream, v6.2.0 is 7 commits ahead of v6.1.0 and 0 behind.
- **Upstream code read:**
  - `action.yml` adds one optional input, `mvn-mirrors`, which this workflow doesn't set.
  - The new network calls go only to Amazon's own Corretto servers (`corretto.aws`, `api.github.com/repos/corretto/*`). They run only when the Corretto Java distribution is chosen, and this workflow uses `temurin`.
  - The rest is Maven settings parsing, fixes for the Liberica distribution, and updated npm packages in the bundled build (including undici 6.29.1).
  - I found no new ways of running commands and no changes to credential handling. I did not read the regenerated `dist/` bundle line by line.
- **Waiting period:** v6.2.0 was published 2026-11-04T22:12Z. The 7-day waiting period ended 2026-11-11T22:12Z, so it is satisfied.
- **Security advisories:** GitHub lists none for `actions/setup-java`. This bump is routine, not a security fix.
- **CI:** `android` (the job that actually runs setup-java), `lint` and `check-action-pins` pass. 24 checks were skipped. The one failure is `zizmor`. It flags line 49 of `update-action-pins.yml` and `update-action-pins-major.yml`, two files this PR doesn't touch. Both pin `peter-evans/create-pull-request` with the comment `# v8`, and the `v8` tag has since moved to v8.1.3, so the comment no longer matches the pinned commit. PR #1659 fixes the comments, and its own CI is green. It is not merged and has no review yet. #1664 is held for the same reason.

**What I did:**
- Posted the verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1663#issuecomment-6900965224
- Wrote the dependabotany ledger entry `entries/2026/11/15/203543Z-message-botanist-af90dd.md`. It is an open MERGE-NOW row.
- Parked a follow-up job, `endojs-endo-but-for-bots-pr1663-dependabot-after-pr1659`, blocked on #1659. I confirmed it is on `origin/journal2`. When #1659 lands, it re-checks this PR and merges it with `ci-wait-merge.sh --dependabot-auto-merge`. If #1659 closes without merging, it lands the comment fix itself or parks again. The daily recheck schedule `dependabotany-recheck-endo-but-for-bots` already exists as a backstop.
- I pushed nothing to the PR or to `main2`.

**Follow-up:** #1659 needs a review and merge before this PR and #1664 can go in.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1663-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1472512 cached reads)
- Output: 9435 tokens
- Cost: $1.1105623999999998
- Wall-clock: 681s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
