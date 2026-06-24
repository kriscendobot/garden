---
ts: 2026-06-09T04:41:27Z
kind: result
role: researcher
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/researcher--a8b661
short_id: a8b661
to: liaison
refs:
  - entries/2026/06/09/041700Z-dispatch-researcher-3ab7bd.md
  - entries/2026/06/09/042500Z-result-researcher-3ab7bd.md
  - entries/2026/06/09/042900Z-dispatch-designer-04b954.md
  - entries/2026/06/09/043500Z-result-designer-04b954.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: predecessor
---

# result: researcher refinement for drop-the-pseudo-prototype builder (a8b661)

This is a refinement-only dispatch ahead of the builder that
implements `packages/immutable-arraybuffer/DESIGN.md` at commit
`a4ce95b0c` on branch `design/immutable-arraybuffer-drop-the-pseudo-prototype`.
3ab7bd's broad references (library section files, source pages,
keyword shortcuts, project README anchors, file/identifier rename
surface, permits.js line numbers, the bytes/marshal touchpoints, the
PR #430 translatable-commits list) remain canonical and current
against the design branch at `a4ce95b0c` and against `origin/master`
at `4a04d078b` (last new master commit 2026-06-05 21:59 PDT, no new
master commits since 3ab7bd ran). This refinement is the delta the
*builder* needs on top of the references the designer already had,
plus one substantive load-bearing consumer the DESIGN.md does not
mention (`packages/pass-style/src/byteArray.js`).

````markdown
## Library and project references (builder-only delta on top of 3ab7bd)

3ab7bd's `## Library and project references` section (entry
`entries/2026/06/09/042500Z-result-researcher-3ab7bd.md`) is the
canonical reference set for this work and is current against master
`4a04d078b` and the design branch `a4ce95b0c`. The keyword writeback
3ab7bd performed (18 shortcuts at `library/keywords.md:6476-6492`) is
in place. The bullets below are additive; they do *not* duplicate
3ab7bd.

### Implementation-time pointers the DESIGN.md does not pre-resolve

- **`packages/pass-style/src/byteArray.js:14-45` is a cross-package
  consumer that depends on the intermediate-prototype identity and
  the DESIGN.md does not mention it.** The `adaptImmutableArrayBuffer`
  function samples `getPrototypeOf(new ArrayBuffer(0).sliceToImmutable())`
  at module load and uses the result as `immutableArrayBufferPrototype`.
  The `ByteArrayHelper.assertRestValid` body at line 58 then asserts
  `getPrototypeOf(candidate) === immutableArrayBufferPrototype` as
  part of byteArray pass-style validation. After the redesign,
  `immutableArrayBufferPrototype === ArrayBuffer.prototype`, so the
  identity check at line 58 admits every genuine `ArrayBuffer` whose
  prototype has not been mutated, not just emulated immutables. The
  brand discriminator `apply(immutableGetter, candidate, [])` at
  line 60 still rejects mutable buffers correctly (it dispatches to
  the redesign's `immutable` accessor, which returns `false` on
  fallthrough), so the *intent* of `assertRestValid` is preserved.
  The line-58 check becomes redundant rather than incorrect. The
  builder needs to make a call: leave the redundant check in place
  (it is now `getPrototypeOf(candidate) === ArrayBuffer.prototype`,
  a useful sanity gate against subclasses), or simplify the helper
  to rely only on the `immutable` accessor. Either is defensible;
  preserve the comment at line 28-32 ("As proposed, this will be the
  same as `ArrayBuffer.prototype`") because the redesign makes the
  proposal's case the actual case.
- **`packages/ses/test/immutable-arraybuffer.test.js` (14 lines, two
  assertions) still passes unchanged** after the redesign:
  `getPrototypeOf(iab)` returns `ArrayBuffer.prototype`, which is
  frozen after `lockdown()`, so `t.true(isFrozen(iabProto))` and
  `t.true(isFrozen(iabProto.slice))` both hold. The test's name
  ("ses Immutable ArrayBuffer shim installed and hardened") is still
  accurate. The builder need not rewrite it; flag it in the test plan
  as "covered, no edit needed".
- **`packages/immutable-arraybuffer/shim.types.d.ts` (the public
  type declaration) is on master and renamed via `Move 1`'s "every
  occurrence of pony" only insofar as the JSDoc prose mentions it;
  the file itself stays at `shim.types.d.ts`** (not "pony" in the
  name). The three declared methods/accessor (`sliceToImmutable`,
  `transferToImmutable`, `immutable`) on `interface ArrayBuffer`
  stay correct after the redesign because the shim still installs
  those three. No `.d.ts` edits are needed for the immutable-side
  of the redesign as scoped.
- **`packages/immutable-arraybuffer/test/shim.types.test-d.ts`** (9
  lines) imports from `@endo/immutable-arraybuffer/shim.js` and
  asserts the three method/accessor types via `tsd`. Unchanged by
  the redesign; this file is not in the rename surface (no "pony"
  in the body or the filename).
- **`packages/immutable-arraybuffer/index.js` is one line:**
  `export * from './src/immutable-arraybuffer-pony.js';`. The
  DESIGN.md (`Move 3`'s narrowed-public-exports paragraph) keeps
  `index.js` and narrows it to export `isBufferImmutable` only. The
  mechanical shape: rewrite this file to
  `export { isBufferImmutable } from './src/immutable-arraybuffer-lib.js';`
  rather than `export *`. The `package.json` `main`/`module` fields
  (both `./index.js`) and the `exports['.']` entry (`./index.js`)
  stay; only the contents of `index.js` narrow.
- **`packages/immutable-arraybuffer/package.json` `exports` block
  stays as-is** (the `.` export survives per the DESIGN.md's
  decision to defer premise-2 to a follow-up). Three deps fields are
  worth knowing: `main: "./index.js"`, `module: "./index.js"`, and
  the `exports['./shim.js']` block carries `"types": "./shim.types.d.ts"`
  which stays correct. No `package.json` edits required for this
  redesign as scoped.

### Test command shape (the builder runs from `project/`)

- **Single-package focused run:** `yarn workspace @endo/immutable-arraybuffer test`.
  The package's `ava` config (in its `package.json` per the project's
  convention) picks up `test/**/*.test.*` with a 2-minute timeout.
- **Single-package typecheck:** `yarn workspace @endo/immutable-arraybuffer lint:types`
  runs `tsc` against `tsconfig.json` (which includes `*.js`,
  `shim.types.d.ts`, `src/**/*.js`, and `test/`).
- **Cross-package smoke (touches `packages/ses/` and `packages/pass-style/`):**
  `yarn workspace ses test` and `yarn workspace @endo/pass-style test`.
  The `packages/ses/test/immutable-arraybuffer.test.js` and the
  byteArray-pass-style logic in `packages/pass-style/src/byteArray.js`
  are the cross-cuts; running ses and pass-style tests on top of the
  immutable-arraybuffer changes covers the integration surface the
  redesign affects.
- **Full repo build/lint/test:** `yarn build && yarn lint && yarn test`
  from the repo root. The `yarn typecheck` invocation that
  `skills/pre-push-gates/SKILL.md` § 4 names corresponds to
  `yarn lint:types` per the root `package.json` script alias chain;
  the gate's stage-4 typecheck stage runs the latter under the
  former's name. Either is correct.

### Pre-push-gate probes likely to fire on the builder's first push

(From `skills/pre-push-gates/SKILL.md` § *Garden-specific deterministic
probes*; the builder runs `garden/skills/pre-push-gates/pre-push-gates.sh`
before each push.)

- **`no-non-ascii-in-source`**: the redesign's lib file rewrites are
  all under `packages/immutable-arraybuffer/src/` so this probe
  applies. The current `immutable-arraybuffer-pony.js` is ASCII; the
  rewrite should stay ASCII. The DESIGN.md uses the mermaid block
  for the prototype-chain diagram (per garden's mermaid-over-ASCII
  rule, `roles/jurors/pedant/AGENT.md`); the builder must not be
  tempted to drop into box-drawing for any in-source diagrams.
- **`filename-no-stutter`**: the rename surface
  `packages/immutable-arraybuffer/src/immutable-arraybuffer-pony.js` ->
  `immutable-arraybuffer-lib.js` keeps the stutter (filename basename
  begins with the package name). The probe rejects
  `packages/<P>/.../<P>-foo.<ext>` *only* when the basename starts
  with or contains `_<P>_`; the existing master files do not trigger
  it (the package name `immutable-arraybuffer` is already part of
  the filename in the current pattern), so the rename does not make
  the situation worse. Verified the existing files pass today; the
  renamed files will also pass.
- **`no-inline-import-jsdoc`**: the redesign's JSDoc rewrites should
  use `@import` rather than `/** @type {import('...').X} */`. The
  current pony file has one inline-import jsdoc (`@type
  {Pick<WeakMap<ArrayBuffer, ArrayBuffer>, 'get' | 'has' | 'set'>}`
  at line 87, which is not an inline-import); the lib rewrite can
  add `@import` declarations at the top of the file rather than
  inline. The probe will flag any new inline `import('...')` usage.
- **`no-pull-citations`**: the DESIGN.md cites PR #430, #417 and
  inline comment URLs throughout. The probe excludes `*.md` outside
  `packages/<pkg>/{src,lib}/` paths? Re-check: the probe rejects
  `pull/<n>` URLs or `#<n>` references in changed paths under
  `packages/**/*.{js,md}`. DESIGN.md sits at
  `packages/immutable-arraybuffer/DESIGN.md` and is `*.md` under
  `packages/**`, so the probe *would* fire on the DESIGN.md
  contents. The DESIGN.md was authored at commit `a4ce95b0c` and
  pushed without the gate firing (or the gate's `git diff --staged`
  vs `git diff origin/<base>` paths showed clean at that push); the
  designer dispatch did not run the gate. The *builder* will run the
  gate on its first push, and the gate will see the DESIGN.md as
  part of `git diff origin/master...HEAD` (DESIGN.md is the
  one-and-only commit on the design branch at the moment). Confirm
  exact probe behavior by running `garden/skills/pre-push-gates/probes/no-pull-citations.sh`
  from `project/` before the first build commit. If the probe fires,
  the builder either (a) excepts DESIGN.md by amending the probe's
  path glob (out of scope for this PR), or (b) rewrites the
  citations to use bare commit shas / branch names without `#N` or
  `pull/N` URLs. Option (b) is preferable for this PR's scope;
  consider rewriting the DESIGN.md citations on the first build
  commit if the gate fires.
- **`sentence-per-line-md`**: DESIGN.md prose uses multi-sentence
  paragraphs (most prose pages do). The probe excludes lines that
  match list items or table cells. The DESIGN.md's paragraph prose
  may trigger the probe; verify with
  `garden/skills/pre-push-gates/probes/sentence-per-line-md.sh` from
  `project/`. If it fires, sweep the DESIGN.md to one-sentence-per-line
  shape, *or* fold the rewrite into the first build commit so it is
  not a separate noisy commit.

### CHANGELOG and changeset shape

- **The package's `CHANGELOG.md` (28 lines) carries one "pony"
  reference at line 18** (the cycle-201 `sliceToImmutable Hermes
  ponyfill and shim` historical entry). The DESIGN.md's *Open
  questions* and *Move 1* both call: leave the historical entry as a
  historical artifact. The builder follows the DESIGN.md's decision
  unless the maintainer redirects.
- **A new `.changeset/<name>.md` is warranted** per
  `skills/changeset-discipline/SKILL.md`: the redesign is
  user-observable on three axes that downstream consumers can detect:
  (1) removed exports `sliceBufferToImmutable` and
  `optTransferBufferToImmutable`; (2) emulated immutable buffers now
  directly inherit from `ArrayBuffer.prototype` (so
  `Object.getPrototypeOf(immuAB) === ArrayBuffer.prototype` rather
  than the intermediate prototype); (3) `Object.prototype.toString.call(immuAB)`
  returns `'[object ArrayBuffer]'` rather than
  `'[object ImmutableArrayBuffer]'`. The changeset's affected
  packages: `@endo/immutable-arraybuffer` (`major`), `ses` (`patch`
  or `minor`; the permits/intrinsics deletions are internal but
  observable via the intrinsics map shape). Pattern: see
  `.changeset/host-module-exits.md` for the multi-package shape;
  consolidate any review-cycle revisions into the single file rather
  than adding a second.
- **`yarn-lock-separate-commit`**: the rename touches no
  dependencies, so `yarn.lock` should not move. If a rebase forces a
  lockfile regeneration later, follow
  `skills/yarn-lock-separate-commit/SKILL.md` and ship it as its own
  `chore: Update yarn.lock` commit after the implementation commits.

### Rename discipline applied to identifier renames

- Per `skills/rename-discipline/SKILL.md`: the rename "pony" ->
  "lib" is *warranted* (DESIGN.md *Move 1* makes it the point of the
  PR). The DESIGN.md's exception list (the three exported symbol
  names `isBufferImmutable`, `sliceBufferToImmutable`,
  `optTransferBufferToImmutable` are lib-neutral and not renamed)
  applies; do not gold-plate by renaming them too. Also: the
  `ImmutableArrayBufferInternalPrototype` -> `immutableArrayBufferLibProperties`
  rename is per *Move 3* (the object's role changes from "prototype"
  to "property record"); the rename is informational, not cosmetic.
  Do not rename `buffers`, `arrayBufferSlice`, `optArrayBufferTransfer`,
  `makeImmutableArrayBufferInternal`, or any of the captured prototype
  getters/setters that are already lib-neutral.

### Test title spec spelling

- Per `skills/test-title-spec-spelling/SKILL.md`: when the builder
  writes new tests for the amplifier-with-this-fallthrough behavior
  on genuine ArrayBuffers, name the spec surfaces exactly:
  `ArrayBuffer.prototype.slice` (not `arrayBuffer.slice`),
  `ArrayBuffer.prototype.transfer` (the stage-4 method),
  `ArrayBuffer.prototype.transferToFixedLength`,
  `ArrayBuffer.prototype.resize`. The pony tests use prose like
  "Immutable ArrayBuffer ponyfill ops" which the rename converts to
  "Immutable ArrayBuffer lib ops"; both are descriptive rather than
  spec-naming so the discipline does not apply to those.

### Implementation order reaffirmation

The DESIGN.md's "Builder's recommended starting state" section (per
`043500Z-result-designer-04b954.md` § Builder's recommended starting
state) reads: Moves 1+3 first (rename + prototype downgrade
together), then Move 2 (amplifier-fallthrough on methods), then Move
4 (shim install), then Move 5 (ses-side permits + intrinsics).
Confirm this order survives the builder's reading; the file-level
coupling (Move 1 and Move 3 both touch the same source file and the
same test files) makes the joint-first choice mechanically simpler
than a Move-1-then-Move-3 sequence.

### Library writeback opportunity (for the librarian, not the builder)

3ab7bd's keyword writeback at `library/keywords.md:6476-6492` covers
the redesign-relevant terms. After the redesign *lands* on master,
the librarian's follow-up is to draft a new section file
`library/sections/endo--packages-immutable-arraybuffer--drop-the-pseudo-prototype-redesign-with-amplifier-fallthrough-and-property-record-shim-install.md`
and re-point the existing keyword shortcuts (currently `(see
source: endo--packages-immutable-arraybuffer)`) at the new section.
This is a journal-only follow-up; the builder does not own it.

### No new master commits since 3ab7bd

- `origin/master` HEAD is `4a04d078b` ("feat(compartment-mapper):
  Host module exits (#2422)") as of 2026-06-05 21:59 PDT.
- `git fetch origin master` at 2026-06-09T04:41Z returns no new
  refs. The design branch is exactly one commit ahead of master
  (the DESIGN.md commit `a4ce95b0c`); the builder's first build
  commit will be the second commit on the branch.
````

## Library writeback

No new keyword shortcuts added in this engagement (3ab7bd's 18
shortcuts already cover the redesign-relevant terms). No concept
pages drafted (per the librarian-deferral note in the refinement
above: a new section file is appropriate after the redesign lands,
not before). No distractions pruned.

## Open questions

- **`no-pull-citations` probe behavior on DESIGN.md.** The DESIGN.md
  body cites PR #430, PR #417, and inline GitHub comment URLs. The
  probe's path scope is `packages/**/*.{js,md}`, which matches
  DESIGN.md. The builder may discover on first gate-run that the
  citations need to be rewritten to bare branch names / commit SHAs.
  Surfaced as an open question so the builder reads the gate output
  attentively on the first push; the resolution (rewrite citations
  vs widen probe path exclusions) is the builder's call within the
  PR's scope.
- **`packages/pass-style/src/byteArray.js` validation logic.** The
  DESIGN.md does not address this consumer. The builder's options
  are (a) leave the line-58 prototype identity check in place (it
  is now equivalent to a sanity check against `ArrayBuffer.prototype`,
  passively useful), or (b) simplify the helper to use only the
  `immutable` accessor as the brand discriminator. Surfaced so the
  builder makes the call deliberately rather than implicitly; either
  is defensible.

Self-improvement: nothing this time. The refinement is tight (one
substantive load-bearing consumer the DESIGN.md omits, plus
implementation-time pointers a builder will reach for: test
commands, pre-push-gate probe behavior, changeset shape, rename
discipline, test title discipline, and the implementation-order
reaffirmation). The library writeback was already done by 3ab7bd;
this dispatch adds no new shortcuts and surfaces the future
librarian opportunity (post-merge section file) without acting on it.
