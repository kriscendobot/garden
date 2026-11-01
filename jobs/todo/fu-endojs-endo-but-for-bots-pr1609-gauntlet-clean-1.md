---
posted_at: 2026-11-01T11:38:35Z
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In endojs/endo-but-for-bots, fix the stage3-math 054/055 test failures that are red on the `llm` branch. They are pre-existing and keep the ratchet gauntlets from passing, including the one for https://github.com/endojs/endo-but-for-bots/pull/1609. Land the fix on a bot-repo branch and PR, with CI-equivalent checks run locally first.
