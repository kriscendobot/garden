---
ts: 2026-06-09T04:45:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--0668d9
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655451705
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4656037929
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/043500Z-result-designer-04b954.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/044127Z-result-researcher-a8b661.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/042500Z-result-researcher-3ab7bd.md
---

# dispatch: builder — implement the drop-the-pseudo-prototype redesign per packages/immutable-arraybuffer/DESIGN.md

Maintainer-directive chain step 2 of 2 (designer → builder
serially per kriskowal at 2026-06-09T04:15Z on PR #430:
"dispatch the designer and builder serially, without waiting for
a review or landing on the design").

The designer (`04b954`) authored
`packages/immutable-arraybuffer/DESIGN.md` (529 lines, commit
`a4ce95b0c`) on branch
`design/immutable-arraybuffer-drop-the-pseudo-prototype` with
explicit calls on the four open questions. Two researchers
(`3ab7bd` broad, `a8b661` refinement) produced the references.

## Library and project references

(Broad references at researcher `3ab7bd`'s result entry —
`journal/entries/2026/06/09/042500Z-result-researcher-3ab7bd.md`.
Refinement deltas below from researcher `a8b661`'s result entry —
`journal/entries/2026/06/09/044127Z-result-researcher-a8b661.md`.)

### Library and project references (refinement)

- **3ab7bd's references are current.** No new master commits
  since `3ab7bd` ran; `origin/master` still at `4a04d078b`
  (2026-06-05). Design branch is one commit ahead
  (`a4ce95b0c` DESIGN.md).
- **DESIGN.md gap**: one substantive load-bearing consumer the
  DESIGN.md omitted — `packages/pass-style/src/byteArray.js:14-45`
  samples `getPrototypeOf(immutableArrayBuffer)` at module load
  and uses it in `ByteArrayHelper.assertRestValid` (line 58).
  After redesign, the prototype identity check becomes redundant
  (equivalent to a sanity check against `ArrayBuffer.prototype`);
  the brand discriminator via the `immutable` accessor still
  works. **Builder makes a call**: leave the redundant check
  (passively useful) or simplify to accessor-only. Either
  defensible.
- **`packages/ses/test/immutable-arraybuffer.test.js`** still
  passes unchanged after redesign — `iabProto === ArrayBuffer.prototype`
  which is frozen after lockdown, so both `isFrozen` assertions
  hold.
- **Pre-push-gate probes likely to fire**:
  - `no-pull-citations` on the DESIGN.md (it cites `#430`, `#417`,
    inline-comment URLs). Resolution: rewrite citations to bare
    SHA / branch names, OR re-qualify as
    `endojs/endo-but-for-bots#430` etc. Run the probe before the
    first build commit and either tighten the DESIGN.md (a
    follow-up commit) or use the qualification pattern.
  - `sentence-per-line-md` may fire on the DESIGN.md prose.
    Same resolution: either tighten or note the probe-output and
    fix-as-you-go.
- **Test command shapes**:
  - `corepack yarn workspace @endo/immutable-arraybuffer test`
  - `corepack yarn workspace @endo/immutable-arraybuffer lint:types`
  - Cross-package smoke: `corepack yarn workspace ses test` and
    `corepack yarn workspace @endo/pass-style test`.
- **package.json / shim.types.d.ts** verification: no field
  rename needed in `package.json` (no `main`/`module`/`exports`
  field references the pony filename literally); `shim.types.d.ts`
  unaffected since the type surface for the shim itself doesn't
  change.
- **One-line `index.js` rewrite** per Move 3 (the designer's call
  is to narrow exports to `isBufferImmutable` only since
  `sliceBufferToImmutable` and `optTransferBufferToImmutable`
  become internal). `index.js` becomes
  `export { isBufferImmutable } from './src/immutable-arraybuffer-lib.js';`.
- **Changeset shape**: multi-package — `@endo/immutable-arraybuffer`
  gets a `major` (the public API narrows + `Symbol.toStringTag`
  changes) and `ses` gets a `patch` or `minor` (the permits
  removal + intrinsics-sampling deletion). Follow
  `.changeset/host-module-exits.md`'s shape as a recent precedent.
- **Rename discipline**: don't gold-plate. The directive is
  literally "all occurrences of pony" — that means filenames,
  identifiers, JSDoc prose, README. The designer's call to leave
  CHANGELOG.md historical is the bounding rule on retroactive
  rewrites. Inside source files, every `pony` → `lib`; inside
  test titles, every `ponyfill` → `lib`; inside README, every
  `Ponyfill` and `ponyfill` → `Lib` / `lib` per case.
- **Test-title spec spelling**: for the new amplifier-fallthrough
  tests, follow
  `garden/skills/test-title-spec-spelling/SKILL.md`. Title shape
  like `'amplifyArrayBuffer returns this for genuine ArrayBuffer
  fallthrough'`, not `'amplifier returns this when no
  amplified-one'`.

## Task

In your `project/` worktree on the design branch
(`design/immutable-arraybuffer-drop-the-pseudo-prototype`,
HEAD `a4ce95b0c` carrying the DESIGN.md):

1. **Read** `packages/immutable-arraybuffer/DESIGN.md` in full.
   It is the spec. The five moves and their rationale are there.
2. **Read** `packages/immutable-arraybuffer/src/immutable-arraybuffer-pony.js`
   and `-shim.js` in full. The rename and the install-body
   extension are mechanical once the design is internalized.
3. **Read** the two test files
   `packages/immutable-arraybuffer/test/immutable-arraybuffer-pony-{slice,transfer}.test.js`
   in full. The rename + import-path-update + prototype-assertion
   updates are mechanical; the new amplifier-fallthrough tests
   land as a new test file or a new section in an existing file
   per the designer's test plan.
4. **Implement the five moves per the DESIGN.md order**:
   - **Moves 1+3 together**: rename "pony" → "lib" throughout
     (filenames, identifiers, JSDoc, README, tests); narrow
     public exports to `isBufferImmutable` only; emulated
     immutables directly inherit from `ArrayBuffer.prototype`
     (`makeImmutableArrayBufferInternal` no longer
     `Object.setPrototypeOf` to a pseudo-prototype).
   - **Move 2**: amplifier-with-this-fallthrough. Rename
     `getBuffer` → `amplifyArrayBuffer`. Returns `this` on
     fallthrough. Read accessors and `slice` straight-delegate;
     mutators (`resize`, `transfer`, `transferToFixedLength`,
     `transferToImmutable`) discriminate on WeakMap membership
     and delegate to the captured genuine method on fallthrough.
   - **Move 4**: shim extends to copy the lib's property record
     (`immutableArrayBufferLibProperties`) onto
     `ArrayBuffer.prototype`. Preserve warn-and-overwrite policy
     with expected-overwrite list filtering `slice` / `resize` /
     `transfer` / `transferToFixedLength` out of the warning.
   - **Move 5** (its own boundary-crossing commit): delete
     `packages/ses/src/permits.js:1393-1412` (the
     `%ImmutableArrayBufferPrototype%` block) and
     `packages/ses/src/get-anonymous-intrinsics.js:170-177` (the
     throwaway-instance prototype walk). One commit, scoped
     `chore(ses): drop %ImmutableArrayBufferPrototype% intrinsic
     per immutable-arraybuffer DESIGN.md`.
5. **Address the pass-style consumer**. The DESIGN.md gap
   identified by researcher `a8b661`:
   `packages/pass-style/src/byteArray.js:14-45`. Make the call:
   leave the redundant check (annotated with a `// post-drop-the-
   pseudo-prototype: redundant but passive` JSDoc note) OR
   simplify to accessor-only. Document the decision in the
   PR body.
6. **Run the test command suite**:
   - `corepack yarn workspace @endo/immutable-arraybuffer test`
   - `corepack yarn workspace @endo/immutable-arraybuffer lint:types`
   - `corepack yarn workspace ses test`
   - `corepack yarn workspace @endo/pass-style test`
   - `corepack yarn build` (cross-package)
   - `corepack yarn lint` (top-level, scoped)
   All must pass before the PR opens.
7. **Add the changeset** per the multi-package shape above. Both
   `@endo/immutable-arraybuffer` (major) and `ses` (patch or
   minor; designer's call: this is a permits-shape change, so
   `minor` is conservative).
8. **Pre-push-gates**: run from `project/`. Expect
   `no-pull-citations` (on DESIGN.md citations) and possibly
   `sentence-per-line-md` to fire. Address by tightening the
   DESIGN.md citations or re-qualifying with full repo path.
9. **Open the DRAFT PR** on the bot fork to `endojs/endo-but-for-bots`
   targeting **`master-4a04d07`** (the current frozen-base
   snapshot, freshly pushed). Title:
   `feat(immutable-arraybuffer,ses): drop the pseudo-prototype
   intrinsic (per DESIGN.md)`. Body follows
   `.github/PULL_REQUEST_TEMPLATE.md`. Reference PR #430 as the
   experiment/predecessor; reference erights's design comment
   `4655451705` and kriskowal's authorization comment
   `4656037929`.
10. **Post the PR link** as a reply on PR #430 (per maintainer
    directive: "Please report the PR link here"). Short message
    naming the new PR number/URL + that the gamut continues from
    here.

## Authorizations (per-action, forwarded by steward)

- **Push commits** to the design branch (regular append push).
- **Push the new branch** the builder might want to use (the
  design branch can also be the PR head if you prefer one
  branch per design+implementation pair). Either shape is fine;
  the maintainer did not specify.
- **Open the DRAFT PR** on the bot fork to
  `endojs/endo-but-for-bots master-4a04d07`. The bot fork has
  direct push authority on this repo.
- **Reply on PR #430** with the new PR link. Standing
  `endo-but-for-bots` broad-comment authorization.

## Out of scope

- **TypedArray-side analog** (the freezable-TypedArray
  amplifier + property record). The DESIGN.md's "out of scope"
  section names this; it lands as a separate PR after this one.
- **Premise-2** (`exports` narrowing in package.json, bytes
  migration). Per the designer's explicit OUT call.
- **`packages/bytes/src/to-immutable.js`** changes. Out of scope
  per premise-2 OUT.
- **TypedArray-side `permits.js` entries**
  (`%FreezableTypedArrayPrototype%`). Not introduced in master
  per design.
- **Full deletion of the README "Purposeful Violation" section.**
  The designer's call is to leave a "no longer applies" note
  rather than delete; preserve the historical discoverability.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- The new PR number/URL.
- The commit series (SHA + scope per commit; expect 2-3 commits:
  Moves-1-3, Move-2, Move-4 combinable; Move-5 separate;
  changeset commit + any pre-push-gates fixup).
- File-by-file changes (rename surface + new files).
- The pass-style consumer call (leave vs simplify; rationale).
- Test results per workspace.
- CI initial status if readable.
- The PR-link-reply URL on PR #430.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator continues the gamut (cleaner → barrister →
fixer-loop → justice) and tears down your dispatch root on return.
