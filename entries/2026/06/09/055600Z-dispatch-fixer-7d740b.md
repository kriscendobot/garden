---
ts: 2026-06-09T05:56:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--7d740b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/435
  - https://github.com/endojs/endo-but-for-bots/pull/435#pullrequestreview-4455639808
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/055200Z-result-barrister-f35f52.md
---

# dispatch: fixer — stage 3 of #435 gamut (address barrister 3 must-fix-loop substance items + summary-fix bundle)

Continuing the gamut on PR #435 per kriskowal's directive at
2026-06-09T04:15:35Z on PR #430 ("Run the gamut until done").
The barrister `f35f52` returned a 3-must-fix-loop + 7-summary-
fix verdict ([review `4455639808`](https://github.com/endojs/endo-but-for-bots/pull/435#pullrequestreview-4455639808));
all six red CI jobs are substance, not environment.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#435`, DRAFT, base
  `master-4a04d07`, head
  `build/immutable-arraybuffer-drop-the-pseudo-prototype` at
  `9dc8bd5d50dda09c83ea9cc1e78acc6590a2ef33`. The dispatch-
  prepare picked up older `53e276c66` — **before doing anything
  else, `git fetch origin build/immutable-arraybuffer-drop-the-
  pseudo-prototype && git checkout 9dc8bd5d5`**.
- **Barrister verdict**: 3 must-fix-loop, 7 summary-fix, 3
  follow-up, 3 acknowledge, 2 drop.

## Must-fix-loop items (3 root causes for 6 red CI jobs)

### MFL-1: Shim `console.warn` unguarded + four read accessors

The shim's overwrite warning calls `console.warn` unconditionally;
on `test-hermes` and `test-xs` engines without `console`, this is
a `ReferenceError: Property 'console' doesn't exist`. The trigger
is that the four read accessors (`byteLength`, `detached`,
`maxByteLength`, `resizable`) are also part of the property
record and overwrite their genuine counterparts, producing a
non-empty overwrite list that fires the warn.

**Fix options** (designer's choice; brief recommends the first):
- **Extend `expectedOverwrites`** in the shim to include
  `byteLength`, `detached`, `maxByteLength`, `resizable`
  (alongside the existing four mutators), so the warning skips
  them. This preserves the warn for any actually-unexpected
  overwrite.
- **`typeof`-guard the warn**:
  `if (typeof console !== 'undefined') console.warn(...)`. This
  is more defensive but masks real-world overwrites on engines
  without `console`.

The barrister's recommendation: extend `expectedOverwrites` (more
specific; preserves warn semantics).

### MFL-2: `[Symbol.toStringTag]` removal breaks concordance buffer-sniff

The DESIGN.md predicted concordance would "sniff 'ArrayBuffer'
either way" after removing the per-emulated-immutable
`[Symbol.toStringTag] = 'ImmutableArrayBuffer'`. Empirically
wrong: concordance now routes emulated immutables into
`Buffer.from(emulatedImmutable)`, which throws because emulated
immutables lack the genuine `[[ArrayBufferData]]` slot. 13 ocapn
codec test failures across `test (22.x)`, `test (24.x)`, `cover`.

**Fix**: restore the `[Symbol.toStringTag] = 'ImmutableArrayBuffer'`
slot as a per-emulated-immutable own-property in
`makeImmutableArrayBufferInternal`. Define via
`defineProperty(immuAB, Symbol.toStringTag, { value: 'ImmutableArrayBuffer' })`
(or equivalent), so `Object.prototype.toString.call(immuAB)` returns
`'[object ImmutableArrayBuffer]'` and concordance routes the
emulated case through its `ArrayBuffer`-style codec rather than
`Buffer.from`.

**Update the DESIGN.md** to reflect this: the purposeful violation
on `Symbol.toStringTag` persists for emulated immutables specifically
(but not for genuine ones; the redesign's drop-in-replacement
character for genuine ArrayBuffers is preserved). The README's
"Purposeful Violation" section's "no longer applies" note needs
revision to "applies only to emulated immutables".

### MFL-3: TS type errors at `src/lib.js:201, 205, 236`

The amplifier-fallthrough property record's methods call
`amplifyArrayBuffer(this)`; TypeScript flags "Property
`[Symbol.toStringTag]` is missing" on the `this` parameter.
Breaks `lint`.

**Fix**: add explicit `this: ArrayBuffer` parameter type to the
methods on the property record. Per
`garden/skills/test-title-spec-spelling/SKILL.md`-adjacent
discipline, the type annotation goes inline in the function
signature, e.g. `function transferToImmutable(this: ArrayBuffer,
...) { ... }`.

## Summary-fix bundle (7 items per barrister; address with the must-fix-loop fixes)

Per the barrister's `summary-fix` disposition: address these as
part of the same fixer pass and document each in the fixer's
result entry. Read the barrister's review body
(`pullrequestreview-4455639808`) for the seven items in detail.
Highlights:

- **Misalignment between `index.js` re-exports and the changeset/
  README prose**: the changeset says only `isBufferImmutable` is
  exported, but `index.js` re-exports three symbols
  (`isBufferImmutable`, `sliceBufferToImmutable`,
  `optTransferBufferToImmutable`) since the bytes consumer
  still imports them (premise-2 out per design). Fix: update the
  changeset + README to acknowledge all three are still
  re-exported.
- **"Four mutator overwrites do not fire" test is a self-
  described no-op** that doesn't actually verify the
  `expectedOverwrites` filter. Tighten the test to assert the
  filter actually skips the expected names.
- **Read-accessor and brand-check coverage gaps** in the new
  amplifier tests. Add cases.

## Task

In your `project/` worktree on the build branch (FETCH +
CHECKOUT `9dc8bd5d5` FIRST):

1. **Read the barrister's review** in full via
   `gh api repos/endojs/endo-but-for-bots/pulls/435/reviews/4455639808
   --jq .body` for the seven summary-fix items in detail.
2. **Apply MFL-1**: extend `expectedOverwrites` in the shim
   (recommended) OR `typeof`-guard the warn. Commit with scope
   like `fix(immutable-arraybuffer): include read accessors in
   expectedOverwrites for shim warning`.
3. **Apply MFL-2**: restore `[Symbol.toStringTag] =
   'ImmutableArrayBuffer'` as a per-emulated-immutable own
   property; update DESIGN.md and README accordingly. Commit
   with scope like `fix(immutable-arraybuffer): retain
   Symbol.toStringTag on emulated immutables for codec sniffing`.
4. **Apply MFL-3**: add explicit `this: ArrayBuffer` parameter
   types to the property-record methods. Commit with scope like
   `fix(immutable-arraybuffer): type this parameter on amplifier
   fallthrough methods`.
5. **Apply the summary-fix bundle** in 1-3 commits per the
   barrister's enumeration (changeset/README alignment fix; test
   tightening; coverage additions). Use conventional commit
   messages.
6. **Run the test command suite** to verify CI-equivalent green:
   - `corepack yarn workspace @endo/immutable-arraybuffer test`
   - `corepack yarn workspace @endo/immutable-arraybuffer lint:types`
   - `corepack yarn workspace ses test`
   - `corepack yarn workspace @endo/pass-style test`
   - `corepack yarn workspace @endo/bytes test`
   - `corepack yarn build`
   - `corepack yarn lint`
   - If concordance is reachable via `corepack yarn workspace
     @endo/ocapn test`, run that too — it was the source of the
     13 codec failures.
7. **Run pre-push-gates** in `project/` and confirm clean.
8. **Push** to `build/immutable-arraybuffer-drop-the-pseudo-prototype`
   (append push only; do NOT amend builder or cleaner commits).
9. **Post a reply on the barrister's review** as a top-level
   issue comment on PR #435 (the review-comment-reply API is
   limited; a top-level comment naming the review URL is the
   convention) listing each addressed item: the 3 must-fix-loop
   commit SHAs + the summary-fix-bundle SHAs. End with: "Next
   stage: justice re-run."

## Authorizations (per-action, forwarded by steward)

- **Push commits** to
  `build/immutable-arraybuffer-drop-the-pseudo-prototype`
  (append push only). Implicit in the fixer dispatch.
- **Top-level comment** on PR #435 naming the addressed items.
  Standing `endo-but-for-bots` broad-comment authorization.
- **Update DESIGN.md and README** as part of MFL-2 to reflect
  the design departure (Symbol.toStringTag persistence for
  emulated immutables). Standing fixer authority within the PR's
  scope.

## Out of scope

- Do NOT address the 3 follow-up items (parked in the followup
  ledger per the barrister's result; future PR or post-merge
  work).
- Do NOT address the 3 acknowledge items (panel record only).
- Do NOT drop the 2 drop items (already dropped per panel).
- Do NOT rebase or force-push.
- Do NOT un-draft the PR; justice un-drafts at gamut termination.
- Do NOT request review.

## Deliverable

A `result` journal entry under `journal/entries/2026/06/09/`
naming:

- Pre/post branch tip SHAs.
- The 3 must-fix-loop commit SHAs (one per MFL item).
- The summary-fix bundle commit SHAs (1-3 commits).
- Per-MFL resolution: what was changed, which files touched,
  any design-departure documentation updates.
- Test results per workspace (PASS/FAIL).
- pre-push-gates result.
- The PR comment URL with the addressed-items summary.
- A `Self-improvement: ...` line. The barrister surfaced two
  proposed-rule items (cross-engine console-guard discipline;
  downstream-smoke-test discipline) routed to the gardener; if
  you have additional gardener-relevant findings, name them.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches the justice re-run next and tears down
your dispatch root on return.
