---
ts: 2026-05-14T03:29:40Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: target
---

# Dispatch: saboteur reviews PR #243 (jury panel, member 2 of 2)

Dispatch root: `dispatches/saboteur--review-243--20260514-032940--535ed3/`. Sister: juror (`a9d01e`).

**Per-action authorization**: standing on endo-but-for-bots.

## Task

Adversarial review of #243 (underscored-thousands ESLint rule + 83-file autofix). The saboteur looks for:

- False-positive autofixes the builder missed (numeric-looking content in strings, regex char classes, JSDoc examples, comments, embedded JSON, fixture data, etc.).
- Behavioral changes the autofix may have introduced (e.g., a number stripped of separators that previously rounded a certain way — unlikely but worth probing).
- Rule-configuration footguns: did the chosen `minimumDigits: 5` / hex `groupLength: 2` config match what the maintainer asked for? The maintainer's framing was "groups of thousands" (decimal) and "presumably groups of four" (hex). `groupLength: 2` for hex means groups of two hex digits, not four — that may be wrong.
- Future-proofing: ESLint 9 compatibility (the builder pinned unicorn to v56 as the last ESLint-8-compatible line; what's the migration path when the project moves to ESLint 9?).

## Out of scope

- No fixer dispatch from here.
- No comments outside #243.

## Result entry

`journal/entries/2026/05/14/<HHMMSS>Z-result-saboteur-<short-id>.md`: review URL, adversarial findings, hex-grouping verdict (does `groupLength: 2` match the maintainer's "groups of four"?), self-improvement.

## Return

≤ 400 words: review URL, adversarial findings, the hex-grouping verdict.
