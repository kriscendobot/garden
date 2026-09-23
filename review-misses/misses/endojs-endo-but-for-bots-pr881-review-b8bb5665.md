---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr881-review-b8bb5665
verdict: miss
category: security-hardening
pr: 881
cluster: capability-hardening-attenuation
cluster_pattern: An exported client/exo capability reaches review unhardened — no interface guards, runtime-flag (if(readOnly)) attenuation instead of structural POLA, or ambient authority (setTimeout) implying an unconfined module — that the locksmith/warden seats did not flag.
review_at: 2026-07-28T17:23:59Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/881#pullrequestreview-4800107598
identity: endojs/endo-but-for-bots#881:review:4800107598
missed_by: locksmith
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

Contributor questions a separate powers layer in the attenuation design. Part of the same unhardened-attenuation critique the panel did not surface.
