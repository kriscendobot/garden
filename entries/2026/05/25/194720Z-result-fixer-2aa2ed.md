---
ts: 2026-05-25T19:47:20Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--2aa2ed/project
refs:
  - entries/2026/05/25/194023Z-dispatch-fixer-securitymd.md
---

Restored SECURITY.md uniformity on endojs/endo-but-for-bots `llm`. The shepherd framed the deviation as `packages/bytes/SECURITY.md` containing the typo, but on inspection the canonical body (71 of 72 packages, aligned by PR #228) carried the typo `Github`, and `packages/bytes/SECURITY.md` (added later by dd45f4a7f) had the correct `GitHub` spelling. The minimal English-correct fix was to sweep the typo on all 71 canonical files so they hash-match the already-correct bytes file.

Branch: `fix/security-md-github-typo`
PR: https://github.com/endojs/endo-but-for-bots/pull/363
Commit: `8583e906e`
Files modified: 71 `packages/*/SECURITY.md` files (every package except `bytes`, which was already correct).
After-state: all 72 files hash to `d9acd9c238af1e13acd1ee0f8020dc542a579a828d70520f9829b6496ecc4e97`; `scripts/check-security-md.sh` exits 0.

Out-of-scope (intentionally left untouched to keep the diff minimal):

- `docs/security.md` carries the same typo but is not covered by the check.
- The four other shapes of pre-existing divergence I saw on the local `llm@68246ad92` (`hex`, `panic`, `immutable-arraybuffer`) were artifacts of an out-of-date local tip; on `origin/llm` only `bytes` deviated.

Posted the unblocked-PRs comment per the dispatch authorization (`#362` is the prime open consumer; `#361` had already merged before this fix landed; other open PRs against `llm` pick up the canonical SECURITY.md on next rebase).

Self-improvement: nothing this time. The shepherd's framing of "which side has the typo" was inverted, but the right read (compare canonical hash to deviant, verify in dd45f4a7f, choose the English-correct direction) fell out of the standard inspection. No rule to land.
