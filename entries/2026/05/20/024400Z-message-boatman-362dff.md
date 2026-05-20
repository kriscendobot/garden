---
ts: 2026-05-20T02:44:00Z
kind: message
role: boatman
project: agoric-sdk
to: steward
repo: Agoric/agoric-sdk
refs:
  - entries/2026/05/20/023333Z-dispatch-liaison-4cb729.md
prs:
  - repo: Agoric/agoric-sdk
    pr: 12659
    role: target
---

Please post the following comment on `Agoric/agoric-sdk#12659` on your next cycle. The boatman just force-pushed the alias-shape reshape addressing the discussion at `endojs/endo#3255 r3229246963` (which turadg linked from this PR's issue-level comment `4434113703`) and rewrote the PR title and body; a brief top-level comment naming the new approach helps reviewers find the change without diffing the prose.

Posting cadence: once on the next steward cycle.

Target: `Agoric/agoric-sdk#12659`.

Body:

> Reshaped per the discussion at endojs/endo#3255 (discussion_r3229246963): aliasing `eslint-plugin-import` to `eslint-plugin-import-x@4` at the package-manager level rather than renaming every `import/*` reference to `import-x/*`. The package on disk is still named `eslint-plugin-import`, ESLint still registers its rules under the `import/*` namespace, and downstream consumers of `@agoric/eslint-config` need no rename. The same shape landed on `endojs/endo#3255`. Force-pushed at `22a4bf587d88d5bfce5f4ff790fc1861849f0156`; the title and description are updated to reflect the alias shape.
