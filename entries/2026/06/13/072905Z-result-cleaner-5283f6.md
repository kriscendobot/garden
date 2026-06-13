---
ts: 2026-06-13T07:29:05Z
kind: result
role: cleaner
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/cleaner--6a6bee
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: head
    branch: feat/formula-inspector
    base: master-4a04d07
refs:
  - entries/2026/06/13/072236Z-result-builder-256add.md
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4697867800
---

# result: cleaner - stage 1 hygiene pass on PR #440 (formula-inspector)

## Summary

Stage 1 of the #440 gamut. Pre-push-gates probes already pass on the builder's HEAD; the per-category hygiene audit surfaced three new Latin-shorthand introductions in newly-added daemon source files. Fixed in one commit (`be93dadbb`), pushed, and summarized on the PR.

The chat-cut impasse was left untouched per the brief; that decision is design-level scope routed to the maintainer.

Coverage was not the target for this dispatch; the brief framed the cleaner as the deterministic-hygiene gate before the barrister panel.

## Pre-push-gates result

Ran `pre-push-gates.sh --probes-only --summary` on the project worktree at builder HEAD `121e4b1e6` and again at cleaner HEAD `be93dadbb`. All eight probes pass:

```
filename-no-stutter            pass
no-ascii-banners               pass
no-inline-import-jsdoc         pass
no-non-ascii-in-source         pass
no-pull-citations              pass
security-md-hash-uniform       pass
sentence-per-line-md           pass
test-package-no-main           pass
```

Auto-fix stages (`yarn format`, `yarn lint --fix`) were not run as part of the probe sweep; lint was verified clean on the daemon package after the hygiene edits via `yarn lint` (no findings).

## Per-category hygiene findings

### changeset-discipline

`.changeset/formula-inspector-getformula.md` is a single entry naming the user-observable shape (the new `EndoHost.getFormula` host method, the `@info` retirement, the new `endo inspect` CLI verb). One changeset per PR per release cycle is honored; the body is written to the downstream-package-author reader rather than narrating implementation detail or review history. No change.

### em-dash style

Zero em-dashes (U+2014) in any of the ten changed files or in the PR body. No change.

### no-latin-shorthand

Three new introductions in this PR's added lines, all in code comments under `packages/daemon/src/`:

- `packages/daemon/src/formula-record.js:11` (`etc.`)
- `packages/daemon/src/formula-record.js:14` (`e.g.,`)
- `packages/daemon/src/types.d.ts:755` (`e.g.,`)

Fixed in commit `be93dadbb` titled `chore(daemon): replace Latin shorthand in formula-record JSDoc`:

- `strings, arrays, etc.` becomes `strings, arrays, and similar`.
- `(e.g., an eval's endowments)` becomes `(for example, an eval's endowments)`.
- `(e.g., the endowments of an eval formula)` becomes `(for example, the endowments of an eval formula)`.

Pre-existing instances in `packages/daemon/src/daemon.js:1408` (`i.e.`), `packages/daemon/src/types.d.ts:13` and `:16` and `:914` (mixed), and `packages/daemon/test/endo.test.js:77` and `:199` are not in the diff's added lines; the no-latin-shorthand norm's *fix on encounter* scope is limited to lines this PR is already editing.

### relative-paths

No absolute filesystem paths (`/Users/`, `/home/`) appear in the diff. The new files reference garden artifacts and project files via relative paths or bare path syntax inside prose. No change.

### test-title-spec-spelling

Five new daemon test titles were introduced:

- `getFormula returns per-type formula record (make-unconfined)`
- `getFormula resolves a caplet to its worker formula`
- `getFormula returns per-type formula record (eval)`
- `getFormula is absent on the guest facet`
- `getFormula rejects cross-peer locators`

None of these name a published-spec surface (ECMA-262, WHATWG, IETF). `getFormula` is the method this PR introduces; `make-unconfined`, `eval`, `worker`, `host`, `guest` are formula-type literals from the daemon's `formula-type.js` enumeration. The CLI integration test in `packages/cli/test/demo/inspect-formula.js` has no test titles per the `_types.js` `TestRoutine` shape. No spec-spelling discipline triggers.

## PR body audit

The body cleanly partitions:

- Cut 1 (daemon) landed
- Cut 2 (CLI) landed
- Cut 3 (chat) deferred at impasse with the `master` vs. `llm` `packages/chat` shape mismatch surfaced explicitly under *Design departures*
- Cut 4 (design-doc bump on `llm`) is the sibling PR #441

Open question dispositions are itemized 1 through 4 with explicit decisions (taxonomy correction, deferred-to-chat, vestigial-on-disk retention). Security, scaling, documentation, and compatibility sections all present and accurate to the landed shape. No em-dashes; no Latin shorthand; no absolute paths. The body does not need a hygiene edit.

The chat-cut impasse stays where the builder placed it; cleaner does not touch design-level scope per the dispatch brief.

## Push and PR top-level comment

Commit `be93dadbb` pushed to `feat/formula-inspector`. CI re-queued on the new HEAD (lint, build, test 22.x/24.x ubuntu/macos, cover, test262, test-hermes, check-action-pins, viable-release, test-xs, test-ocapn-python all status `QUEUED` at push time). The cleaner does not block on CI convergence for a comment-only hygiene push; the barrister panel and any downstream fixer-loop will see CI state when they next read it.

Top-level summary posted on PR #440 (per the brief's authorization to post a summary ending in "Next stage: barrister panel"):
https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4697867800

## Recommended next stage

`next: barrister` for the first-round code panel on PR #440. The chat-cut impasse is in the PR body (Design departures); the barrister will read it as part of the panel's input rather than rediscovering the gap.

Self-improvement: the no-latin-shorthand skill's *fix on encounter* scope is ambiguous for a hygiene-pass dispatch that scans the whole diff: a strict reading would touch every Latin-shorthand instance the cleaner sees (including pre-existing context lines that happen to appear in the same file), and a narrow reading limits to newly-added lines. I took the narrow reading because the broader sweep would expand the cleaner's diff beyond the brief's audit-and-fix-by-category scope. A future skill revision could state which reading wins for a stage-1 hygiene cleaner. Not enough to warrant a `message` entry on its own; recording here for the next cleaner.
