---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-06T20:18:22Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1172 REJECTED (closed)

Botanist review of Dependabot PR #1172, `@babel/parser` 7.x → 8.0.4 (npm ecosystem), auto-posted by the Dependabot watcher. Base `llm`.

**Verdict: REJECT — PR closed.** Terminal; no embargo row or recheck wiring. Reopen or supersede only as part of a deliberate Babel 8 adoption that updates the project's Node support policy.

- Base census found direct parser ranges `~7.29.3` in evasive-transform, module-source, and ses-test and `~7.28.3` in parser-pipeline, so 8.0.4 was a genuine forward major, not superseded. Watcher preflight found no sibling moving parser.
- Full incoming moved set: `@babel/parser@8.0.4`, `@babel/types@8.0.4`, `@babel/helper-string-parser@8.0.0`, and `@babel/helper-validator-identifier@8.0.4`; all MIT, no lifecycle scripts, npm provenance-attested, and no new package name. Freshest publication was parser at 2026-07-09T08:49:47Z; maturity floor 2026-07-16T08:49:47Z was past.
- Dedicated scripts-disabled install completed (`WARM-CACHE built`, lock hash `704fa932b058`). Published-artifact and upstream-source review found the expected ESM/AST/grammar changes and no telemetry, network, dynamic loading, or process spawning; the parser CLI only reads its named input file.
- OSV and GitHub advisories returned zero for every exact moved version and outgoing parser 7.28.6/7.29.3. Yarn audit found no moved-set advisory; Babel's open issue search found no compromise report.
- The unmodified head failed three dynamic-import module-source tests because Babel 8 changes the default AST from `CallExpression(Import, ...)` to `ImportExpression`. A mechanical compatibility repair was pushed as `a67e2754d`, rebased to `5fd232706`: all production parser adapters explicitly preserve the Babel 7 shape with `createImportExpressions: false`. Before/after regression evidence was 3 failures → 156 passes (2 expected failures); additional local suites passed 52 evasive-transform, 70 parser-pipeline (1 expected), and 160 ses-test (1 expected). Browser, build, zizmor, and Hermes CI were green when the independent rejection became conclusive.
- Blocking incompatibility: the repository advertises Node `^20.17.0 || >=22.9.0`, but every incoming Babel 8 package explicitly supports only `^22.18.0 || >=24.11.0`. A Node 20.17 smoke probe happened to work for the sampled dynamic-import call path, but cannot establish support outside upstream's declared engine range. Raising the Node floor and coordinating parser/generator/traverse/types is a maintainer-level compatibility decision, not a mechanical bump repair.
- Structured verdict: https://github.com/endojs/endo-but-for-bots/pull/1172#issuecomment-5561898274

No precise one-shot was created. The existing project daily backstop requires no mutation for this terminal row.

Self-improvement: nothing this time.
