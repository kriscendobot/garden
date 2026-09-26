PR #749 CI is now green. Here's what I did:

**Diagnosis:** The PR (`build/endo-content-locators-grammar-duality` on top of `llm-cce5f61`) had `mergeable_state: unstable` because the base branch `llm` moved forward with 8 commits (PR #714) that added `listTree`, `rangeRead`, and `rangeReadText` features — which this PR's commit removed. The structural mismatch caused merge conflicts.

**Fix:** Rebased the single PR commit onto the current HEAD of `llm` (`25978ee49`). The rebase was clean (no conflicts), then force-pushed to `build/endo-content-locators-grammar-duality`.

**Result:** New CI triggered and all 19 checks passed:
- ✅ test (22.x + 24.x, ubuntu-latest)
- ✅ test (22.x + 24.x, macos-15)
- ✅ cover (22.x + 24.x, ubuntu-latest)
- ✅ lint, build-wasm, check-action-pins
- ✅ test262 (22.x + 24.x), viable-release (22.x + 24.x)
- ✅ sandbox-drivers, test-xs, test-hermes, familiar-bundle, test-ocapn-python, test-async-hooks

`mergeable_state` resolved from `unstable` → `clean`. CI run: https://github.com/endojs/endo-but-for-bots/actions/runs/29528861175

**Follow-ups:** None needed. The PR is green and mergeable. No comments were authorized for posting on the PR.
