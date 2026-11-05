Fix round 1 for kriscendobot/minion.town#250 is done: the style pre-pass finding is fixed, pushed to the PR, and CI is green.

- **Finding:** the typist-friendly-code-points check failed on `designs/api-key-agent-directory-authorization.md:100`. That line used curly quotes (U+201C and U+201D) around "CapTP inside".
- **Fix:** I replaced them with plain `"`. A grep of the file afterwards found no curly quotes left.
- **Push:** I committed the fix as follow-up commit `01825bba` ("docs(design): use typist-friendly quotes") and pushed it to `design/api-key-agent-directory-authorization` with `safe-push-pr-head.sh`. The branch moved from `bcd20df6` to `01825bba`.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0. All 3 checks passed, none failed.
- **Follow-ups:** none. Panel-2 is the driver's to post.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (353456 cached reads)
- Output: 1431 tokens
- Cost: $0.47018319999999997
- Wall-clock: 411s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
