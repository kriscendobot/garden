Panel round 5 on kriscendobot/minion.town PR #145 came back **must-fix**, and I posted that verdict as a review on the PR.

**What I ran:** the panel in single-round mode against an isolated checkout of `ci-minion-town-runner` at head `37b05e8`. The base was the PR's own base commit `c54f5070` (`main-c54f507`), and the files it compared match the PR's file list on GitHub (10 files). The panel ran 33 seats, finished with exit code 0, and its last line was `panel #145: code-panel single-round — must-fix`.

**What I posted:**
- **The review** is on head `37b05e8`. GitHub won't accept a request-changes review on a PR the bot authored, so it went up as a comment that says to treat it as request-changes, the same shape as earlier rounds. It holds a header with the headline items plus the 12 seats that asked for changes or left comments.
- **The 21 approving seats** are in a follow-up PR comment (issuecomment-5966558191), because the full aggregate is 77 KB and too big for one review body.

**Items for the fix round:**
- **No test for the labels claim (prover, must-fix):** the claim that a job can't pick its own runner labels has no test. Changing the code to let the request choose the labels still passes all 9 tests.
- **Newline gets past the scrub (saboteur, must-fix):** the check for which `/tmp` entries to spare uses `grep -qxF` (`ci-runner-controller.sh:57`). A file name containing a newline can match a spared entry and survive into the next job, with no docker needed.
- **Spared directories are never emptied (breaker must-fix; saboteur should-fix):** `/tmp/.X11-unix` and its siblings are world-writable, and the scrub only looks one level deep, so anything a job leaves inside them reaches the next job.
- **Should-fix items from several seats:**
  - `prune` reads a runner's age from the name the caller supplies, so a future date means it is never pruned.
  - `/var/tmp` leftovers survive a reboot and are then spared for good.
  - The private-repo check runs only when a runner is created, not while it sits idle.
  - A single `pkill` pass can miss processes a job forks, and a leftover process can make root write the runner config through a planted symlink.
  - The title needs `[skip deploy]` so the merge doesn't start a production deploy.
  - The "address panel round N" commits should be squashed or regrouped.
  - One validation run is cited for two different outcomes; cite a run on the current head.
  - The SSM wait loop in `deploy-ci-runner-host.sh` aborts on a transient AWS error instead of retrying.
- **Doubtful finding:** the archivist's JSDoc request cites lines 728–769 of a 163-line file; the exports are actually at `index.mjs:129` and `:163`. I flagged this in the review.

As the stage instructions say, I made no fixes, left the PR in draft, and changed no garden code.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (896966 cached reads)
- Output: 6135 tokens
- Cost: $0.8456932
- Wall-clock: 393s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
