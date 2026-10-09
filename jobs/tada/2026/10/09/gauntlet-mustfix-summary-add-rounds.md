I added `--add-rounds N` to the gauntlet resume command and pushed it to main2 as `d62aaab220b`. Running `gauntlet.sh --resume-from-stage <g> <stage> --add-rounds N` raises the gauntlet's `max_iterations` by N and restarts it at the chosen stage in the same step.

**What changed in `scripts/jobs/gauntlet.sh`:**
- The usage header and the usage error message now show the new option.
- N must be a positive integer.
- **Reports that hit the review budget can now be resumed.** Before this, only halted and billing-parked gauntlets could be resumed. A `review-budget-reached` report can now be resumed too, but only with `--add-rounds`, because resuming it without more budget would just end it again.
  - That report now saves the gauntlet's settings it previously dropped (round count, budget limits and so on), which is what makes the resume possible. Only reports written from now on have them, so older ones will still be refused.
  - Resuming at `panel` without `--iteration` starts at the round after the last fix; `--iteration K` still picks the round.
- The rebuilt record shows the new `max_iterations` and an `added_rounds:` field. The resume commit message and the record's text also give the new limit.
- When the review budget runs out, the message now includes the exact command to grant more rounds.

**Tests:** I added four checks to `scripts/jobs/test/gauntlet-resume-test.sh`:
- a review-budget report is refused without `--add-rounds`;
- `--add-rounds 0` is rejected;
- `--add-rounds 2` raises the limit from 3 to 5 and resumes at panel round 4 with a fresh job queued;
- repeating the command on a gauntlet that is already running does nothing and does not add budget again.

All tests passed: resume 15/15, `gauntlet-test.sh` 89/89, pin-gate 4/4, PR-dedupe 10/10.

**Docs:** the gauntlet usage header; the resume section of `designs/staged-gauntlet.md`; the `garden-gauntlet` entry in `context/operations/systemd-units.md`, which is the operator doc; and a new "Granting more rounds" bullet in the gauntlet section of `skills/pr-creation-flow/SKILL.md`.

**Follow-ups:**
- The early-termination message and PR comment still show only a count of unaddressed must-fix items. Listing the items themselves is a separate part of the parent job.
- Since the review-budget report now saves more fields, the other scripts that read it may be worth a look. The gauntlet tests pass, but I didn't run the other scripts' tests: `design-pr-gauntlet-coverage-audit.sh`, `assert-followup-posted.sh`, `proxy.sh` and `gauntlet-mustfix-summary.sh`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/gauntlet-mustfix-summary-add-rounds.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1130399 cached reads)
- Output: 10750 tokens
- Cost: $0.9891838
- Wall-clock: 1009s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
