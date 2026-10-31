---
posted_at: 2026-10-31T04:51:06Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/ci-wait-merge.sh
scripts/jobs/gardening/ci-wait-merge.sh:264 accepts its full CI deadline without clipping it to `GARDEN_HANDLER_DEADLINE_EPOCH`; the clean stage hit its 7200s worker wall at 2026-10-31T04:44:43Z before it could emit `still-pending`. Clamp the CI wait to remaining handler time with a small exit/report reserve, and return rc 4 when insufficient time remains so the gauntlet driver can repost the stage cleanly.
