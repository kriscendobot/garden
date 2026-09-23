---
ts: 2026-06-18T07:38:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--cb192c
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/442
  - https://github.com/endojs/endo-but-for-bots/pull/442#discussion_r3433946262
  - https://github.com/endojs/endo-but-for-bots/pull/442#pullrequestreview-4522672586
  - entries/2026/06/18/073100Z-message-queued-fixer-442-content-store.md
---

# dispatch: fixer — #442 content-store relocation (kriskowal CHANGES_REQUESTED)

kriskowal at 07:29:34Z (inline comment id 3433946262) on
`packages/daemon-cas/src/content-store.js`:

> This belongs in the daemon proper since it encodes
> configuration opinions not specific to the CAS
> implementation.

Shepherd f9204c just landed CI fixes (head now `3b427cf2c`).
The fixer can run safely on top.

## Task

In your `project/` worktree at `3b427cf2c`:

1. Read `garden/roles/COMMON.md`, `garden/roles/fixer/AGENT.md`.
2. Read `packages/daemon-cas/src/content-store.js` in full to
   identify configuration-opinion code (likely default
   content-store path, max-bytes, retention policy, or
   similar — code that takes a stance on daemon-specific
   defaults rather than implementing CAS mechanics).
3. Determine where in `packages/daemon/src/` the relocated
   code belongs (probably the daemon's content-store
   initialization in `daemon-node-powers.js` or
   `daemon-persistence-powers.js`).
4. Refactor:
   - Move the configuration-opinion code to the daemon proper.
   - Make `packages/daemon-cas/src/content-store.js` accept
     the configuration as parameters (factory pattern; no
     daemon-specific defaults).
   - Update the daemon's wiring to pass the configuration in.
5. Run `corepack yarn workspace @endo/daemon-cas test` +
   `corepack yarn workspace @endo/daemon test`.
6. Run pre-push-gates.
7. Commit per logical unit:
   - `refactor(daemon,daemon-cas): move daemon-specific content-store config from daemon-cas to daemon`
8. Push to `feat/daemon-cas-extraction` (append-only).
9. Reply inline on comment 3433946262 confirming the fix +
   citing the new commit SHA.

## Authorizations

- Push commits to `feat/daemon-cas-extraction` (append-only).
- Inline reply on comment 3433946262.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT re-request review.
- Do NOT touch other PRs.

## Deliverable

A `result` entry per the standard fixer shape. End your turn
with a concise summary back to the orchestrator.
