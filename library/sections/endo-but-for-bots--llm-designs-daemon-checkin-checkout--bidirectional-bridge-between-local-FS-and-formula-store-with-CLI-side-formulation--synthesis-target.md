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
title: §Synthesis-target
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

§Bidirectional-bridge-pattern: when two substrates need to
exchange content, design the bridge as §two-symmetric-
commands not as §one-bigger-thing. §Checkin-and-checkout-
are-symmetric in name and shape.

§CLI-side-formulation discipline applies beyond this design:
when adding daemon capabilities, ask §does-the-daemon-
actually-need-the-authority. If the CLI already has it,
§push-the-authority-to-the-client and §keep-the-daemon-
focused.
