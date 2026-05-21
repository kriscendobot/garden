---
ts: 2026-05-21T05:21:28Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: fixer
---

# Dispatch: fixer 70fb1e — address turadg review on endojs/endo#3263 via mirror endo-but-for-bots#244

Dispatch root: `dispatches/fixer--70fb1e/`. Project worktree on `endojs/endo-but-for-bots@chore/eslint-numeric-separators-style-master` (head `0739b4f8cd8851ccca09e6e2053f63ab3765b11a`).

Maintainer directive (2026-05-21T05:18Z): *"Please respond to the feedback posted at https://github.com/endojs/endo/pull/3263 with a fixer dispatched to https://github.com/endojs/endo-but-for-bots/pull/244. I am expecting selective override of the lint rule for cases where it decreases legibility, and also a switch to two byte grouping for hex literals, provided that the lint rule can be configured in that way."*

## Context

PR endojs/endo#3263 (`chore(eslint-plugin): require underscore-delimited groups in numeric literals`) introduces `eslint-plugin-unicorn`'s `numeric-separators-style` rule to the `@endo/internal` preset. Current config groups hex by **2-digit groups (bytes)**; decimal 5+ digits in 3-digit groups; binary/octal in 4-digit groups. The autofix has run across the codebase.

Turadg's review on the upstream PR (2026-05-15T14:31Z, COMMENTED, head `512438a275bbcebdaa81eafa34c324af22f5197a`) leaves 9 inline comments. The substantive thread:

- **Hex grouping is too tight at 2.** *"I find the pairs harder to read that quadruplets. Consider groups of four."* (`packages/bundle-source/cache.js` `0xff_ff_ff_ff`)
- *"Another case in point of four-segment reading better"* (`packages/cjs-module-analyzer/index.js` `0xff_ff`)
- *"What's salient here is the length and this is harder to count than groups of four."* (`packages/marshal/src/encodePassable.js` `0xff_ff_ff_ff_ff_ff_ff_ffn`)
- *"Another case for fours: the comment above is in fours. The literal should match"* (`packages/ocapn/src/syrup/encode.js` `0xd8_00`, where the doc-comment refers to `U+D800–U+DFFF`)
- **Mnemonic-breaking hex literals.** `packages/hex/test/{decode,encode}.bench.js` use the seed `[0xb0b5c0ff, 0xeefacade, 0xb0b5c0ff, 0xeefacade]` — readable as "BOBSCOFF EEFACADE" mnemonics. Turadg: *"These visually break the mnemonic. Please suppress this line or file"*, *"Ditto re mnemonic"*. Note: even at groupLength=4 these become `0xb0b5_c0ff` `0xeefa_cade`, which still breaks the mnemonic; these specifically want **eslint-disable**, not just regrouping.
- **Bigint test literals that must visually match an adjacent decimal string.** `packages/cli/test/number-parse.test.js` and `packages/marshal/tools/marshal-test-data.js` compare a literal like `9_007_199_254_740_993n` to a string `'9007199254740993'`. The reader is checking the digit sequence matches — separators in only one side defeat that. Turadg: *"This is worse. The reader wants to verify the numeral sequence matches the above. Consider suppressing the rule on this file"*, *"Ditto the comparison point"*. These want **eslint-disable** on those specific lines or files.
- **`5000` is not grouped.** `packages/cli/src/commands/log.js` reverts `5_000` to `5000`. Turadg: *"Why prefer no underscore for thousands?"* — this is the rule's `number.minimumDigits` default (5). Decisions about that threshold are out of scope; **leave as-is** unless trivially configurable to `number.minimumDigits: 4` while also satisfying the rest of the review. Probably don't change.

The maintainer's distillation of all this: (1) switch hex to **two-byte (4-hex-digit) groups** if the unicorn rule's `hexadecimal.groupLength` is configurable, (2) **selectively suppress** the rule for the legibility-degrading cases above (mnemonic literals; decimal/bigint literals adjacent to comparison strings). Do **not** blanket-disable on all test files; do **not** drop the hex requirement entirely. Turadg's review states "Consider omitting the rule for test files and removing the hex requirement" as suggestions — we are choosing a tighter response.

## Task

### Phase 1: reconfigure hex grouping in `@endo/eslint-plugin`

Investigate `eslint-plugin-unicorn`'s `numeric-separators-style` rule options at the version pinned in this PR (the changeset notes `eslint-plugin-unicorn@^56.0.1`). The rule accepts an options object of the shape `{ hexadecimal: { onlyIfContainsSeparator: false, minimumDigits: 0, groupLength: N }, binary: {…}, octal: {…}, number: {…} }`.

- If `hexadecimal.groupLength: 4` is supported at the pinned version, edit the preset (the file that introduces the rule in this PR — likely `packages/eslint-plugin/configs/internal.{js,cjs}` or wherever the PR landed it; survey first) to set `hexadecimal.groupLength: 4` while keeping decimal `number` defaults (3-digit groups, minimumDigits 5) and binary/octal defaults intact.
- Then run `yarn lint --fix` (or `yarn lint:fix`, whichever exists at the repo root) to autofix every hex literal across the tree from 2-digit to 4-digit groups.
- If for some reason the option is not configurable that way at this version: **stop, report the gap**, and leave the rule at the current 2-digit setting. Proceed to Phase 2 anyway (the selective overrides are independent).

This is one commit. Conventional-commit subject: `chore(eslint-plugin): group hex digits by two bytes`. Include all autofix-mutated files in that single commit (the rule rewriting touches many files; one mechanical commit is fine here).

### Phase 2: selective overrides where the rule reduces legibility

Add `/* eslint-disable unicorn/numeric-separators-style */` (file-scope) or `// eslint-disable-next-line unicorn/numeric-separators-style` (line-scope) in the following places. Prefer **line-scope** when the file otherwise benefits from the rule; use **file-scope** only when the whole file's intent (e.g. all literals in a benchmark seed table) is mnemonic.

- `packages/hex/test/decode.bench.js` — the `defaultSeed` line(s) holding the BOBSCOFF / EEFACADE mnemonic. Line-scope is sufficient (the file has only one such literal pattern). After your change, the literal returns to `[0xb0b5c0ff, 0xeefacade, 0xb0b5c0ff, 0xeefacade]`.
- `packages/hex/test/encode.bench.js` — same shape, same fix.
- `packages/cli/test/number-parse.test.js` — the lines comparing a bigint literal to its string-digits form. Line-scope on the two affected lines (the `parseBigint('9007…993')` / `parseBigint('1234…7890')` pairs); the rest of the file may keep the rule. After your change, the bigint literals return to `9007199254740993n` and `123456789012345678901234567890n` so they visually match the string arguments.
- `packages/marshal/tools/marshal-test-data.js` — the line comparing the bigint to `digits: '9007199254740993'`. Line-scope. Literal returns to `9007199254740993n`.

Two commits, one per package boundary, is cleanest:
- `chore(hex): exempt mnemonic seed literals from numeric-separators rule`
- `chore(marshal,cli): exempt comparison literals from numeric-separators rule`

Or a single commit `chore: exempt mnemonic and comparison literals from numeric-separators rule` is fine if you'd rather keep it one commit. Your call.

### Phase 3: validate

- `yarn lint` from the repo root must pass (0 errors, allowing pre-existing warnings unrelated to this PR).
- If the workspace has a build step that exercises the hex bench (`yarn workspace @endo/hex test:bench` or similar), confirm the mnemonic literals still parse to the same values they did before — but a JS-level confirmation isn't needed; the literals are syntactically identical to pre-rule master.

## Per-action authorization

- Standing on `endojs/endo-but-for-bots`: push to `chore/eslint-numeric-separators-style-master`.
- READ-ONLY on `endojs/endo` and everywhere else. No comments.

## Out of scope

- Do not open a new PR; PR #244 already exists upstream of this branch and the push updates it. (The mirror's upstream relationship to endojs/endo#3263 is the maintainer's concern, not yours.)
- Do not relitigate the `5000` vs `5_000` thread; leave the rule's `number.minimumDigits` default alone.
- Do not blanket-disable the rule on all test files (turadg's first-pass suggestion). The maintainer's directive supersedes that with selective overrides.
- Do not touch the changeset entry or the plugin's peer-dependency declaration.
- Don't merge, don't un-draft, don't post comments.

## Report

≤ 400 words:
1. Whether `hexadecimal.groupLength: 4` is configurable at the pinned `eslint-plugin-unicorn` version (yes / no / cite docs URL or rule schema).
2. The commits you landed (subjects + final head SHA after push).
3. The selective-override sites (file + line range for each).
4. `yarn lint` outcome (0 errors expected; flag any non-trivial residue).
5. Anything that surprised you in the autofix re-run after the groupLength change (e.g. did Prettier re-wrap any lines that the original PR also had to reflow?).
6. One-line `Self-improvement: ...`.
