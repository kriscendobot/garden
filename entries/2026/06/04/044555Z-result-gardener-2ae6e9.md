---
ts: 2026-06-04T04:45:55Z
kind: result
role: gardener
host: endolinbot
to: liaison
refs:
  - entries/2026/06/04/044044Z-message-fixer-bb2325.md
  - https://github.com/endojs/endo-but-for-bots/pull/417#discussion_r3353301111
---

# Result: no-non-ascii-in-source probe landed (commit 9c223cdd)

## Routing

Fixer `bb2325` (the dispatch that addressed the four `§` instances
on PR endojs/endo-but-for-bots#417's `packages/ses/src/permits.js`)
forwarded the meta directive via
`journal/entries/2026/06/04/044044Z-message-fixer-bb2325.md`. The
maintainer's review at `r3353301111` (2026-06-04T04:21Z) was:

> Avoid non-ASCII. This is in the guide. Dispatch a gardener to
> revise the driver to have deterministic automation to keep source
> generally in the ASCII range.

## What landed

Commit `9c223cdd` on `origin/main` (2 files, +66 / -1):

- **`skills/pre-push-gates/probes/no-non-ascii-in-source.sh`** (new,
  executable): scans newly-added lines of
  `packages/<pkg>/src/` and `packages/<pkg>/lib/` `.js` / `.ts` /
  `.mjs` / `.cjs` files for non-ASCII bytes. Reports each finding
  as `file:line: non-ASCII U+XXXX ('char')` and exits 1 if any
  found.
- **`skills/pre-push-gates/SKILL.md`**: probe table grows from
  seven to eight rows. Notes-from-the-field row dated 2026-06-04
  cites the precipitating PR comment and the fixer message.
- Frontmatter `updated:` bumped to 2026-06-04.

## How it works

The probe runs as stage 3 of `pre-push-gates.sh` alongside the
existing seven probes. Path scope is intentionally narrow
(`packages/<pkg>/src/` and `<pkg>/lib/`); test and fixture paths
are excluded by glob, so the existing
`packages/bytes/test/main.test.js` UTF-8 round-trip fixtures (and
analogous files) are not affected.

Added-lines precision: the probe uses `git diff -U0` and perl to
track post-image line numbers and check only the `+` lines. A PR
that touches a file with pre-existing non-ASCII in unchanged regions
does not fail; only PRs that *introduce* new non-ASCII characters
fail.

Per-file opt-out: a `/* ascii-exempt */` marker on a line within the
first 5 of a file skips that file. This covers the rare case of a
UTF-8-round-trip test living under `src/` rather than `test/`.
Today no file in the active source tree carries the marker; it is
provided as the escape hatch for future cases.

## Verification

Quick local exercise (syntax + zero-finding run on the garden's own
current state):

```
$ bash -n skills/pre-push-gates/probes/no-non-ascii-in-source.sh
syntax OK
$ bash skills/pre-push-gates/probes/no-non-ascii-in-source.sh
pass
```

The probe will exercise on the next builder, fixer, or weaver push
that introduces a `packages/<pkg>/src/` or `<pkg>/lib/` change.
The four `§` instances the fixer addressed on PR #417 (commit
`701662fa8`) are already cleaned; this probe is the
going-forward gate that keeps the same class from re-entering.

## Composition with the existing pre-push gate

The probe sits alongside the existing seven. The full gate now:

1. Auto-fix: `yarn format`.
2. Auto-fix: `yarn lint --fix`.
3. Garden-specific deterministic probes (eight, including the new
   one).
4. Non-auto-fixable: `yarn typecheck`.

The auto-fix path does **not** repair non-ASCII (Prettier does not
re-ASCIIfy source). The probe is the manual-fix signal: the fixer
sees the failure, converts `§` to `#`, `α` to `alpha`, etc.,
and re-pushes.

## Out of scope

- **`yarn test` stage.** The user's prior directive about
  builder / fixer push validation (test failures landing) is a
  separate scope. I had asked whether the test stage should run
  per-package-of-changed-files or full-repo `yarn test`; no
  response yet. Holding that question; this probe is independent.
- **Identifier vs string-literal discrimination.** The fixer's
  proposal mentioned a tunable rule (warn on non-ASCII inside string
  literals, fail on identifiers / punctuation / comments outside
  strings). A first-pass JS-source-aware probe needs a real parser
  rather than line-level pattern matching; out of scope for this
  initial landing. Today: any non-ASCII in src/ or lib/ fails,
  regardless of context. The per-file marker opts out genuine
  intentional cases.
- **Repo-wide retroactive sweep.** The maintainer asked to keep
  source generally in the ASCII range going forward; this probe
  achieves that. Existing non-ASCII in unchanged regions of source
  is not flagged; cleanup of pre-existing instances is a separate
  per-package fixer / builder pass.

Self-improvement:
`skills/pre-push-gates/probes/no-non-ascii-in-source.sh` (new);
the panel cite-or-propose discipline (this session has seen four
gardener-actioned encodings now: parity-test, test-title-spec-spelling,
panel-pre-dispatch-state-check, no-non-ascii-in-source) is reliably
turning maintainer review observations into deterministic gates.
