---
role: shepherd
---

Shepherd endojs/endo-but-for-bots PR #609 (`build/endoclaw-timer-daemon-formula-integration`, the endoclaw-timer scheduled-execution base that just absorbed Phase 4 host-integration commit `c84fb80ed`, base `llm`, bot identity): both `lint` matrix jobs are failing while build, cover, and the full test matrix pass — diagnose and fix the lint failure and drive CI to green so the `609→617→619` scheduled-execution stack becomes landable, advancing M3's scheduled-execution pillar. Coordinate with the in-flight #617/#619 restack: land the lint fix on #609's branch head.

<!-- garden-reaped: 1 -->
