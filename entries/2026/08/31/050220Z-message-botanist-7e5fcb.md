---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-08-31T05:02:22Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — PR #1095 terminal MERGE-NOW

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/1095

## Verdict: MERGE-NOW, executed

- Base-ref census found the live `llm` lockfile below the proposed target:
  `eslint-plugin-jsdoc` resolved at 62.9.0 and 63.2.0, versus target 64.2.1.
  The watcher had already established that no sibling Dependabot PR moved the
  same package, so this was not superseded.
- The scripts-disabled project provisioning completed and reported
  `YARN_ENABLE_SCRIPTS=false`; the installed package has no install lifecycle
  hook (`prepare: husky` is the only publish-time lifecycle hook).
- Full incoming moved-version set: `eslint-plugin-jsdoc@64.2.1`,
  `@es-joy/jsdoccomment@0.95.1`, `jsdoc-type-pratt-parser@9.1.2`,
  `comment-parser@1.4.8`, `spdx-expression-parse@5.0.0`, and
  `are-docs-informative@0.1.1`. The lockfile also removes the now-unused
  `@typescript-eslint/types@8.59.2` and `object-deep-merge@2.0.0` resolutions.
  No package name is newly introduced. Licenses remain BSD-3-Clause for the
  headline and MIT for all moved transitives.
- OSV and the GitHub Advisory API returned no advisory for any incoming,
  outgoing, or removed-only moved version. `yarn npm audit --all --json` had no
  finding naming a moved package; its nonzero result was from unrelated existing
  workspace findings.
- Source review of the headline 62.9.0...64.2.1 upstream compare and all
  installed incoming transitive packages found no new network, process-spawn,
  dynamic-eval, or install-hook behavior. The headline's v64 ESM-only break is
  compatible with the sole consumer, the ESM import in
  `packages/eslint-plugin/src/index.js`.
- Freshest moved release was `eslint-plugin-jsdoc@64.2.1`, published
  2026-08-17T23:59:25.412Z. Its maturity floor was
  2026-08-24T23:59:25.412Z, already passed at review time. No moved version was
  less than 24 hours old.
- The maintainer-requested retcon separated the manifest and lockfile commits.
  The conductor rebased them onto live `llm` at ccdc0b2eb65; the resulting head
  `5df9eebd4ae7a7ae56ba0cf891dbd6177101c983` retained the reviewed net patch
  (`git patch-id --stable` 7e2bb2fd47f98bd22edaf3480035fbb44c1c857e).
- All 24 check runs on that exact head succeeded (CI run 33357427784 plus build,
  browser-tests, and zizmor companion runs). The Dependabot conductor path then
  merged the PR onto `llm` at 2026-08-31T05:01:37Z; merge commit
  `a2ad2cfc1ff6f95a15c056a69426a5c5407e1491`.

No embargo schedule applies to this terminal disposition.

Self-improvement: nothing this time.
