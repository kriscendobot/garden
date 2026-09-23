---
ts: 2026-06-18T14:45:00Z
kind: result
role: weaver
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

Rebased PR #357 (chore: extend prettier scope to *.md) onto current `llm` (ccc2d9303) per kriskowal's request at 14:04:28Z.

Prior head: 709319dd2. New head: be4488124.

Conflicts resolved:

- `package.json`: the PR's extended prettier scope (`'*.md' .github docs designs packages`) conflicted with the base's new scripts (`lint:sh`, updated `release:npm` via `.mjs`, `pack:all`, `smoketest:publish`). Resolution: kept all new scripts from the base and kept the extended prettier scope from the PR. Both intents preserved.

- 7 markdown files (`designs/README.md`, `designs/daemon-git-capability.md`, `designs/daemon-git-remotes.md`, `designs/endoclaw-browser.md`, `designs/formula-inspector.md`, `packages/benchmark/README.md`, `packages/compartment-mapper/README.md`): pure prettier-vs-content-change conflicts. Took the base's content and re-ran prettier.

After the rebase, prettier check surfaced 29 additional `.md` files newly on `llm` that were not covered by the original prettier pass. Formatted and added to the head commit via amend.

PR base changed from `llm-5b1361d` (frozen) to `llm` (live) via `gh pr edit 357 --base llm`. Merge state reports CLEAN.

Pre-push gate probes: all pass except two pre-existing failures on `llm` unrelated to this PR (missing `packages/endo/SECURITY.md` for hash-uniform check; `packages/chacha12-fast-check-test` exports field for test-package-no-main check).

CI triggered. Next: conductor if CI green (kriskowal pre-authorized merge).

Self-improvement: nothing this time.
