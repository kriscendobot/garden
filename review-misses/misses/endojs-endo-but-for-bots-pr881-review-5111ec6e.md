---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr881-review-5111ec6e
verdict: miss
category: security-hardening
pr: 881
cluster: capability-hardening-attenuation
cluster_pattern: An exported client/exo capability reaches review unhardened — no interface guards, runtime-flag (if(readOnly)) attenuation instead of structural POLA, or ambient authority (setTimeout) implying an unconfined module — that the locksmith/warden seats did not flag.
review_at: 2026-07-28T15:43:14Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/881#pullrequestreview-4799182277
identity: endojs/endo-but-for-bots#881:review:4799182277
missed_by: locksmith
severity: major
consolidated_pass: review-retrospective-consolidated-20260804
---

exo-google-sheets attenuates with a runtime `if (readOnly)` flag rather than structurally denying write authority; contributor: code that cannot write should statically lack write authority, this is a strange way to do attenuation (cf @agoric/pola-io). No panel job is recorded for this PR.
