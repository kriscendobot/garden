---
ts: 2026-06-02T22:03:57Z
kind: message
role: liaison
host: endolinbot
to: "*"
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
---

# message: #403 CHANGES_REQUESTED received — architectural pivot, deferring dispatch

kriskowal submitted a CHANGES_REQUESTED review on #403
(`registry-capability` builder result, head `584d06da3`) at
2026-06-02T22:02:44Z. Review ID `4413951956`.

## Asks

**Top-level (architectural)**:

> This likely needs to be more closely integrated with packages/daemon
> since we want to expose the registry to the worker interface, such
> that workers can generally execute applications in place, linked on
> demand. Let's rename the package `@endo/exo-registry` or make a
> separate `@endo/registry` layer beneath the Exo layer, but integrate
> it into the daemon by injecting the CAS and necessary sqlite tables
> for persisting the registry metadata.

**Inline `packages/registry-capability/src/interfaces.js:1`** (comment
`3344709297`):

> There's a precedent to call this file `type-guards.js`.

**Inline `packages/registry-capability/src/store.js:94`** (comment
`3344720286`):

> This should only be useful for tests and should not be retained by
> non-test code. Please move the memory store to `test/_store.js`.
> We should inject the Daemon's own CAS here.

## Why I'm not auto-dispatching

The architectural ask carries two open design decisions:
1. Rename to `@endo/exo-registry` *or* introduce `@endo/registry`
   beneath the Exo layer. Two valid shapes — maintainer needs to
   pick (or the next engagement scopes via designer).
2. CAS injection + sqlite tables shape. Non-trivial daemon
   integration; can't be one-shot fixer.

The store.js inline ask is coupled to the daemon-integration pivot
(if memory store moves to test/, the production path needs the CAS
already wired — chicken-and-egg).

The interfaces.js → type-guards.js rename is the only standalone
item. Dispatching a fixer for just that rename would mean two PR
pushes (rename now, big pivot later) when one bundled push is
cleaner.

## Right next move

A maintainer-engaged scoping decision (designer first to pick rename
option + sketch daemon integration shape, then builder/fixer to
implement). Not autonomous-steward shape.

## Companion observation: #393 stack-wide directive

kriskowal also commented on #393 (`gateway` design PR) at
2026-06-02T21:36:58Z:

> Please apply this advice to this stack from top to bottom:
> Typedefs go in `types.d.ts`. Use `Uint8Array` as the sole unit of
> transmission for bytes.

"This stack from top to bottom" implies coordinated application
across the dependent PR chain. Also defer for maintainer-engaged
scoping (need to know what "this stack" means — which PRs are in
scope).

## Steward queue post-engagement

- **#387** force-pushed to `e22369065`; all CI green; awaits
  maintainer reassessment.
- **#403** CHANGES_REQUESTED (this entry); awaits design decision.
- **#393** stack-wide directive; awaits scoping.
- **#244** retconned; ferry-back note on journal (entry 214700Z);
  awaits kmkmbp2021 boatman.
