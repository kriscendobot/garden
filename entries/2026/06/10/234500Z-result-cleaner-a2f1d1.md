---
ts: 2026-06-10T23:45:00Z
kind: result
role: cleaner
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - entries/2026/06/11/001500Z-result-builder-5e0a82.md
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4675761105
---

# result: cleaner a2f1d1 -- pre-push-gates probes + hygiene sweep on #403 layer-1+2+3 PR

## Branch tip

- Pre-cleaner head: `74ada9915` (builder's snapshot-mapper commit).
- Post-cleaner head: `c0d348497` (prettier reformat).
- Three new commits on `feat/registry-capability`:
  - `5c6dc5580` docs(exo-npm): remove stray tool-envelope markers; sentence-per-line README (#403)
  - `2cc36176c` docs(exo-npm): replace non-ASCII section symbol in source comments (#403)
  - `c0d348497` style(exo-npm): prettier reformat builder commits (#403)
- No yarn.lock churn this dispatch (no dependency changes).
- Append-only push; no amend or force on builder commits.

## Pre-push-gates probes scoped to exo-npm

Ran every probe in `garden/skills/pre-push-gates/probes/*.sh` against the PR diff and filtered to `packages/exo-npm/`. Initial findings:

1. **`no-non-ascii-in-source`**: six U+00A7 (`§`) characters in newly-added lines of `src/errors.js` (lines 7, 15), `src/interfaces.js` (lines 7, 62), and `src/mvs-resolver.js` (lines 478, 666). All inside JSDoc comments referring to design-document sections. The `§` in `errors.js` and `interfaces.js` came in via earlier PR commits (not the builder's three); the two in `mvs-resolver.js` are from the builder's `a2fa05af1` commit. The probe runs against `origin/master...HEAD` so all six are part of the PR's diff vs. master.
2. **`sentence-per-line-md`**: three multi-sentence physical lines in `packages/exo-npm/README.md` (lines 21, 34, 53). Lines 21 and 34 are continuations inside list bullets; line 53 is at the `## Status` paragraph.
3. **README tool-envelope corruption**: the README ended with `</content>\n</invoke>` markers (no trailing newline) carried in from the builder's overwrite-write. Not surfaced by a probe directly (none scans for tool-envelope shape), but caught visually during the README audit.
4. All other probes (`filename-no-stutter`, `no-ascii-banners`, `no-inline-import-jsdoc`, `no-pull-citations`, `security-md-hash-uniform`, `test-package-no-main`) pass on the exo-npm scope.

Project-wide probe failures (other packages, pre-existing) are out of scope for this cleaner pass.

## Commits by hygiene category

### `5c6dc5580` docs(exo-npm): remove stray tool-envelope markers; sentence-per-line README (#403)

Three README fixes in one commit (the README is the single artifact):

- Strip `</content></invoke>` markers at end-of-file.
- Reflow paragraphs inside the list bullets so each sentence sits on its own physical line.
- Add the missing trailing newline.

No prose substance changes; the package's What / Status sections read the same after the reflow.

### `2cc36176c` docs(exo-npm): replace non-ASCII section symbol in source comments (#403)

Six occurrences of `§` (U+00A7) in design-section references inside JSDoc comments are rewritten in long form ("the Foo section of designs/bar.md") to stay within the ASCII range. References still resolve to the same design-document sections; only the notational shorthand changes. Files touched: `src/errors.js`, `src/interfaces.js`, `src/mvs-resolver.js`. No runtime or type changes.

This addresses pre-push-gates `no-non-ascii-in-source` (per the PR #417 r3353301111 directive: "Avoid non-ASCII. This is in the guide.").

### `c0d348497` style(exo-npm): prettier reformat builder commits (#403)

CI lint job on the first push (`2cc36176c`) flagged Prettier drift in four files from the builder's commits: `src/errors.js`, `src/mvs-resolver.js`, `src/snapshot-mapper.js`, `test/mvs-resolver.test.js`. The drift was line-wrap and continuation-indentation differences (an `X` tagged-template wrap that the builder's local lint accepted but the CI's stricter pass rejected, plus a few callsite-line-wrap differences). `yarn prettier --write` against the same files produces the deterministic reformat; 39 tests still pass. No semantic changes.

This commit is a separate change from the two hygiene commits above so a reviewer can take the style reformat without the other doc fixes, or vice versa.

## PR body audit against pr-formation

The PR body departs from the upstream PR template in shape. The template's headings are:

- `Description`
- `Security Considerations`
- `Scaling Considerations`
- `Documentation Considerations`
- `Testing Considerations`
- `Compatibility Considerations`
- `Upgrade Considerations`

The current body uses custom sections (`What now ships`, `Design departures`, `Test coverage`, `Out of scope`, `Commits`). Per `skills/pr-formation/SKILL.md` § Use the upstream template, section for section: "Do not invent new sections, do not reorder, do not skip a section the template provides."

Other body departures from pr-formation:

- File-callout sentences ("(`src/mvs-resolver.js`)", "(`src/snapshot-mapper.js`)"). Per the skill's *No file callouts* rule, the body describes behavior and intent, not the diff.
- Commits list at the bottom. The diff carries the commit list; the body restating it is methodology leak.
- Internal-id citations (`review 4453991038`, `#358 layer 1`, `#403`). Per *No methodology leak*: the maintainer's reading experience is the change, not how the bot assembled it.

I have **not** rewritten the PR body. The substance is informative and the maintainer's directive on review 4453991038 framed the rewrite as responsive to the scope-expansion ask. Flagging for the barrister panel; the panel may dispatch a follow-up rewrite via fixer if the template departure is load-bearing.

## Hygiene audit against the other skills the brief named

- **`changeset-discipline`**: `@endo/exo-npm` carries `"private": true`; no changeset is needed for unreleased packages. The PR adds no changeset and that is correct.
- **`em-dash-style`**: zero em-dashes in any builder-touched file. Clean.
- **`no-latin-shorthand`**: one pre-existing `etc.` at `src/errors.js:138` (not in the builder's diff; not in this dispatch's scope). The builder-added prose is clean.
- **`relative-paths`**: no `/Users/` or `/home/` absolute paths in builder files. Clean.
- **`test-title-spec-spelling`**: 20 test titles across `mvs-resolver.test.js` and `snapshot-mapper.test.js`. No spec-defined surfaces are misspelled (the new surfaces `makeMvsResolveHook`, `mapSnapshot`, `buildCompartmentMap`, `makeMountReadPowers` are this package's own; titles like "resolve walks a transitive dependency graph (MVS pick)" name behavior, not specs).
- **`rename-discipline`**: builder added entirely new files; no pre-existing identifiers renamed. Out of scope by construction.

## Coverage observation (no commit warranted)

`yarn test:c8` on `packages/exo-npm` reports:

```
File                  | % Stmts | % Branch | % Funcs | % Lines
All files             |   90.21 |     80.8 |   95.83 |   90.21
 errors.js            |   95.85 |    89.47 |     100 |   95.85
 interfaces.js        |     100 |      100 |     100 |     100
 mvs-resolver.js      |   87.07 |    76.37 |     100 |   87.07
 reference-backend.js |   93.49 |    93.02 |   90.47 |   93.49
 snapshot-mapper.js   |   88.69 |    73.17 |     100 |   88.69
```

90% statement / 81% branch is above the project's typical threshold. Uncovered lines in `mvs-resolver.js` and `snapshot-mapper.js` are error paths and edge cases (lines 287-352 of snapshot-mapper are the `makeMountReadPowers` adapter's late-bind-via-registry path, exercised only when the resolution closure misses a key; lines 578-656 of mvs-resolver are the `buildRegistryResolution` flatten path's defensive branches). Per `roles/cleaner/AGENT.md` § Definition of done: "Coverage on the targeted package has measurably improved (or the cleaner's report explains why no movement is appropriate, e.g., a package already at the project's threshold)." No coverage commit warranted; 39 tests stay load-bearing.

## Test + lint state after cleanup

- `yarn test` in `packages/exo-npm`: **39 passed**, 0 failed.
- `yarn lint`: clean (no errors, no warnings).
- `yarn test:c8`: same 39 tests pass; coverage as above.

## CI state

First push to `feat/registry-capability` at `2cc36176c`: CI's `lint:prettier` job failed on Prettier drift in four builder-touched files. Second push at `c0d348497` carries the deterministic prettier reformat; CI re-fired at `https://github.com/endojs/endo-but-for-bots/actions/runs/27313849665` and is pending at result-write time. The cleaner does not block on CI here because the documentation-class commits introduce no semantic change; the substantive substance (39 tests passing locally) is unchanged.

## Top-level summary comment

Posted at `https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4675761105`. Ends with "Next stage: barrister panel."

## Recommended next stage

**barrister** (first code-panel round). The PR's substance (layers 1+2+3 of the four-layer design) is ready for code-panel review. The cleaner's hygiene sweep removed the deterministic gate findings; the panel can now focus on the substantive design and implementation surface without those distractions. The PR body shape (template departure) is a panel call: if the panel's `[stylist]` or `[pruner]` flag it, the next fixer round handles the redraft.

Self-improvement: nothing this time. The brief's structure (probes + diff audit + commit by category + push + summary) was clear and the procedure followed it. One observation for the next cleaner role iteration: a probe specifically detecting tool-envelope-marker shapes at end-of-file (the literal byte sequences a builder might accidentally write when overwriting a file from a tool-call envelope) would catch this dispatch's README finding without a visual audit. Filed as a future probe candidate; the gardener can land it if the pattern recurs.