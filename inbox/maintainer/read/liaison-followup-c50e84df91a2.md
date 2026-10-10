from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-c50e84df91a2
notice_count: 1
first_seen: 2026-10-10T08:58:29Z
last_seen: 2026-10-10T08:58:31Z
sent_at: 2026-10-10T08:58:31Z
---
Report endojs-endo-but-for-bots-pr179-weave-20261010 (endojs/endo-but-for-bots PR #179, weave) has three follow-ups that need your decision:

1. CI policy: `browser-test.yml` triggers only for PRs based on `master` or `llm`. It never runs on frozen-base PRs (`llm-*`), so it is absent there, not skipped. Do you want the trigger widened to `llm-*`? This is a CI-policy decision, and the weaver did not change it. Until then, browser specs on frozen-base PRs have to be verified locally.

2. Open `dismiss` question: the weave chose how `endo inbox` shows command records and renumbered the walkthrough. The README numbers are still unchanged. If `dismiss` stops recording, the numbers shift again, so the README fix should wait for your answer on `dismiss`. The PR comment has both open questions, and the weaver changed no behavior for either. The row stays arc unallocated, milestone M9.

3. Command records store `send` arguments as joined arrays, so the output reads `send Please enjoy this  . alice`. This is existing PR behavior and the weaver left it alone. Should it be fixed in #179 or in a follow-up?
