**PR #254 fix round 5: the must-fix item is fixed and pushed, but CI was still pending when the 1-hour wait ended.**

**What I did** (panel-5 review 5815580205, coverage-auditor request-changes):
- **Finding 1 (must-fix), commit `314b1d6` (head `57d3cec` → `314b1d6`):** `test/browser/landing-outcome-gate.ts` now actually clicks the two buttons it only checked before.
  - **"Try again"** on the temporarily-unavailable card is clicked twice. On the first click the outage continues: the server gets one more guest read and the same card comes back. On the second click the guest service is healthy and the page lands in the shell.
  - **"Continue to my guest"** (`#continue-guest`) is clicked from the unavailable-invitation card. The page lands in the shell and the address-bar fragment is cleared.
  - The test's stub server got a switch so the outage can be turned off partway through, plus a counter of guest reads.
- **Findings 2 and 3:** I rewrote the PR body's Evidence section.
  - The CI browser gate is now the stated coverage for the cards.
  - `dev/recovery-outcome-browser-demo.ts` is marked as a manual demo that doesn't count as coverage.
  - The `index.html` shape test is described as a markup check only.
- **Findings 4 and 5:** no code change needed. Item 4 asked for nothing, and item 5 is a reviewer-side coverage rerun.
- I posted a fix-summary comment on the PR (issuecomment-6715191632).

**Verification:**
- **Local:** the gate passes in Chromium and `tsc --noEmit` is clean. Firefox and WebKit can't launch on this host because system libraries are missing, so I couldn't run them locally.
- **CI:** the WebKit and Firefox gate legs passed with the new clicks, and `test` and `changes` also passed.
- **Still pending:** the Chromium gate leg and the two Claude-harness legs (amd64 and arm64) were still queued on the self-hosted runner at the deadline. The runner looked stalled rather than failing anything.

**Notes:**
- `ensure-project-worktree.sh` failed with a read-only file system error under the sandbox (the known shared-bare-repo issue). I used a private shallow clone under `$TMPDIR` instead.
- My first `ci-wait-merge.sh` call was moved to the background by the tool timeout and then killed, so I didn't get its exit code. I watched CI with foreground `gh pr checks` polling until the 1-hour deadline instead.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr254-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1946453 cached reads)
- Output: 9863 tokens
- Cost: $1.1612306000000001
- Wall-clock: 3886s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
