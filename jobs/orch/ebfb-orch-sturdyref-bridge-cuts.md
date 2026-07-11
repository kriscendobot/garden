---
order: serial
children: ebfb-sturdyref-bridge-cut1-bytes-wire-read ebfb-sturdyref-bridge-cut2-ocapn-promotions ebfb-sturdyref-bridge-cut3-daemon-mint-export ebfb-sturdyref-bridge-cut4-ocapn-singleton ebfb-sturdyref-bridge-cut5-foreign-internalization ebfb-sturdyref-bridge-cut6-three-party-roundtrip
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-07-11T23:11:39Z
---

# Orchestration — SturdyRef cross-peer bridge builder cuts 1–6 (design #697)

Serial build-out of the six-cut table in
`designs/sturdy-refs-cross-peer-bridge.md` (PR endojs/endo-but-for-bots#697 @
`5aee6e0b4e2c`), the SturdyRef effort's finish-line bar-1 closer: wire codec
both directions, daemon mint/export, the closely-held `ocapn` singleton,
foreign-locator internalization, and the required two-daemon three-party
mint→pass→enliven round-trip. Each cut stacks its DRAFT PR on the previous
cut's branch, rooted at `build/sturdyrefs-endor-syscall-retention` (#541, CI
green at posting). Serial with halt-on-failure: the stack order is load-bearing
(each cut's base is the prior cut's branch), so a failed cut must halt and
surface rather than let successors build on a missing base. Every cut carries a
load-bearing Distributed Confinement test (no-location, no-identification,
opaque-and-unforgeable). All PRs stay DRAFT until the effort's finish line.
Posted by the hourly press-driver (job endo-sturdyref-press-20260711-230511).
