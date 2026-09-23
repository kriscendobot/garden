---
source: designs/daemon-checkin-checkout.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-checkin-checkout.md
source_path: designs/daemon-checkin-checkout.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 168
lane: designs
status: current
title: §Decision-1-CLI-side-formulation-not-daemon-side
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

> *Checkin builds formulas from the CLI side, not the
> daemon side. The CLI walks the local directory ... the
> daemon does not need filesystem walking logic. This keeps
> the daemon focused on formula management and avoids
> giving it ambient filesystem access.*

§Capability-security-applied-at-the-architectural-axis:
§don't-grant-daemon-ambient-FS-access. The CLI already has
filesystem access (it runs as the user). The daemon
shouldn't need it for content ingestion. §Push-the-FS-side-
to-the-component-that-already-has-FS-authority.

§Cycle-166's-§realpath-at-operation-time-confinement is
the *operation-time* discipline for the mount; this is the
*architectural-time* discipline for daemon design.

§Daemon-only-needs-one-new-method (`formulateReadableTree`
or `storeTree`). §Minimal-daemon-API-surface-expansion.
