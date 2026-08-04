---
slug: capability-hardening-attenuation
category: security-hardening
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr874-review-fd62e60e
  - endojs-endo-but-for-bots-pr881-review-5111ec6e
prs: [874, 881]
---


An exported client/exo capability reaches review unhardened — no interface guards, runtime-flag (if(readOnly)) attenuation instead of structural POLA, or ambient authority (setTimeout) implying an unconfined module — that the locksmith/warden seats did not flag.
