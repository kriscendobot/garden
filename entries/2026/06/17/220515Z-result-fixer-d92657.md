---
ts: 2026-06-17T22:05:15Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--d92657
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: target
refs:
  - entries/2026/06/17/214500Z-dispatch-fixer-d92657.md
  - https://github.com/endojs/endo-but-for-bots/pull/449
next: solicitor
---

# result: fixer d92657 — kriskowal 2 + erights view[0] + 2 additional asks on PR #449

## SHAs

- **Pre-fixer head**: `6f7526a4a` (`design(immutable-arraybuffer): summary-fix bundle from solicitor 365835 panel on PR #449`).
- **Post-fixer head**: `ba4703bd5` (`design(immutable-arraybuffer): add view[0] worked example + adapter withdrawal note per erights/kriskowal`).
- **Commit 1**: `59e392e5a` (`chore(immutable-arraybuffer): move design files into designs/ subdirectory per kriskowal`).
- **Commit 2**: `ba4703bd5` (`design(immutable-arraybuffer): add view[0] worked example + adapter withdrawal note per erights/kriskowal`).
- **Branch**: `design/immutable-arraybuffer-freezable-typedarray-emulation` (append-only push, fast-forward).

## Enumerated asks since 21:25Z

The dispatch brief named three (two kriskowal + one erights). On enumeration I found six inline comments from kriskowal+erights between 21:26Z and 21:41Z; the three additional ones were one substantive ask (erights non-ASCII removal) and two confirmations:

1. **r3431570369** (erights, 21:26Z, line 30 of `DESIGN-freezable-typedarray.md`): "Also need to revise `packages/pass-style/src/byteArray.js` to use a frozen Uint8Array... Perhaps packages/bytes need a similar revision. I'll leave that to @kriskowal."
2. **r3431577358** (kriskowal, 21:28Z, line 1 of `src/lib.js`): "Let's instead introduce a designs directory, designs/README.md index, and the two composite designs."
3. **r3431584143** (kriskowal, 21:29Z, line 30 of `DESIGN-freezable-typedarray.md`): "I believe we will be able to withdraw adapters for frozen Uint8 arrays backed by frozen immutable ArrayBuffer from `@endo/bytes`..."
4. **r3431601526** (erights, 21:33Z, line 142 of `DESIGN-freezable-typedarray.md`): "@kriscendobot remind me, how do we achieve `view[0] = 42; view[0]` ?"
5. **r3431624411** (erights, 21:38Z, line 656 of `DESIGN-freezable-typedarray.md`): "On this `internal-heir.js` question, the best answer is **Delete the helper** and inline the construction."
6. **r3431636201** (erights, 21:41Z, line 309 of `DESIGN-freezable-typedarray.md`): "Please avoid non-ascii characters everywhere unless there is a strong reason to use one." (suggesting `*Open question* section 1` instead of `*Open question* § 1`).

## Per-ask resolution

| ID | Author | Resolution | Commit |
| --- | --- | --- | --- |
| r3431570369 | erights | Acknowledged; out of scope for this PR; design's *Cross-package consumer touchpoints* section already names the expected post-merge no-op shape and cites this ask. Reply only. | (no commit) |
| r3431577358 | kriskowal | Files moved to `packages/immutable-arraybuffer/designs/{immutable-arraybuffer,freezable-typedarray}.md` via `git mv`; `designs/README.md` index added; `src/lib.js` and `test/shim-amplifier.test.js` cross-references updated; design self-references updated. | `59e392e5a` |
| r3431584143 | kriskowal | Added *Future adapter withdrawal from `@endo/bytes`* sub-section under *Test plan* > *Cross-package consumer touchpoints* in `designs/freezable-typedarray.md`. | `ba4703bd5` |
| r3431601526 | erights | *Semantics* section retitled to *Indexed assignment never modifies the underlying buffer*; two worked examples added (non-frozen wrapper with own-property shadowing; frozen wrapper with silent swallow); API surface table and per-flavor test plan updated. The prior text's claim that `view[0]` returns `0` after assignment was incorrect for the non-frozen case; the new text establishes the invariant (the underlying buffer is never modified, regardless of frozen state) and the per-state semantics separately. | `ba4703bd5` |
| r3431624411 | erights | Confirmed; the design already deletes the helper (per fixer a58c91 commit `aab2af75d`, panel #449 must-fix #1). Reply only. | (no commit) |
| r3431636201 | erights | The 11 `§` glyphs (U+00A7) in `designs/freezable-typedarray.md` become `section` prose; the one `←` glyph (U+2190) in the Problem code-block comment is removed. The other design file already had no non-ASCII. | `59e392e5a` |

## Pre-push-gates

```
yarn format            pass (auto-fixed 1 paths; re-staged)
yarn lint --fix        pass (auto-fixed 1 paths; re-staged)
probes:
  filename-no-stutter            pass
  no-ascii-banners               pass
  no-inline-import-jsdoc         pass
  no-non-ascii-in-source         pass
  no-pull-citations              pass
  security-md-hash-uniform       pass
  sentence-per-line-md           pass
  test-package-no-main           pass
yarn typecheck         skip (no typecheck script)

result: gate passed.
```

Pre-existing sentence-per-line violations in quoted erights material and the numbered Decisions headings were resurfaced by the gate (prior fixer commits either did not run the gate or the rename-vs-modify diff filter masked them). Fixed in place: split quotes across sentence boundaries; rewrote `### N. Title` headings as `### Decision N: Title` to keep cross-references (*Decisions* section 2, section 3) intact. `yarn install` was needed to enable the yarn format / lint stages of the gate (the prior fixer worked with `--probes-only` since deps weren't installed).

## Inline reply URLs

- r3431577358 (kriskowal, designs/): https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431733389
- r3431584143 (kriskowal, adapter withdrawal): https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431733962
- r3431601526 (erights, view[0]): https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431734857
- r3431636201 (erights, non-ASCII): https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431735847
- r3431624411 (erights, internal-heir.js confirm): https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431736936
- r3431570369 (erights, pass-style note): https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431738080

## Top-level summary comment

https://github.com/endojs/endo-but-for-bots/pull/449#issuecomment-4735942722

@-mentions @kriskowal @erights, lists both commits' addressed asks, names both confirmation-only replies, and reports the gate outcome and the new post-fixer head.

## Recommended next stage

`next: solicitor` for re-run. The design has substantive new content (the `view[0]` worked examples and the @endo/bytes adapter-withdrawal sub-section) plus structural restructuring (designs/ subdirectory). The solicitor's design panel should re-run to surface any further must-fix-loop items or to terminate with un-draft.

PR remains DRAFT per dispatch authorizations (do NOT un-draft; judge/solicitor does that).

Self-improvement: the `sentence-per-line-md` probe fails on pre-existing quoted material and numbered headings when a fixer modifies a markdown file the prior author never gated. This is a recurring class of false-positive (quoted material, numbered headings, line-broken citations). Two possible refinements to file under `skills/pre-push-gates/probes/sentence-per-line-md.sh`'s exemption list: (1) skip lines that are markdown headings (start with `#`); (2) skip lines whose multi-sentence pattern is inside a balanced quote (`"..."` or `*"..."*`). Neither is critical but both would reduce the "fix-a-quoted-asterism-because-the-gate-flags-it" overhead on follow-on fixers. Filed mentally; will surface to gardener if the pattern repeats on the next PR a fixer touches.
