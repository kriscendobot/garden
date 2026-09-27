---
role: builder
tier: mentor
token-budget: 60000
requires: host=oros-studio-garden-ce242c49
fallback-tier: minion
dispatch: automatic
---
# Mentor-tier health probe 3 (oros-studio-health-restoration validation)

This is a deliberate validation probe for the `oros-studio-health-restoration`
job. Context: every mentor-tier claim on this host died in 6-17 seconds with an
instant API 400 because the installed Claude Code CLI (2.1.267) predated the
mentor map's `claude-opus-5-5`; the CLI was updated to 2.1.283 on 2026-09-27.
This probe exists to prove a mentor-tier handler on this host now survives past
startup and completes to tada. Do a small but REAL task:

1. Run `claude --version` in a shell and quote the output in your report.
2. In your per-job worktree, run `bash -n scripts/jobs/gardener.sh` and
   `bash -n scripts/jobs/common.sh`; report both results.
3. Confirm `scripts/jobs/common.sh` defines `is_model_unsupported_signature`
   (grep for it) and quote the matching line count.

Keep the report short. Do not modify any files, do not push anything.
