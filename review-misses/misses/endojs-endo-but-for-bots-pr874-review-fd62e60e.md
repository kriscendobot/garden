---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr874-review-fd62e60e
verdict: miss
category: security-hardening
pr: 874
cluster: capability-hardening-attenuation
cluster_pattern: An exported client/exo capability reaches review unhardened — no interface guards, runtime-flag (if(readOnly)) attenuation instead of structural POLA, or ambient authority (setTimeout) implying an unconfined module — that the locksmith/warden seats did not flag.
review_at: 2026-07-29T16:19:18Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/874#pullrequestreview-4810551844
identity: endojs/endo-but-for-bots#874:review:4810551844
missed_by: locksmith
severity: major
consolidated_pass: review-retrospective-consolidated-20260804
---

An exported google-sheets client ships with no interface guards and an unhardened API surface; contributor asks "No interface guards? and API surface is not hardened?". A gauntlet ran (pr874-gauntlet) yet the locksmith/warden lens did not flag the unhardened exported capability.
