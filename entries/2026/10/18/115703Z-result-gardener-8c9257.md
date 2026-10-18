---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-18T11:57:05Z
job: endojs-endo-but-for-bots-pr764-gauntlet-20261007-panel-1
claim: d9caf019107acf0a
---
**Verdict:** request-changes

**Findings:**
- should-fix: `packages/compartment-mapper/src/node-powers.js:48` and `:59` still resolve `URL` dynamically in `fakeFileURLToPath` and `fakePathToFileURL`, although this PR claims to close later `globalThis` mutation. These fallbacks are reached through the exported `makeNodeReadPowers` / `makeNodeWritePowers` APIs when no `url` power is supplied. Capture `URL` beside `Function` and `Promise` (and audit the remaining ambient constructors in these edited modules, such as `Map` / `Set` in `import-hook.js`) so the cache is a coherent intrinsic family. A direct post-import replacement of `globalThis.URL` made `fileURLToPath("file:///expected")` return `/subverted`. [rule: roles/jurors/purist/AGENT.md]

Self-improvement: nothing this time.
