---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr881-review-baf7087b
verdict: miss
category: security-hardening
pr: 881
cluster: capability-hardening-attenuation
cluster_pattern: An exported client/exo capability reaches review unhardened — no interface guards, runtime-flag (if(readOnly)) attenuation instead of structural POLA, or ambient authority (setTimeout) implying an unconfined module — that the locksmith/warden seats did not flag.
review_at: 2026-07-28T15:48:02Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/881#pullrequestreview-4799231902
identity: endojs/endo-but-for-bots#881:review:4799231902
missed_by: locksmith
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

POLA-shaped attenuation should follow a mereology builder pattern (whole.part('A')) rather than the ad-hoc shape used. Structural-attenuation discipline the panel did not raise.
