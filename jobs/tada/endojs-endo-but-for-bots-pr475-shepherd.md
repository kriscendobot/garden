Shepherded endojs/endo-but-for-bots PR #475 to green CI.

- Pushed four fixes through head `0fbb067c483a556c3c39241009c380491da04a49`: completed UTF-8 codec migration, corrected OCapN byte-view handling, updated Ironhorse baselines, and refreshed `yarn.lock`.
- Verified focused crc32, daemon hashline/OCapN, and platform tests locally, plus lint, types, TypeDoc, and baseline checks.
- All GitHub Actions checks pass; PR remains open and mergeable.
- Posted completion summary: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5454796251
- Follow-up: the existing `local-verify-endo-test-xs-parity` job already owns the identified local-verification gap; no duplicate was created.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 16 on 2 host(s) (12 unmetered)
- Input: 636 tokens (59494804 cached reads)
- Output: 141383 tokens
- Cost: $37.45627499999999 (12 engagement(s) unpriced)
- Wall-clock: 18358s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
