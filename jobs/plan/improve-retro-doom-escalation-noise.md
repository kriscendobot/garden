---
gate: deferred
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 1
doomed_at: 2026-09-17T19:23:14Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-17T19:23:14Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/reaper.sh
Retro jobs (base suffix `-retro`, minted by comment-watcher.sh's mint_retro as best-effort second-loop telemetry) are being escalated through the same split-eligible + maintainer-inbox-notice disposition as ordinary high-value jobs when their sole backed-off retry fails. On 2026-09-17 alone, 6 of 10 requeue-exhausted doom notices sent to the maintainer inbox were `-retro` jobs (kriscendobot-minion.town-pr32/56/62/69-review-*-retro, kriscendobot-garden-pr72-review-*-retro, endojs-endo-but-for-bots-pr982-*-retro), spread across 11:23–18:23Z — disproportionate given retros are a small fraction of job volume. comment-watcher.sh's own design comments (mint_retro, write_retro_body) already treat a lost retro as low-stakes derived telemetry ("costs one data point", "best-effort second loop, NOT freezing the cursor"). Harden reaper.sh's doom-disposition logic so a job whose base matches `*-retro` on requeue-exhaustion is dropped/logged quietly (or given more retry headroom before park+notify) instead of going through the full mark-split-eligible maintainer-inbox surfacing — consistent with how the same design already treats a lost retro-mint attempt. Keep the split-eligible parking path for every other job class unchanged.
