---
title: §the-three-named-test-files for the three-test-mode pattern (first-explicit-observation)
section-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
source-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/compartment-mapper/designs/subpath-pattern-replacement.md
authors: [Endo project (collective)]
status: (no explicit metadata table)
ingest-cycle: 287
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 271
parent: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
---

Three test files for **three execution modes**:

- `subpath-patterns-node-parity.test.js` — runs fixtures under plain Node.js using dynamic `import()`.
- `subpath-patterns-node-condition.node-condition.test.js` — runs under `--conditions=blue-moon` via ses-ava.
- `subpath-patterns.test.js` — runs fixtures through the `scaffold()` harness.

**§the-`.node-condition.test.js`-double-extension-as-named-test-mode-marker** (first-explicit-observation): the file suffix `.node-condition.test.js` is a *naming convention* that signals "this test needs the node-condition harness configuration". §the-file-extension-IS-the-test-mode-discriminator.

§three-named-execution-modes-for-the-same-fixture (plain Node + node-with-condition + scaffold-harness); §the-scaffold-harness-exercises-seven-named-functions (loadLocation + importLocation + makeArchive + parseArchive + writeArchive + loadArchive + importArchive).
