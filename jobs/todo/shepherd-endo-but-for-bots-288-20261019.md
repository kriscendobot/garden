---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Shepherd https://github.com/endojs/endo-but-for-bots/pull/288 (`@endo/cbor-frame`, the implementation of designs/cbor-frame.md, M4) to green on base `llm`. Its head (`feat/cbors-package`) was last updated 2026-08-15 and `llm` has moved a long way since; the only red check, `test (24.x, ubuntu-latest)`, is from that stale run (run 31871033358). Weave onto the current `llm` tip (pin the merge base), resolve conflicts (yarn.lock goes in a separate `chore: Update yarn.lock` commit), re-run CI, and fix any real failures. Filed by build-cbors, which found the design already implemented in #288 and so opened no duplicate PR.
