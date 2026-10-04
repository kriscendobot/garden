The clean stage for kriscendobot/minion.town PR #154 is done: I added test coverage, fixed one stale reference, pushed, and CI is green on the new head `ec6a460`.

**What I did**
- **Before:** CI was green at head `777dea0`, but the new helper `deploy/aws/scripts/lib/remote-template.js` had only one test. Nothing tested reading a program file while skipping its two-line header, slices that give only a start offset (`${X:4}`), variables that aren't defined (they should stay as written), or a backslash before an ordinary character.
- **Orphaned code check:** I searched for anything still pointing at the 11 deleted `.sh` files and found one stale reference. A comment in `deploy/aws/scripts/programs/deploy-endo-daemon.remote.txt` named `endo-root-host.sh`; it now says `endo-root-host.js`. The only other match, in `deploy/aws/reminder/store-deployed-daemon-compat.js`, names an old commit on purpose, so I left it. No dead code was left behind by the change.
- **New tests** in `test/deploy-script-helpers.test.mjs`:
  - one for offset-only slices, undefined variables (`$OTHER`, `${OTHER:-x}`) and a literal backslash;
  - one that runs `readRemoteProgram` on the real `deploy-endo-daemon.remote.txt` and checks that the header is dropped and the trailing whitespace trimmed.
- **Local checks:** the deploy-helper, pin-drift and deploy-cd test files pass (24 tests), and Prettier finds no formatting problems.
- **Push:** commit `ec6a460` went through `safe-push-pr-head.sh`, a fast-forward from `777dea0`.
- **CI:** `ci-wait-merge.sh` exited with rc 0. All 3 checks passed (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`).

**Follow-ups:** none. The PR is still a draft, and moving it out of draft is a later gauntlet stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (729962 cached reads)
- Output: 4623 tokens
- Cost: $0.6738604
- Wall-clock: 359s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
