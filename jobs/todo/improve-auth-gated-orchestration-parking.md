---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/orchestrate.sh
2026-10-07T11:22:25Z: deploy validation for minion.town#165 marked `orchestration-failed` solely because Root OAuth requires interactive MFA unavailable to fleet, despite successful deploy, receipt, health, and fail-closed checks. Add a deterministic auth-unavailable child outcome that parks the remaining validation and emits one maintainer action notice rather than halting the orchestration as a failed deployment; cover it in the orchestration tests.

<!-- garden-reaped: 0 -->
