---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Triage the Ironhorse `bytecode_decoder` fuzz timeout (endojs/endo-but-for-bots)

Repo: endojs/endo-but-for-bots. The CI `fuzz-ironhorse` lane (tripwire) reported a
libFuzzer **timeout** (one unit ran over 1777s against a 1200s limit) in fuzz target
`bytecode_decoder` (rust/engine/ironhorse-fuzz). Run:
https://github.com/endojs/endo-but-for-bots/actions/runs/39727404537/job/119654508355
(PR #1531 head 6e1d6eb62f7; that PR does not touch rust/engine, and the lane ran only
because that commit edited ci.yml). The reproducer is in the run's uploaded crash
artifact `timeout-1015c4e9cf8a361f98c929653d2023bb8cb70515`; get it from the
artifact, never from the log. Reproduce with
`cargo fuzz run --sanitizer=none bytecode_decoder <artifact>`, then decide whether
the decoder has an unbounded loop or a quadratic path on malformed input. If it is a
real defect, fix it with a regression seed in a draft PR. If it is a harness
artifact, record that and stop.
