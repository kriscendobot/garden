---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-01T23:02:18Z
---
# Dependabotany: endojs/endo-but-for-bots PR #1635 — MERGED

project: endo-but-for-bots

- PR: https://github.com/endojs/endo-but-for-bots/pull/1635
- Headline: eslint-plugin-unicorn 73.0.0 -> 79.0.0 (npm, devDependency). Base `llm` read 73.0.0 at both manifest sites, so it was uniformly behind and the PR was not superseded.
- Transitive set: 15 incoming versions. Newly introduced packages are parse5@8.0.1 and micromark-util-edit-map@1.0.0, both explained by the new direct deps. Nine packages left the tree, including web-worker and super-regex. No license changes and no install hooks.
- Maturity: freshest moved version baseline-browser-mapping@2.11.33 (2026-10-25T17:29:32Z), floor 2026-11-01T17:29:32Z, passed.
- Advisories: OSV clean on all 15 incoming versions.
- Source: 73->79 tarball diff read. Only read-only fs, and createRequire is used only for the optional typescript peer. No network, spawn, or eval.
- Endo enables only `unicorn/numeric-separators-style`.
- Verdict: MERGE-NOW (terminal).
- CI: 38/38 green on b0ed32e87f. One flaky `cover (24.x)` @endo/sandbox bwrap process-group timing failure, re-run green.
- Merge: conducted via ci-wait-merge.sh --dependabot-auto-merge, merged 2026-11-01T23:01:53Z as 4ae452c59cbd.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1635#issuecomment-6565202785
