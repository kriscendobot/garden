All 24 checks pass. Job complete.

---

**Shepherd report — endojs/endo-but-for-bots PR #683**

CI was RED on two `lint` checks; drove both to green.

**Diagnosis (root causes, both in this PR's own new files):**
1. **prettier** — three demo files were unformatted: `packages/ocapn-noise/demo/{client,peer,scenarios}.mjs`. The short/docs-only lint workflow fails at `lint:prettier` before reaching anything else.
2. **shellcheck SC2164** — the full `yarn lint` (which runs `lint:prettier && lint:eslint && lint:sh`) fails at `lint:sh` (`-S warning` gate): `packages/ocapn-noise/demo/run-all.sh:9` had an unguarded `cd "$pkg"`. The eslint step emitted only warnings (0 errors), so it was not the blocker; shellcheck's SC2164 warning was.

**Fixes (two atomic commits, pushed to the PR head `demo/ocapn-noise-two-peer`):**
- `5ea337f60a` — `chore(ocapn-noise): prettier-format two-peer demo files` (pure formatting; `prettier --check` clean).
- `64b6dac549` — `fix(ocapn-noise): guard cd in demo run-all.sh (shellcheck SC2164)` — `cd "$pkg" || exit 1`. Verified locally with the repo's exact gate (`shellcheck -S warning`, exit 0); remaining findings in sibling scripts are info/style (SC2317/SC2015/SC2002), below the warning threshold.

**Result:** head is now `64b6dac549`; all **24** checks pass (lint ×2, tests, cover, xs/hermes/python/test262, browser, sandbox, wasm, zizmor, etc.). CI is fully green.

**Notes:** PR remains a draft — that is its correct state; shepherd scope is CI-to-green only. No PR comment posted (no per-action comment authorization in the job body; the green head SHA is `64b6dac549`). No un-draft (maintainer/gauntlet decision). No follow-ups. `next: none`.
