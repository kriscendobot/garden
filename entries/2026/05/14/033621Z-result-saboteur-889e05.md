---
ts: 2026-05-14T03:36:21Z
kind: result
role: saboteur
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: panel-saboteur
refs:
  - entries/2026/05/14/032940Z-dispatch-liaison-535ed3.md
---

# Saboteur findings on PR #243

Review URL: https://github.com/endojs/endo-but-for-bots/pull/243#pullrequestreview-4287059851

Posted as `--comment` (not `--request-changes`) because the PR is self-authored by `kriscendobot`. The body carries an explicit "Must-fix before merge" heading so the orchestrator's dispatch matrix can key on it. Verdict equivalent: request-changes.

Attack count: 6. Split: 2 must-fix, 2 should-fix, 2 out-of-scope.

## Hex-grouping verdict

The dispatch entry's specific question: does `groupLength: 2` for hexadecimal match the maintainer's "presumably groups of four"? **No.** The unicorn rule's `groupLength` is "digits per group between separators". `groupLength: 2` gives `0xAB_CD_EF` (byte grouping); `groupLength: 4` gives `0xABCD_EF12` (nibble-aligned, IPv4-byte / 16-bit-word boundaries). The autofix has therefore produced byte-grouped hex throughout the codebase, including on canonical 32-bit / 64-bit magic constants: `0xff_ff_ff_ff`, `0x1_00_00`, `0xfc_00`, `0xdc_00`, `0xd800` -> `0xd8_00`, `0xdfff` -> `0xdf_ff`, CRC-32 polynomial `0xedb88320` -> `0xed_b8_83_20`, IEEE-754 canonical NaN `0x7ff8000000000000n` -> `0x7f_f8_00_00_00_00_00_00n`. None of these are byte-addressed values; the natural grouping for all of them is groups of four. Flagged as must-fix item 1.

## Other findings

- Lint job is currently FAILING on the PR head SHA (`08d55650e`): `packages/ocapn/test/_util.js:145:53` trips the rule with "Invalid group length in numeric value". The autofix missed at least one site. Flagged as must-fix item 2 (the juror also has CI on its radar per the sister dispatch).
- `onlyIfContainsSeparator: false` rewrites canonical magic constants (CRC-32 polynomial, UTF-16 surrogate-range boundaries in `pass-style/src/string.js`, IEEE-754 NaN encodings in `marshal/src/encodePassable.js` and `ses/src/tame-nan-sidechannel.js`). Recommended `onlyIfContainsSeparator: true` for the hex slot once the group-length fix lands. Should-fix item 3.
- `packages/cjs-module-analyzer/index.js` is generated code (header comment names the generator) and the autofix has rewritten four integers in `astralIdentifierStartCodes` / `astralIdentifierCodes`. Next regeneration will revert. Either an eslint-disable block or a config override is needed. Should-fix item 4.
- ESLint-9 / unicorn-v64 upgrade path is not named in the changeset. Out-of-scope item 5.
- Decimal autofixes spot-clean across the 83-file diff; no false positives. Out-of-scope confirmation item 6.

## Notes for the panel

The juror's sister dispatch covers substance (rule wiring placement, unicorn-v56 pin rationale, autofix impact, changeset framing) and will catch the lint failure too. My slot is the hex-grouping misconfiguration and the readability regressions on canonical hex constants. The fixer's must-fix list should include: flip `groupLength: 2` -> `4`, re-autofix, fix the missed site in `_util.js`, and decide on the `onlyIfContainsSeparator` and the generated-code carve-out.

Self-improvement: the `saboteur-adversarial-review` catalog's "rootfs-derived environment derivation" entry covers a class of attacks; this pass exercises a different class (rule-configuration mismatch between maintainer intent and rule semantics on a multi-file autofix). A catalog entry for "config-semantics audit: does the rule option mean what the maintainer's plain-English framing implies?" would fit the pattern once a second similar PR surfaces. Filing as a notes-from-the-field candidate.
