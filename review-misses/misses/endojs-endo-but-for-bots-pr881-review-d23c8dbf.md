---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr881-review-d23c8dbf
verdict: miss
category: security-hardening
pr: 881
cluster: capability-hardening-attenuation
cluster_pattern: An exported client/exo capability reaches review unhardened — no interface guards, runtime-flag (if(readOnly)) attenuation instead of structural POLA, or ambient authority (setTimeout) implying an unconfined module — that the locksmith/warden seats did not flag.
review_at: 2026-07-28T17:23:11Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/881#pullrequestreview-4800101592
identity: endojs/endo-but-for-bots#881:review:4800101592
missed_by: warden
severity: major
consolidated_pass: review-retrospective-consolidated-20260804
---

A facets module uses setTimeout, implying it expects to run unconfined; contributor questions why. Ambient-authority/confinement concern the warden did not flag.
