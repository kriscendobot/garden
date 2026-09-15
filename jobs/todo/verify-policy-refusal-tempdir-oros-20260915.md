---
tier: mentor
requires: host=oros-studio-garden-ce242c49
handler-timeout: 900
fallback-tier: minion
dispatch: automatic
---
# Verify policy-refusal test temp-dir fix on oros-studio

From a garden development worktree containing main2 commit ed289c9da5 or later, run:

    bash scripts/jobs/test/policy-refusal-quarantine-test.sh

Confirm that the standalone suite creates its executable fixture tree through the shared temp-base selector and passes under this host's relocated HOME layout. Report the command, selected environment context needed to explain the result, and the pass/fail summary. Do not modify code unless a host-specific regression is found; if one is found, report it and post a separately scoped fix job.
