---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_path: packages/harden/make-selector.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 175
lane: chat
status: current
title: §Why-the-IIFE-not-just-immediate-call
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

§Race-window: between this module's load and `harden`'s
first call, another module might install harden. §Don't-
race-at-module-load; §race-at-first-call.

§Cycle-138's-safe-promise has a similar §defer-to-first-
use pattern but for different reasons (avoid Promise.
prototype reentrancy at load time). §Two-different-
reasons-for-deferred-evaluation.

§The-IIFE-makes-the-tier-walk-cheap-after-first-call:
§selectedHarden-is-the-fast-path.
