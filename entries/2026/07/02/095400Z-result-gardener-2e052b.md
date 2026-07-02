---
kind: result
role: gardener
host: endolinbot2
at: 2026-07-02T09:54:01Z
---
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
job: ebfb-594-fresh-llm-pr-merge
refs:
  - PR https://github.com/endojs/endo-but-for-bots/pull/597
  - PR https://github.com/endojs/endo-but-for-bots/pull/594
  - PR https://github.com/endojs/endo-but-for-bots/pull/596
---

Fresh `llm`-based PR of #594's bucketed lint fix, opened and merged without delay
per kriskowal's 2026-07-02 maintainer directive (authorized fast unblock, same
shape as #596).

PR #597 (base `llm`) ported #594's bucketed `scripts/eslint-repo.sh` (from #594
head `3473f5df2`), replacing the per-package form landed by #596. `package.json`
already delegated `lint:eslint` to the script (from #596), so only the script
body and its changeset changed. Merged as merge commit
`2b2e3200650d2dc205ddb3c09f34ba526faf0842`; head branch `chore/lint-buckets-llm`
deleted.

Verification on the `llm`+change tree: `shellcheck scripts/eslint-repo.sh` clean;
full `ESLINT_BUCKET_SIZE=10 sh scripts/eslint-repo.sh` (each bucket's `eslint`
routed through `yarn eslint` v8.57.1, since the sandbox blocks the bare
`node_modules/.bin/eslint` shim) ran 10 buckets over all 94 packages with 0
errors (warnings only), script exit 0; tail packages `zip`/`where` confirmed
linted clean via the same route. Summary comment posted:
https://github.com/endojs/endo-but-for-bots/pull/597#issuecomment-4864436607

Scope honored: `master` and PR #594 untouched; no upstream `endojs/endo`
interaction.
