---
ts: 2026-06-22T07:43:21Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
---

Fixed tsconfig.composite.json drift on PR #475 by regenerating composite tsconfigs for packages/bytes and packages/pass-style after the refactor moved @endo/immutable-arraybuffer between packages.

**Task:** Builder had moved @endo/immutable-arraybuffer from @endo/bytes to @endo/pass-style but did not regenerate the composite tsconfig files. CI lint job failed with "Drift detected" errors.

**Fix applied:**
1. corepack yarn install
2. corepack yarn build:types:gen (regenerated all composite tsconfigs)
3. Verified only the two target files changed: packages/bytes/tsconfig.composite.json and packages/pass-style/tsconfig.composite.json
4. corepack yarn build:types:check passed locally
5. Staged and committed the two regenerated files

**Commit:** f8fe7034e chore(bytes,pass-style): regenerate composite tsconfigs after refactor

**Push:** force-with-lease to origin/feat/narrow-bytearray-to-uint8 with lease anchor 61a382285

**New HEAD:** f8fe7034e

**Local verification:** yarn build:types:check passes; all composite tsconfig files are up to date.

Self-improvement: nothing this time.
