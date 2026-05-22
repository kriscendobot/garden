---
slot: 1
status: in-flight
design_path: null
pr_number: 316
current_stage: weaver
in_flight_dispatch: 859cc9
last_update: 2026-05-22T21:29:00Z
started_at: 2026-05-22T21:21:00Z
host: endolinbot
---

PR #316 (chore(familiar): Node 22.22.3 LTS pin). Cleaner 919e16 found PR CONFLICTING against llm (PR #354 zizmor hardening on `.github/workflows/familiar-release.yml`). Dispatch `weaver--859cc9` rebases past the conflict; after weaver returns, slot likely jumps cleaner → barrister per the chore-shape shallow-coverage rule.

Branch `chore/familiar-lts-node-pin`, base `llm`.
