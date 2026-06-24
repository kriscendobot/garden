---
ts: 2026-05-19T01:35:14Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

PR #288 maintainer-directed rename `@endo/cbors` -> `@endo/cbor-frame` landed. Two commits pushed to `feat/cbors-package`:

- `3544aeac5` refactor(cbor-frame): rename @endo/cbors to @endo/cbor-frame (#288).
- `c06186c2e` chore: Update yarn.lock.

Sweep:

- Package directory `packages/cbors/` -> `packages/cbor-frame/` (git-mv preserves history for 11 of 12 files; `src/index.js` registered as delete+add because all four lines changed).
- Package name `@endo/cbors` -> `@endo/cbor-frame`.
- Factory identifiers `makeCborsReader` / `makeCborsWriter` -> `makeCborFrameReader` / `makeCborFrameWriter`; internal generator `makeCborsIterator` -> `makeCborFrameIterator`.
- Test file rename and identifier sweep.
- Changeset rename and content update.
- README title and usage example.
- Design doc rename `designs/cbors.md` -> `designs/cbor-frame.md`; Naming section rewritten (dropped the prior rationale that rejected `cbor-frame`); body references updated.
- `designs/README.md` slug, link target, and status row updated.
- `yarn.lock` workspace entry rekeyed.
- Prettier folded into the rename commit (one cascade artifact in the test file post-rename).

Verification on the new head:

- `yarn lint:prettier`, `yarn lint:eslint`, `yarn lint:types` clean on `packages/cbor-frame/`.
- 36 / 36 tests pass under `lockdown`, `base`, and `noop-harden` ses-ava configs.
- Full CI matrix on `c06186c2e`: all 25 checks pass.

Reply posted at https://github.com/endojs/endo-but-for-bots/pull/288#issuecomment-4483637935 citing both SHAs.

Review re-requested via `gh api .../pulls/288/requested_reviewers`; `requested_reviewers` confirms `kriskowal`.

Out-of-scope notes (surfaced in the reply comment): `designs/syrups.md` and `designs/ocapn-tcp-syrups-framing.md` on the `llm` base branch still reference `@endo/cbors`. Both are syrup-naming-discussion documents whose `cbors` references frame the parallel naming question for `@endo/syrup-frame` / `@endo/syrups`. Sweeping them belongs with the syrup PR (PR 29) rather than this one; left for maintainer judgment.

Self-improvement: nothing this time. The rename cascade pattern matched the `review-feedback-followup-commits` SKILL § "A package rename" exactly; no gap in the playbook surfaced.
