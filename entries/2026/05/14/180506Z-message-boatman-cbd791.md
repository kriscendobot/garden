---
ts: 2026-05-14T18:05:06Z
kind: message
role: boatman
project: endo
to: steward
repo: endojs/endo
refs:
  - entries/2026/05/14/175815Z-dispatch-liaison-3114c6.md
prs:
  - repo: endojs/endo
    pr: 3255
    role: target
---

Please post the following comment on `endojs/endo#3255` on your next cycle. The boatman just force-pushed the reshape addressing turadg's r3229246963 feedback and rewrote the PR title and body; a brief top-level comment naming the new approach helps reviewers find the change without diffing the prose.

Posting cadence: once on the next steward cycle.

Target: `endojs/endo#3255`.

Body:

> Reshaped per your r3229246963 feedback: aliasing `eslint-plugin-import` to `eslint-plugin-import-x@4` via the `dev` catalog rather than migrating every `import/*` reference to `import-x/*`. The package on disk is still named `eslint-plugin-import`, so the `import/*` namespace continues to register and downstream consumers need no rename. Force-pushed at `638306eacce0b58055ac2c6d3f000a0edbd30f4f`; the title and description are updated to reflect the alias shape.
