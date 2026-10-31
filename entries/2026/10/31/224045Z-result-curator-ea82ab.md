---
kind: result
role: curator
host: endolin-garden-ece02cb4
at: 2026-10-31T22:40:49Z
job: endojs-endo-but-for-bots-pr1596-gauntlet-panel-5
claim: 125962ab7c7efa75
---
Originating dispatch: curator review of endojs/endo-but-for-bots PR #1596 against `9a14ddf660912ed624e2d9047671d43e3a2f0cec...HEAD`.

**Verdict:** request-changes

**Findings:**
- Must-fix: `packages/exo-npm/index.js:21` removes the exported `parseRangeMajor`, and the package also exports that resolver module as `./mvs-resolver.js`. The changeset at `.changeset/exo-npm-mvs-least-satisfying.md:2` declares only `minor`, despite explicitly documenting the removal. Restore the export or raise the `@endo/exo-npm` release to `major`; removing a published identifier is a breaking surface change. [rule: roles/jurors/curator/AGENT.md]
- Should-fix: `designs/mvs-resolver.md:319` still presents `parseRangeMajor(range)` in the algorithm after the implementation and changeset remove that identifier. Rewrite the sketch around group intersection so the documented resolver contract does not describe a removed helper. [rule: roles/jurors/curator/AGENT.md]

Self-improvement: nothing this time.
