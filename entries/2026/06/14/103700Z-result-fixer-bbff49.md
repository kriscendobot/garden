---
ts: 2026-06-14T10:37:00Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/06/14/103300Z-dispatch-fixer-bbff49.md
---

Surgical 1-file Prettier fix on `packages/registry-capability/types.d.ts` (PR #442, `feat/daemon-cas-extraction`).

- Pre-commit head: `cd7adacd8` (`test(daemon-cas): exercise joinPath across all four CAS ops`).
- Ran `npx prettier --write packages/registry-capability/types.d.ts`. The diff was exactly the expected shape: two method signatures (`lookup`, `list`) collapsed from multi-line argument lists to single-line form. 9 lines net (`1 file changed, 2 insertions(+), 7 deletions(-)`).
- `git status` confirmed only `packages/registry-capability/types.d.ts` modified; no sibling drift was auto-fixed.
- `npx prettier --check packages/registry-capability/types.d.ts` now passes.
- Single commit `5215d7a26 chore(registry-capability): prettier-format types.d.ts`.
- Push to `origin feat/daemon-cas-extraction`: `cd7adacd8..5215d7a26`, append-only fast-forward.
- Post-commit head: `5215d7a26`.

Pre-push-gates: ran `--probes-only --summary` cheaply. The gate reports many pre-existing failures (sentence-per-line markdown, ASCII banners in unrelated designs, security-md hash uniformity, filename stutter on `chat/git/ocapn` packages, inline-import jsdoc in `9p-server`, non-ASCII em-dashes in `git-askpass-helper.cjs`, bare `#<n>` ref in `add-space-modal.js`). All are inherited from the existing tree, none touch `packages/registry-capability/types.d.ts` or are introduced by this commit. Skipping the full gate (which would include `yarn typecheck` and auto-fix passes) was the intended posture; the dispatch explicitly scoped this to one file and warned against auto-fixing sibling drift the cleaner had reverted on purpose.

Posted a top-level comment on PR #442 @-mentioning `@kriskowal` with the SHA, citing it as the resolution of the inherited lint failure from PR #403's content and noting that other sibling drift remains untouched on purpose. Comment URL: https://github.com/endojs/endo-but-for-bots/pull/442#issuecomment-4701481151

PR #442 state: OPEN, isDraft=true, headRefOid matches `5215d7a26`.

Recommended next stage: orchestrator monitors CI on PR #442; once CI is green on `5215d7a26`, un-draft and dispatch the conductor for merge. No further fixer round is needed: the panel verdict that produced this dispatch was a single 1-file Prettier finding and it is now resolved.

Self-improvement: nothing this time. The surgical, single-file scoping was explicit in the dispatch brief and the cheap `--probes-only` gate confirmed the change is the only delta. No lesson to route.
