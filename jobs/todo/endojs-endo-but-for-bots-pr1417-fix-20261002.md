---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix the red lint/typecheck legs on endojs/endo-but-for-bots#1417

This PR's gauntlet HALTED at the clean stage (CI red) — see
`jobs/tada/.../build-confined-application-makers-p1-20261002-gauntlet-clean`'s
report for the full diagnosis, already done for you:

`packages/platform/src/fs/tree-read-powers.js` types its `tree` parameter as
`@param {unknown}`, so `E(tree).lookup` and `E(tree).has` fail typecheck
(`TS2339`, lines ~151/174/179) in `lint` and both `viable-release` legs. Give
`tree` a real remotable type (a `ReadableTree`/`Mount`-shaped reference with
`lookup`/`has`) rather than `unknown` or a loose cast — match whatever type
the rest of the `@endo/platform` fs surface already uses for this capability
shape (check `designs/npm-registry-as-directory-tree.md` /
`designs/fs-interface-consolidation.md` / `designs/fs-interface-reconciliation.md`
on `llm` if nothing local already defines it).

The `test (22.x, macos-15)` leg's ava timeouts/"Failed to exit" in unrelated
packages (`channel`, `factory`, `lifecycle`, `snapshot-hash`) is a known
pre-existing cross-PR macOS flake, not caused by this PR — re-run that leg
after the type fix rather than investigating it.

Push the fix, confirm CI is green (`ci-wait-merge.sh`), and this PR's gauntlet
(`build-confined-application-makers-p1-20261002-gauntlet`) will resume
automatically — it's part of a 5-phase serial orchestration
(`build-confined-application-makers-orch-20261002`) that halts on any child
failure, so clearing this unblocks the rest of the stack.
