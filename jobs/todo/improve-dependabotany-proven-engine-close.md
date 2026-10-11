---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabotany-preflight.sh
`scripts/jobs/dependabotany-preflight.sh:412` proves a Node-engine conflict but only passes it as agent context; at 2026-10-11T20:17:21Z, botanist still had to reject pi-tui 1.0.2 for that deterministic mismatch. Add a hardened deterministic reverify-and-close path for proven unchanged engine conflicts, with a fixed journal result; fall back to the botanist only if revalidation fails.
