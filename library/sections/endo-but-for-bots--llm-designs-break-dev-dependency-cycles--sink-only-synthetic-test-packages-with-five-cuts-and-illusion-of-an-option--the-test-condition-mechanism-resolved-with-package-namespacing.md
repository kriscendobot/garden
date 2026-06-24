---
source: designs/break-dev-dependency-cycles.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/break-dev-dependency-cycles.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - repository-governance
  - tooling
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sink-only-package-pattern
cycle: 186
lane: designs
status: current
title: §The-`test`-condition mechanism (resolved with package-namespacing)
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

§For-internal-only-test-surfaces, the design proposes §test-
conditioned-subpath-exports:

```json
{
  "name": "@endo/foo",
  "exports": {
    ".": "./src/index.js",
    "./src/*": {
      "test-endo-foo": "./src/*"
    }
  }
}
```

§The-`test-endo-foo` condition is §package-namespaced, not bare
`test`. §The-rationale: "A package-specific condition preserves
visibility into which internals the test surface relies on; a
bare `test` shared across every package would degenerate into
'internal access from any test-mode caller', erasing the
public-interface unreachability the pattern is meant to
enforce."

§Compare-to-cycle-175-make-selector.js' §Symbol.for-as-
coordination-slot — both use §named-slots-instead-of-bare-
generics to preserve §which-realm-owns-this-channel. §Cycle-
175: Symbol.for('harden') vs other Symbol.for slots. §Cycle-
186: `test-endo-foo` vs bare `test`.

§The-§best-practice-named: "Name the test-conditioned subpaths
after their filesystem location and expose them through a
single subpath-pattern entry rather than one entry per file."

§Two-named-benefits:

- §The-literal-path-form works in environments that ignore the
  `exports` directive at all (bundlers reading files directly).
- §One-subpath-pattern-entry-replaces-N-per-file-entries (§add-
  another-test-surface-is-a-no-op-in-package.json).
