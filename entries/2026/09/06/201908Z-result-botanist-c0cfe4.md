---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-06T20:19:09Z
---
# Botanist result: endojs/endo-but-for-bots PR #1172

Verdict: **REJECT**, executed. Posted the structured verdict at https://github.com/endojs/endo-but-for-bots/pull/1172#issuecomment-5561898274 and closed the PR at head `5fd2327062d620ce952d1e2db74d8896722665ce`.

The scripts-disabled install, upstream/published-source inspection, four-version transitive enumeration, maturity check, OSV/GHSA/Yarn advisory checks, issue-tracker check, and local suites found no supply-chain or advisory concern. The maturity floor (2026-07-16T08:49:47Z from `@babel/parser@8.0.4`) had passed.

The original head exposed a Babel 8 AST-default break (three dynamic-import tests failed). I pushed the mechanical compatibility repair (`createImportExpressions: false`) as `a67e2754d`, later rebased by the conductor guard to `5fd232706`; the affected suite then passed 156 tests with two expected failures, with additional suites passing 52, 70, and 160 tests. The terminal blocker is engine compatibility: the repository supports Node `^20.17.0 || >=22.9.0`, but all incoming Babel 8 packages support only `^22.18.0 || >=24.11.0`. Raising that floor and coordinating the Babel toolchain is a maintainer design decision. No embargo scheduling was required.

Dependabotany ledger entry posted as `entries/2026/09/06/201820Z-message-botanist-90ba9c.md`.

Self-improvement: nothing this time.
