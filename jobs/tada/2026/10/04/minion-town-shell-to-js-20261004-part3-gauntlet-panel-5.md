**Panel round 5: kriscendobot/minion.town PR #154**

Round 5 came back **must-fix**. I ran the panel in single-round mode on the PR head `c5a3e50` against the frozen base `2ca6c15`. `panel.sh` exited 0 with disposition `must-fix`. Of 33 seats, 3 requested changes, 9 left comments only and 21 approved.

I posted the verdict as a review: https://github.com/kriscendobot/minion.town/pull/154#pullrequestreview-5408509020. It went up as a comment review, not request-changes, because GitHub doesn't let the bot request changes on its own PR. Rounds 1–4 were posted the same way. The review has a summary, then each seat's details, with approve seats shortened to stay under GitHub's size limit.

The round 4 items are all fixed: the `$URLs` word boundary, the `Pids` rename, the stale `ENDO_COMMIT` text, the `null` host value and the unreachable branch in `deploy-app.js`.

**New must-fix items:**
1. **`endo()` wrapper is broken (breaker).** In `provision-guest-reminders.js:18-21`, each line ends with two backslashes inside a `String.raw` template, so the Bash function body splits into four separate commands. The `endo` command then runs without `sudo -u endo-daemon` and without its `HOME`/`XDG_*` settings. I compared it with the base `.sh` file, which uses a single backslash, so this is a regression from the conversion.
2. **Possible root command injection (saboteur).** `makeBoxScript` in `deploy-endo-federation.js` puts `FEDERATION_HOST`, `FEDERATION_PORT` and the route inside single quotes in a script that SSM runs as root, without checking or escaping them. A value containing `'` breaks out of the quotes.
3. **Whole-file reads for hashing (engine-realist).** `npm-registry-backup.js` reads each file fully into memory to hash it, including `registry.sqlite`, which keeps growing. The shell version streamed it through `sha256sum`.

The review also lists should-fix items:
- old names still left after the rename (in `store-deployed-daemon-compat.js` and `designs/endo-reminder-minion-town.md`)
- two separate shell-quoting helpers, and the regex that reads the pinned `endoCommit` copied in three files
- `${NAME}` and `$NAME` accept different variable names
- boundary and property tests that should be added

The coverage seat had no c8 coverage report, so coverage of the new lines wasn't checked. That doesn't block the PR.

Per the job, I didn't fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1122002 cached reads)
- Output: 7435 tokens
- Cost: $1.0090044
- Wall-clock: 813s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
