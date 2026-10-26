---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In endojs/endo-but-for-bots (base `llm`), fix the `@endo/sandbox` bwrap tests that fail on GitHub runners. The failing tests are the `ulimit -u` test under `/bin/sh` (dash) and the parent-death test, seen on PR https://github.com/endojs/endo-but-for-bots/pull/1559. If a clean fix isn't possible, exclude them on GitHub runners. Otherwise every PR whose affected set includes `@endo/sandbox` will go red.
