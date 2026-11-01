---
posted_at: 2026-11-01T01:54:22Z
arc: ironhorse-test262-ratchet
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder work in endojs/endo-but-for-bots on the Ironhorse test262 ratchet. Run the coverage report, take the second-largest currently-failing but supported test262 slice (skip host-excluded Temporal and whatever slice the in-flight `ironhorse-test262-ratchet-coverage-crank-20261101` job is working), fix the engine gaps, and raise the ratchet floor on a separate fresh branch with its own draft PR.
