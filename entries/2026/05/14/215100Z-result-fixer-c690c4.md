---
ts: 2026-05-14T21:51:00Z
kind: result
role: fixer
worktree: dispatches/fixer--c690c4/project
repo: endojs/endo-but-for-bots
project: endo
---

Addressed kriskowal's directive on PR #109 (`feat/syrups-package`) to
replace lingering "syrups" remnants with "syrup-frame".

Three atomic commits pushed to `feat/syrups-package`
(`642ce3fd6` -> `894510bec`):

- `27039b119` refactor(syrup-frame): rename remaining `makeSyrups*`
  identifiers to `makeSyrupFrame*`. Touches `index.js`, `reader.js`,
  `writer.js`, `test/syrup-frame.test.js` in `@endo/syrup-frame`,
  plus the consumer-side import/local-var follow-through in
  `packages/ocapn/src/netlayers/tcp-test-only.js`
  (`makeSyrupsDeframer` -> `makeSyrupFrameDeframer`,
  `makeSyrupsWritingSocketOperations` ->
  `makeSyrupFrameWritingSocketOperations`, local `syrupsReader` /
  `syrupsWriter` vars).
- `41679520d` docs(syrup-frame): README and CHANGELOG reference the
  renamed exports.
- `894510bec` chore(syrup-frame): rename
  `.changeset/syrups-initial.md` to `syrup-frame-initial.md` and
  update the embedded factory names.

Items intentionally NOT renamed:

- the wire-format string `framing: 'syrups'` (and the typedef
  `TcpTestOnlyFraming = 'none' | 'syrups'`, the comparisons
  `framing === 'syrups'`, and the rejection path
  `framing !== 'none' && framing !== 'syrups'`) in `tcp-test-only.js`.
  This is the on-the-wire option identifier, not the package name.
- `Syrup` (capital S) identifiers throughout `packages/ocapn/src/syrup/`
  and the related codec tests (`SyrupSelectorFor`,
  `SyrupStructuredType`, `SyrupSetCodec`, `getSyrupSelectorName`,
  `SyrupString` test-side variable names). These refer to the
  Spritely-defined Syrup data format.
- the design-doc reference `designs/ocapn-tcp-syrups-framing.md`
  (in `reader.js`, `writer.js`, and `README.md` comments). The design
  document describes the wire-format option.
- `.changeset/ocapn-tcp-syrups-framing.md` (filename and body). The
  changeset describes the `framing: 'syrups'` opt-in on the TCP
  netlayer, not the package.
- `packages/ocapn/test/netlayer-tcp-syrups.test.js` (filename, test
  descriptions, debug labels `'syrups-A'`, `'syrups-B'`,
  `'syrups-sniff'`, and payload `'hello syrups'`). This test
  exercises the `framing: 'syrups'` wire-format option end-to-end
  through the JS netlayer; the strings are wire-format thematic
  labels, not package references.

Verification: `packages/syrup-frame` lint clean,
`packages/ocapn` lint clean, all 35 syrup-frame tests pass,
all 285 ocapn tests pass. Did not run `yarn format` separately;
the diff is identifier substitution and tight comment edits.

CI rollup: pushed to `feat/syrups-package`; GitHub checks not yet
reported at observation time. Fixer dispatch ends here per the
dispatch's "one-shot" framing; the steward's standing watcher on
PR #109 will surface CI convergence.

Self-improvement: nothing this time.
