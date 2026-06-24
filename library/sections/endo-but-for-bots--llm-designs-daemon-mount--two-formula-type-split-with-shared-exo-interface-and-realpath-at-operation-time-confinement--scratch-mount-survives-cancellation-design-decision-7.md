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
title: §Scratch-mount-survives-cancellation (Design Decision 7)
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

> *Scratch mount directories survive cancellation.
> Cancelling a scratch-mount formula does **not** delete
> the backing directory. ... Only GC (unreachability)
> triggers cleanup, ensuring intentional deletion requires
> removing all pet-name references.*

§Cancellation-is-not-deletion. §An-agent's-workspace-should-
not-be-destroyed-by-a-transient-daemon-restart-or-formula-
re-evaluation. §Trade-off-named: §disk-usage-mitigated-by-
GC-when-formula-becomes-unreachable.

§Intentional-deletion-requires-removing-all-pet-name-
references is the §explicit-confirmation pattern (sibling
to cycle 164's §resetStorage-conflict-guard from ocap-
kernel — both encode §single-mistake-cannot-destroy-state).
