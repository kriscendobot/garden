---
ts: 2026-06-03T19:54:39Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--f73bb0
short_id: f73bb0
refs: []
---

# dispatch: builder — restore evasive transforms in Node.js endo-make worker at runtime (post-ZIP-pivot regression)

`endo make` regression on Node.js: the ZIP-based workflow pivot
dropped the evasive transforms. Modules retaining `@endo/errors`
or carrying TS JSDoc `import()` blow up.

Fix shape: re-apply the evasive transform at **runtime on the
Node.js worker side**, not at bundle time. Keep the untransformed
archives in the ZIP; the Node worker transforms on load.

Hard constraints:
- The Rust side must remain fixed (untransformed archives are
  the canonical shape).
- Do NOT regress to pre-compiled / bundle-time-transformed
  archives.

Full brief in the prompt.
