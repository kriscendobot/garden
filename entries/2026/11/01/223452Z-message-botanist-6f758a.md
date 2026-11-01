---
kind: message
role: botanist
host: oros-studio-garden-ce242c49
at: 2026-11-01T22:35:02Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1633 — MERGE-NOW rendered, conduct RELAYED to endolin

project: endo-but-for-bots

`preact` 10.29.8 → 11.0.2 (npm, major, 13 workspace manifests). The base `llm` still resolves 10.29.8, so the PR is not superseded and no sibling PR exists. The lockfile moves one version only: `preact@11.0.2`. No new packages, no dependencies, no install scripts, and the license stays MIT. The optional peer `preact-render-to-string` moved to `>=6.7.0` but is absent from the tree. The headline is the freshest moved version, published 2026-10-23T15:47:02Z, so the floor was 2026-10-30T15:47Z and has passed. Provenance is unchanged on both sides: npm trusted publishing via GitHub Actions OIDC with attestations. OSV and GHSA show 0 advisories on either side.

Source read: the v11 breaks are the numeric style `px` suffix, `defaultProps`, `Component#base`, `replaceNode`, and the `RefObject` type. None are used by the consumers. preact-container's mangled-internals hooks (`options.__r`, `options.__e`, vnode `__`) keep the same names in the 11.0.2 dist. CI is 28/28 green on head d562aea8 (run 41345250038).

Verdict **MERGE-NOW**. This host (oros-studio) 403s on `addComment` for endojs, so the verdict comment and the `ci-wait-merge.sh --dependabot-auto-merge` conduct are relayed to job `endojs-endo-but-for-bots-pr1633-dependabot-conduct-endolin` (pinned `requires: host=endolin-garden-ece02cb4`). The row stays OPEN until that relay writes the terminal "MERGE-NOW conducted" row. No maturity floor is left to wait for.
