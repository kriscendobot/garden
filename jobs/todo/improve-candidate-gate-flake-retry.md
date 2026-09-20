---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
The exact rejected candidate now passes all three reported suites, indicating a transient gate failure. Retry only failed suites once in a fresh candidate gate root, preserving diagnostics from both attempts; reject if any suite fails again, but avoid blocking deployment on a one-off host-side test flake.
