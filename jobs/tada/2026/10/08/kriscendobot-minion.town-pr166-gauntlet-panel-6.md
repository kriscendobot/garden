Panel round 6 on kriscendobot/minion.town PR #166 came back **must-fix**. `panel.sh` exited 0, and the verdict is posted on the PR.

- **Run:** I ran the panel once at head `501b1e1` (branch `feat/prod-objectives-probe`), against the PR's actual base commit `d750b09` rather than a possibly stale `origin/<base>`.
- **First attempt lost:** my first launch died within about a minute because my own `pkill` killed it. That was my mistake, not a panel fault. It left only a partial run directory and no verdict. The clean rerun, with its exit code captured, is the result reported here.
- **Seats:** 34 jury seats returned verdicts.
  - 3 request changes: locksmith, breaker and pruner.
  - 15 approve and 16 are comment-only.
- **Findings behind must-fix:**
  - **locksmith:**
    - In `prod-probe.yml`, the whole probe job holds `issues: write`, and checkout saves that token where `npm ci`'s scripts can read it. The fix is to move the issue steps into a separate job and turn off `persist-credentials`.
    - CI gets the full shared-guest credential (`minion-mcp-test-cc`). It should get a dedicated, smaller probe client whose secrets are limited to `main`.
  - **breaker:** `hardCacheViolations` only checks that the word `immutable` is present, so a broken header like `no-store, immutable` would pass. It should require a `max-age` of at least 31536000, reject `no-store`/`no-cache`/`private`, and be tied to the gateway's own constant (`IMMUTABLE_CACHE`).
  - **pruner:** three wording trims in `DEPLOYMENT.md` that remove implementation detail from the operator guide.
  - **Not blocking:** assessor raised two should-fix notes. The tracking-issue step fires on any failed step, not just a probe failure, and the 60-second wait after a deploy is fixed. The decomplector agreed that the session handling was simplified in the head commit (`withSession`).
- **Review posted:** it went up at 2026-10-08T02:55:56Z as a **COMMENTED** review, because GitHub won't let the bot request changes on its own PR. The full output (87KB) is over GitHub's size limit for a review, so I posted a 58KB version: every non-approving seat's findings in full, and approving seats listed by name only.
- **Nothing else done:** no fixes and no un-draft. The fix-loop belongs to the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1604302 cached reads)
- Output: 7049 tokens
- Cost: $0.9596004000000002
- Wall-clock: 3738s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
