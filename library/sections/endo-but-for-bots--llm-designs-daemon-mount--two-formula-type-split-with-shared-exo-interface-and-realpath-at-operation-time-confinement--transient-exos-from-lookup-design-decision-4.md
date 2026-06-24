---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_path: designs/daemon-mount.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 166
lane: designs
status: current
title: §Transient-exos-from-lookup() (Design Decision 4)
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

> *`lookup()` returns transient exos, not formulas.
> Navigating a mount's directory structure should be
> lightweight and not pollute the formula store with entries
> for every subdirectory visited.*

§Transient-exos-share-the-parent's-confinement-root and are
§garbage-collected-normally-by-the-JS-runtime.

§Two-tier-naming: formulas for §things-the-user-named;
transient-exos for §things-the-system-needed-to-fabricate-
mid-call. §Don't-pollute-the-formula-store-with-internal-
navigation-state.

§Cycle-156's-finalize.js-WeakValueMap pattern is the
mechanism that makes this work: §exos-can-be-collected-
when-no-one-holds-them; the formula store doesn't observe
them.
