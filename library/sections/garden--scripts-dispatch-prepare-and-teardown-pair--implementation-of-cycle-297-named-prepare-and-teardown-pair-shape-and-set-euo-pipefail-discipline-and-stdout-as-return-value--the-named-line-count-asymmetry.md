---
title: §the-named-line-count-asymmetry-explained (first-explicit-observation)
section-slug: garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value
source-slug: garden--scripts-dispatch-prepare-and-teardown-pair
url: https://github.com/kriskowal/garden/blob/main/scripts/dispatch-prepare.sh
authors: [Endo project (collective; the garden's named-role-as-author convention)]
repo: kriskowal/garden
path: scripts/{dispatch-prepare.sh, dispatch-teardown.sh}
total-lines: 111 (65 + 46)
ingest-cycle: 298
ingest-date: 2026-06-11
lane: chat
scope: full
parent: garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value
---

Prepare IS 65 lines; teardown IS 46 lines. **§the-named-asymmetry-IS-the-named-rollback-overhead**: prepare has named-roll-back-on-failure code that teardown doesn't need (because teardown's "rollback" IS just exiting; nothing to undo).

§the-named-line-count-IS-NOT-the-substance (extends cycle 288's §the-line-count-IS-NOT-the-substance observation): here the line count *does* reflect substance — prepare has more responsibilities (rollback + bare-clone-check).
