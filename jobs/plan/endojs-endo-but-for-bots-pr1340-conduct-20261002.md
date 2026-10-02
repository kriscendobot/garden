---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr1340-weave-20261002
priority: normal
posted_by: producer
posted_at: 2026-10-02T16:31:23Z
---

---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Conduct endojs/endo-but-for-bots#1340 (merge after weave)

kriskowal APPROVED https://github.com/endojs/endo-but-for-bots/pull/1340 with
"Please conduct and build." (review #pullrequestreview-5385258900). Already
un-drafted and base unfrozen to `llm` by `endojs-endo-but-for-bots-pr1340-conduct-20261001`,
which stalled `needs weave` (designs/README.md conflict). Once the weave job
`endojs-endo-but-for-bots-pr1340-weave-20261002` lands, run
`scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1340` from an
isolated project worktree and merge (`--merge`).
