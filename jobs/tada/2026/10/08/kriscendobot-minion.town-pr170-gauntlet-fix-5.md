Fix round 5 for PR #170 is pushed and CI is green. I haven't re-run the panel, and I didn't run the project's tests locally for this change.

Most of the round-5 must-fix items were already done on the PR head (`2dece3a`) by earlier commits:
- **`sockPath` → `socketPath`:** done in `7d03680`. The only `sockPath` left in `src/web` and `test/web` is the existing `tmp.sockPath` test-helper field, which the stylist said to leave.
- **Narrow `try` around legacy migration:** done in `4f498e9`. The `try` now covers only the `localStorage` reads, and the catch logs with `console.warn`.
- **PR description cuts:** the description already has no `Parser move` or `Browser tests` bullets, and "Security model" is a single sentence.

What I changed:
- **Typist should-fix:** I replaced the `…` (U+2026) with `...` in the `UNKNOWN_CREDENTIAL_PATTERN` doc comment in `src/web/guest-web-service.ts`. That is commit `486a9a6`, pushed with `safe-push-pr-head.sh`.

I left the non-blocking should-fix items alone, as the job asked for must-fix only. These include the `isGuest` duck-typing, `adoptGuest`, the shared constants, the switch-prompt race and Firefox/WebKit coverage.

`ci-wait-merge.sh` returned rc 0: the CI rollup finished with 3 checks, none failed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 56 tokens (1593726 cached reads)
- Output: 9196 tokens
- Cost: $1.1496212000000001
- Wall-clock: 185s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
