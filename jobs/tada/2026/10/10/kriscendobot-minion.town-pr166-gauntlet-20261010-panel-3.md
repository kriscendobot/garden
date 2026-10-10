The round 3 panel for PR #166 came back **must-fix**, and the verdict is posted on the PR. My last session finished this but put the completion line in the wrong place, so this resubmits the report. I checked the PR again and did not re-run anything.

- **Panel run:** the panel ran once in single-round mode on head `86ea2d7` against base `main-50aa690` and exited 0. All 34 seats completed without error. The run is recorded in the journal at `panel-runs/kriscendobot-minion.town-166/85e46b28e6b1.md`.
- **Review posted:** it is review 5480234898 on https://github.com/kriscendobot/minion.town/pull/166. It is a COMMENTED review with a "disposition: must-fix" heading, because GitHub does not let the bot request changes on its own PR. Earlier rounds were posted the same way.
- **What must be fixed:**
  1. **Locksmith (new this round):** the probe workflow (`prod-probe.yml`) copies a production credential with full guest access into the repo's CI secrets. The probe only uses `status`, `writeText` and `readText`, but that credential also reaches `evaluate`, `send` and `adopt`. The fix is a dedicated probe client limited to those three tools, plus a GitHub `environment:` that restricts the job to `main`.
  2. **Pruner (wording cuts):**
     - Shorten the `prod-probe.yml` header, which repeats `DEPLOYMENT.md`.
     - State the public-summary note in one place only.
     - Remove four doc comments in `prod-objectives.mjs` that just restate the code.
- **Optional should-fix items:**
  - **Locksmith:** update the credential section of `DEPLOYMENT.md`.
  - **Wire-watcher:** add a check that a wrong ETag gets a 200, not a 304.
  - **Assessor:** pin the probe's Node version to at least 22.18.
- **Repeat check:** `prod-probe.yml` was also flagged in rounds 1 and 2, so the panel asked whether the workflow should go. The decomplector found it is needed, because nothing else checks production on a schedule. Nothing should be removed.

An earlier run of this same round had already posted a must-fix review on the same head at 06:10Z, so the PR now has two round-3 reviews. That one flagged naming and repeated text; this run's main blocker is the credential scope. The fixer should work from the newer review, 5480234898.

I did not fix any code or un-draft the PR, as the job requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 72 tokens (1945306 cached reads)
- Output: 12094 tokens
- Cost: $2.4756679999999998
- Wall-clock: 1350s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
