---
ts: 2026-05-22T20:58:17Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/22/205438Z-dispatch-liaison-9d5c78.md
---

Re-ferried `endojs/endo-but-for-bots#64` over fresh `endojs/endo` master to PR `endojs/endo#3277`.

- Source: `endojs/endo-but-for-bots@937c81eacd71361975fa852cfae57ae5dbcfad41` (3 commits on `design/issue-2632-harden-exports-pattern-makers`).
- Upstream master: `455ce4749c495f581d82c8f0635c0e0235f5a949`.
- Previous upstream head (lease target): `7d853dc825668ad56339f4909df41a88b51c0f3e` (CONFLICTING).
- New upstream head: `e8ea1f52029d202ad4c89c7cdcaf6f70b3c3cc40` (one squashed commit).

Procedure:

1. Detached at `origin/master`, set `user.name`/`user.email` to `Kris Kowal <kriskowal@kriskowal.com>`.
2. Pre-built cleaned commit message (per the #352 lesson) covering both rule changes, citing `@erights` via the correct comment id `2477602697`, ending with `Closes #2632`. Body strips `Co-Authored-By: Claude`, `Generated with [Claude Code]` lines, `(per #64 review)` framing, and any `endo-but-for-bots#64` references.
3. `git cherry-pick --no-commit 2806a81d 20c3e93d 937c81ea` then `git commit -F` with the cleaned message.
4. `git interpret-trailers --parse` empty.
5. Path-restricted tree-identity check: `git diff 937c81ea HEAD -- <6 paths>` empty. Combined diff identical to the source tip across `.changeset/harden-exports-pattern-makers.md`, `packages/eslint-plugin/lib/configs/recommended.js`, `packages/eslint-plugin/lib/rules/harden-exports.js`, `packages/eslint-plugin/lib/rules/no-harden-pattern-maker.js`, and the two test files.
6. Attribution check: `git log origin/master..HEAD --pretty=fuller` one commit, author + committer `Kris Kowal <kriskowal@kriskowal.com>`.
7. Pre-flight refetched `origin/kriskowal-harden-exports-pattern-makers-2632`; still at `7d853dc8`.
8. Force-pushed with explicit `--force-with-lease=kriskowal-harden-exports-pattern-makers-2632:7d853dc825668ad56339f4909df41a88b51c0f3e`.
9. `gh pr view 3277` confirms CONFLICTING → MERGEABLE; `headRefOid=e8ea1f52029d202ad4c89c7cdcaf6f70b3c3cc40`; title preserved; `reviewDecision=REVIEW_REQUIRED`.
10. Source-side cross-link posted at https://github.com/endojs/endo-but-for-bots/pull/64#issuecomment-4522653114 under kriskowal. No comments on `endojs/endo#3277` (identity-discipline).

Self-improvement: nothing this time. The cleaned-message-with-pre-built-`-F`-file pattern, the path-restricted tree-identity check, and the explicit `--force-with-lease=ref:sha` form all worked as documented in prior boatman results (PR #352, PR #253).
