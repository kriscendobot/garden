Implemented and opened draft PR #1343: https://github.com/endojs/endo-but-for-bots/pull/1343

Added retained creator-only `endowSpecialNames`, default/override `@main`, formula durability, rejection guards, docs, changeset, and focused tests.

Verified:
- `yarn --cwd packages/daemon test test/provision-lifecycle.test.js` — 4 passed
- `yarn --cwd packages/daemon lint:types`
- `yarn --cwd packages/daemon test:types`

Forward reference posted: https://github.com/endojs/endo-but-for-bots/issues/982#issuecomment-5849853847

Follow-up: PR is stacked on frozen #1042 provisioning base and remains draft.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-issue982-build-special-names.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 2 host(s) (6 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (6 engagement(s) unpriced)
- Wall-clock: 923s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
