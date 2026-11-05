**Fix round 4 for PR #241 is pushed and CI is green.** The green covers GitHub Actions runs only: the bot token can't read `statusCheckRollup`, so `ci-wait-merge.sh` couldn't see commit statuses or non-Actions checks.

**Pre-pass findings**
- **`numRuns` in `tools/claude-harness/install.test.mjs` (blocking):** this is fast-check's own option name, so it can't be renamed. I added the probe's documented `spell-out-exempt` marker as line 1, worded the same as in `test/waitlist.test.ts`. The marker exempts the whole file, so a later abbreviation there won't be flagged either.
- **Comment at `src/http.ts:426` (advisory):** I kept it, so nothing changed here. It records a non-obvious ordering rule: the route mounts before `express.json()` (line 445), so a frozen deployment refuses the POST before reading its body. Most of the rest was already in the old comment and moved with the code.

**Commit and checks**
- **Commit:** `5a49e9bd` went to `garden/build-api-key-agents-p0-freeze-onboarding` through `safe-push-pr-head.sh`, advancing it from `52c7b820`. `ls-remote` confirms the new head.
- **Local checks:** `install.test.mjs` passed 13 of 13, and the spell-out probe passes on both the staged change and the full diff against `main-9196892`. I did not run the full pre-push gate suite or the wider test suite.
- **CI:** `ci-wait-merge.sh` returned 0 (1 run, 0 failed). I ran it with a 540-second deadline instead of the specified 3600, because a foreground command here is capped at 10 minutes; it went green in about 5 minutes.

**Possible follow-up:** line 2 of that test file says it is "Dependency-free by design" and imports only `node:` builtins, but the file also imports `fast-check`. I left this alone as outside this round's findings; the next panel or the maintainer may want to look at it.

The panel was not re-run; the driver posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (426980 cached reads)
- Output: 4866 tokens
- Cost: $0.6621
- Wall-clock: 495s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
