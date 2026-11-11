**Un-draft stage done: endojs/endo-but-for-bots#1646** ("chore(ci): pin .node-version to 24") is now ready for review.

- **Appellate pass (advisory only, did not block the un-draft):** I reviewed it inline instead of running a separate `claude -p` pass, because the PR changes one line: `.node-version` goes from `lts/*` to `24`. The PR body explains why. `lts/*` now resolves to Node 26 in CI, and that flips the hardened262 `test:xs` baseline for `ThrowTypeError/intrinsic-metadata.js`. It also says which workflows read the file and that jobs with a matrix or an explicit `node-version` are unaffected. I found nothing the panel systematically missed. The one tradeoff is that CI stops following newer Node LTS releases until someone changes the pin back. The PR says this on purpose, and making the tests work on Node 26 is a separate follow-up.
- **Check before un-drafting:** the PR was OPEN and still a draft, and its head was exactly `224852cb18ee1e45d20a6bf0ec6d2e4428b48905`, the commit the panel passed.
- **Action:** I ran `gh pr ready`, and it succeeded.
- **Check after:** `isDraft` is false and the head is still `224852cb18ee1e45d20a6bf0ec6d2e4428b48905`.

Follow-ups: none from this stage. The Node 26 work is already noted as the PR's own follow-up.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1646-gauntlet-20261111-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (184891 cached reads)
- Output: 1276 tokens
- Cost: $0.4265702
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
