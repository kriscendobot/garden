---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-15T21:19:47Z
---
# Dependabotany

project: endo-but-for-bots

- PR: endojs/endo-but-for-bots#1666
  head: e461ead16575a2598501a717cc6d84a17b7544e1
  verdict: REJECT
  disposition: closed 2026-11-15T21:18:05Z
  reason: AVA 8.1.2 -> 8.4.0 grouped update leaves the @endo/sandbox test and coverage lanes timing out on Linux and macOS Node 22/24; CI is red. XS baseline and pre-existing zizmor action-comment failures also remain red.
  maturity_floor: 2026-11-15T14:55:20.195Z (ws@8.22.2 published 2026-11-08T14:55:20.195Z)
  advisory_check: OSV both sides of all moved lock entries and yarn npm audit report no moved-package advisory.
