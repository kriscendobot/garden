---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-11-17T04:45:11Z
job: endojs-endo-but-for-bots-pr1591-gauntlet-20261117-panel-1
claim: ba49fe66fc68d768
---
PR #1591, dispatch: prover review against `48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c...HEAD`.

**Verdict:** request-changes

**Findings:**

- must-fix — `packages/sandbox/test/bwrap.test.js:1060` does not prove the new anchor mechanism. It waits for the process group to disappear after `/bin/true`; the base implementation spawned `bwrap` directly and its detached process group also disappears after that normal exit, so the same assertion passes when `PROCESS_GROUP_ANCHOR_SCRIPT` and its wrapper spawn are reverted. Exercise the leader-exits-while-a-member-survives failure mode, or inject the signal boundary and assert the exit handler actually sweeps the retained group. [rule: skills/regression-evidence/SKILL.md]

Self-improvement: nothing this time.
