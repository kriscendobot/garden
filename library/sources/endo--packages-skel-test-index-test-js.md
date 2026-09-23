---
source_kind: source
source_repo: endojs/endo
source_path: packages/skel/test/index.test.js
source_line_range: 1-6
ingested: 2026-06-16
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 366 chat-lane ingest paired to cycle 365 designs-lane
  @endo/skel README. 6-line test file that ships in the
  skeleton template; every derivative inherits this pattern.
  Fourteenth AUTHORED conformant single-body section doc in
  post-refactor era. Fifty-six consecutive non-garden sources
  after the pivot (310-366). §fifty-six-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-skip-
  with-loud-failure-as-placeholder — the test is `test.skip(
  'placeholder', async t => { t.fail('TODO: add tests'); })`.
  TWO complementary moves layered. The `.skip` means CI runs
  the test but doesn't fail on it; the test passes silently.
  The body `t.fail('TODO: add tests')` is what happens when
  the derivative REMOVES the `.skip` — immediate, loud
  failure with a specific TODO message naming the gap. §the-
  named-fail-loud-not-silent-pass as tier-3 meta-pattern. The
  template designs for the moment when the derivative is
  ready to add real tests: removing `.skip` produces a louder
  signal than an empty test body would.

  §The-named-skel-dissolves-design-vs-implementation-boundary
  — the four-shapes-of-design-vs-implementation-arc framing
  (established in cycle 364) presumes the README attempts to
  describe an implementation that lives elsewhere. The skel
  README does not describe an implementation; it IS PART OF
  the blueprint. The README has placeholders for human
  substitution; the package.json has full real values; the
  test file has a skip-marked loud-fail placeholder; the
  index.js is empty. EVERYTHING in skel is template. There
  is no design-vs-implementation relationship to map. §the-
  named-template-dissolves-design-implementation-distinction
  as tier-3 meta-pattern. The four-shapes framing has a
  boundary case here that doesn't add a fifth shape; it
  reveals what the framing presumes.

  §The-named-skel-test-shows-the-canonical-import — line 1
  reads `import test from '@endo/ses-ava/prepare-endo.js';`
  which is LITERALLY the canonical-import-pattern that cycle
  361 ses-ava README recommended and cycle 362 ses-ava
  prepare-endo.js implements. The skel test is the canonical
  import made manifest. Reading skel/test/index.test.js
  answers "what does the canonical import look like in
  practice?"

  §The-named-template-import-as-default-inheritance — every
  derivative inherits this import line unchanged. The
  ses-ava ecosystem propagates through Endo via skel: a new
  @endo/* package starts with ses-ava as its test driver
  because skel does. §the-named-template-propagation-of-
  testing-substrate as tier-3 meta-pattern.

  §The-named-six-line-skel-test — a 1-line import, a blank
  line, and a 3-line test body whose body is one line of
  fail with one line of skip. The minimalism mirrors the
  README's three-line minimalism. The package's design
  density is in the package.json, not in README or test.

  §The-named-async-t-arrow-as-template-default — the test
  uses `async t => {...}` even though the placeholder body
  is synchronous. The derivative is expected to write async
  tests (consistent with @endo's promise-heavy substrate);
  the template sets the default to async to nudge the
  derivative in that direction. §the-named-default-shape-as-
  nudge-toward-convention as tier-3 meta-pattern.

  Relationship to the four-shapes-of-design-vs-
  implementation-arc-from-README-to-source framing
  (established in cycle 364): the skel cycle 365→366 pair is
  NOT a fifth shape. It is the boundary case where the
  design-vs-implementation distinction dissolves. The
  framing's four shapes (ABSTRACTING + UNDERCOUNTING +
  WHAT-VS-HOW + ANALOGY-VS-LITERAL) all presume a README
  describing an implementation; the skel README and source
  are co-blueprint. §the-named-framing-has-a-dissolves-the-
  distinction-boundary-case as tier-3 framing observation —
  parallel to cycle 363's earlier "outside-the-framing"
  observation that cycle 364 promoted to a fourth shape, but
  this one stays a boundary observation rather than becoming
  a fifth shape.

  Closes seven citation arcs: cycle 365 (1, adjacent forward
  pair README → test; reveals the dissolves-the-distinction
  boundary case) + cycle 362 (1, ses-ava prepare-endo.js is
  the LITERAL IMPORT on line 1) + cycle 361 (1, ses-ava
  README canonical-import-pattern resolved as actual import
  in skel) + cycle 360 (1, four-shapes framing finds its
  dissolves-the-distinction boundary case) + cycle 358 (1,
  design-vs-implementation distinction dissolves in skel) +
  cycle 326 (39, pure-naming sibling) + cycle 322 (43,
  @endo/errors not used here either, consistent with the
  testing-minimalism). Pushes citation-arc-closures-in-pivot
  to TWO-HUNDRED-THIRTY-FOUR (227 + 7 net new).
---

6-line test file shipping in the @endo/skel skeleton template; every derivative inherits this pattern. Chat-lane after cycle 365 designs-lane skel README. §the-named-skip-with-loud-failure-as-placeholder (single most structurally interesting move — `.skip` for CI silence + `t.fail('TODO: add tests')` for loud failure on removal). §the-named-fail-loud-not-silent-pass. §the-named-skel-dissolves-design-vs-implementation-boundary — four-shapes framing has a boundary case where the distinction itself dissolves; not a fifth shape but a framing observation. §the-named-skel-test-shows-the-canonical-import (line 1 is the literal cycle 362 ses-ava prepare-endo.js). §the-named-template-propagation-of-testing-substrate. §the-named-async-t-arrow-as-template-default. Seven citation arcs closed.
