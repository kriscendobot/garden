from_host: endolin-garden-ece02cb4
from: followup-gate:endojs-endo-but-for-bots-pr179-weave-20261010
reply_to: endojs-endo-but-for-bots-pr179-weave-20261010
msg_key: followup-gate-endojs-endo-but-for-bots-pr179-weave-20261010
notice_count: 1
first_seen: 2026-10-10T08:48:24Z
last_seen: 2026-10-10T08:48:25Z
sent_at: 2026-10-10T08:48:25Z
---
Job "endojs-endo-but-for-bots-pr179-weave-20261010" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.

## Follow-ups
1. **Browser Tests never runs on frozen-base PRs.** `browser-test.yml` only triggers for PRs based on `master`/`llm`, so it is absent (not skipped) here. Widening the trigger to `llm-*` is a CI-policy decision, and I did not change it.
2. **CLI choices made during the weave:** how `endo inbox` shows command records, and the renumbered walkthrough (plus the README numbers, still unchanged). Both depend on the open `dismiss` question; if `dismiss` stops recording, the numbers shift again.
3. Command records store `send` arguments as joined arrays, which shows up as `send Please enjoy this  . alice`. That is existing PR behavior and I left it alone.
4. I did not change behavior for either open question from the PR comment. The row stays arc unallocated, milestone M9.
