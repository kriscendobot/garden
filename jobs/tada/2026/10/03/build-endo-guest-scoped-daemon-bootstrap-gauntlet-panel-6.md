Panel round 6 on endojs/endo-but-for-bots#1407 (head `a62e91aca6`, base `llm-d4124e6`) came back **must-fix**.

**What I did**
- Made an isolated project checkout of `endojs/endo-but-for-bots` at `bot/build/guest-scoped-daemon-bootstrap`, using `ensure-project-worktree.sh` keyed by this job's name.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base SHA `d4124e6e40`. It exited 0 with disposition `must-fix`. All 33 seats ran and none errored: 3 asked for changes, 8 left comments only, and the rest approved (several verdicts sit inside the review text rather than the summary line).
- Posted the verdict as a COMMENT review, the same form as rounds 1–5: https://github.com/endojs/endo-but-for-bots/pull/1407#pullrequestreview-5400384875. The full aggregate was about 84 KB, over GitHub's limit. The review therefore has a summary, a list of must-fix items, and the full text of every seat that didn't approve or gave no verdict in its summary line. Approving seats are listed by name only.

**Must-fix items for the next fix stage**
1. **engine-realist:** at `packages/daemon/src/manager.js:4318`, `guestBootstrapPath` calls `provideController(id)` again after `await issue(...)`. If the guest was garbage-collected during that wait, this call can bring it back from the formula file still on disk, leaving an orphaned instance. The fix is to check `formulaForId.has(id)` before calling it again. Related should-fix: the revoke listener on `context.cancelled` is attached on every call instead of once per guest.
2. **orthographer:** six prose uses of "cancelled"/"Cancelling" need the American spelling ("canceled"/"Canceling"):
   - the design doc, lines 843 and 847
   - comments in `manager.js:4315` and `serve-guest-path.js:11`
   - the test title and error text in `guest-bootstrap-path.test.js`, lines 177 and 199
3. **pruner:** cut the PR body's "Files to review most closely" sentence (the body is 582 words; the concision check flags anything over 300).

**Should-fix, worth doing in the same pass**
- **typist:** `GuestPathIssuer.issue` is typed as returning a promise but throws immediately on some refusals.
- **archivist:** `packages/claude/README.md:138` only mentions the guest session; it should also cover the fallback to the root connection.
- **stylist:** the abbreviated `fsp` name in a new test.

**Notes**
- The prover couldn't run two of the daemon integration tests: a pre-existing `better-sqlite3` native-module version mismatch blocks them in the sandbox. It checked those code paths by reading them instead.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (816138 cached reads)
- Output: 4925 tokens
- Cost: $0.8065755999999998
- Wall-clock: 740s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
