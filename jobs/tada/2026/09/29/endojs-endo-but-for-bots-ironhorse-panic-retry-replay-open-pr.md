I opened the draft PR for the Ironhorse panic retry/replay leg: **endojs/endo-but-for-bots#1385** (https://github.com/endojs/endo-but-for-bots/pull/1385).

- **Branches:** before running `ensure-pr.sh`, I confirmed that the head `llm-ironhorse-panic-retry-replay` is at `a1c0b00bd` and the frozen base `llm-1706e63` exists on the fork. No earlier PR for this job existed, so it created a new one.
- **PR state:** it is a draft, with base `llm-1706e63` and head at `a1c0b00bdeace5356f6fa79a32551f2579e2b688`. The PR is also recorded on `work/endojs-endo-but-for-bots-ironhorse-panic-retry-replay-open-pr`.
- **Title and body:** used exactly as the job gave them. I changed no code and deleted the temporary body file afterwards.
- **Warning:** `ensure-pr.sh` flagged five body headings that the base branch's PR template doesn't list, including "Supervisor side", "Not in this PR" and "Review items". This is allowed, and I left the body as written.

**Follow-ups:** the PR is stacked on #1380, so review and merge should follow that stack's order. As the body says, CI only runs `cargo check` for xsnap, so the XS replay test has only been run locally, not in CI.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-retry-replay-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (240224 cached reads)
- Output: 5708 tokens
- Cost: $0.5554847999999999
- Wall-clock: 59s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
