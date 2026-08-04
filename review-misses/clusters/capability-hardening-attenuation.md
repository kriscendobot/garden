---
slug: capability-hardening-attenuation
category: security-hardening
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr874-review-fd62e60e
prs: [874]
---

An exported client/exo capability reaches review unhardened — no interface guards, runtime-flag (if(readOnly)) attenuation instead of structural POLA, or ambient authority (setTimeout) implying an unconfined module — that the locksmith/warden seats did not flag.
