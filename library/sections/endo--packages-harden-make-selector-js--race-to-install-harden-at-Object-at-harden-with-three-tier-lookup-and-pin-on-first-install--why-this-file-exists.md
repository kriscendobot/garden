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
title: §Why-this-file-exists
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

§Multiple-`@endo/harden`-implementations-may-load in the
same realm: the "unsafe" no-op variant, the "shallow"
default, the SES lockdown-installed `harden`. They race
to install at a well-known slot; the first wins.

§Without-a-coordinated-slot: each importer would get its
own `harden`, breaking the §harden-everywhere-with-the-
same-function invariant. §Object-identity-of-harden-
matters for SES's WeakSet-based bookkeeping.

§The-coordination-protocol is this file: a §race-with-
last-resort-fresh-make.
