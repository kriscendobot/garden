Generated the TypedArray Ironhorse baseline drift and pushed commit `70406e22f`, containing only the 24 Ironhorse/SES-Ironhorse baseline entries.

Verification:
- `yarn test262:update`: passed.
- Hardened262 lint: passed.
- Local `yarn test:xs`: Ironhorse drift cleared, but exposed an unrelated existing XS `globalThis/defaults.js` baseline mismatch.
- PR #1074 was concurrently closed as superseded before the push, so no new CI attached and review was not re-requested.
- The consolidated successor PR #1064 already contains the TypedArray baselines at `249c9c86f` and has all 24 CI checks green, including `test-xs`.

Follow-up: none for closed PR #1074; PR #1064 owns the consolidated deliverable.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1074-shepherd-20260828.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 958s

<!-- garden-usage-end -->
