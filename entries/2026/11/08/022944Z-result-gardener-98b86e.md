---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-08T02:30:43Z
job: improve-dependabotany-preflight-merge-now-snapshot
claim: eca05475457c97fa
---
Implemented complete Dependabotany active-row snapshots in main2 commit 21585bda2b36d16e4d56ad9ec42aeb407eb55d7b.

- Snapshot v2 serializes EMBARGO dates and structured non-terminal MERGE-NOW rows, including blocked PR #1633, with deterministic ordering and terminal-marker retirement.
- Updated the botanist consumer contract and regression coverage for blocked, conditional-future, and terminal MERGE-NOW cases.
- Verification: scripts/jobs/test/dependabotany-preflight-test.sh passed 64/64; git diff --check and bash -n passed. The broader run-test.sh exposed unrelated existing concurrency, scaler-log, and follow-up failures before it was stopped.
- Self-improvement: nothing this time.
