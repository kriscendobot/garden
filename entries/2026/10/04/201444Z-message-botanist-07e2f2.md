---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-04T20:14:46Z
---
# Dependabotany — PR 1421 terminal REJECT

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/1421
package: @babel/traverse 7.28.6 -> 8.0.6
head: 32bb50f190ce85c7a096f84dc89757ec2fbfe8e2
verdict: REJECT (incompatible)
disposition: verdict comment posted and pull request closed

Live declaration proof: root `package.json` supports Node `^20.17.0 || >=22.9.0` (floor 20.17.0); the four changed package manifests request `@babel/traverse` `~8.0.6`; the npm registry manifest for `@babel/traverse` 8.0.6 requires Node `^22.18.0 || >=24.11.0`. The dependency excludes the project's supported floor. This is terminal; there is no active embargo row or maturity date for this PR.

Self-improvement: nothing this time.
