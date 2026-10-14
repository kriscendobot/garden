---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/cleric-codex.sh
scripts/jobs/handlers/cleric-codex.sh:400 only nudges an rc=0 markerless turn; the 2026-10-14T18:20:59Z `heal-minion-town-ad0257e` report described a completed PR and staged gauntlet but Codex returned rc=3, leaving it for reaping. When a nonzero Codex turn leaves a nonempty report, resume the same session once to request deterministic verification and the completion marker; finalize only on the existing rc=0 marker contract, otherwise retain the failure.
