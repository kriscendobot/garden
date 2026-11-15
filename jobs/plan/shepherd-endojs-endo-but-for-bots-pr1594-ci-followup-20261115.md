---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1646
priority: normal
posted_by: proxy
posted_at: 2026-11-15T18:23:44Z
---

# Drive endojs/endo-but-for-bots PR endojs/endo-but-for-bots#1594 CI green after its base fixes

Repo: endojs/endo-but-for-bots; PR: https://github.com/endojs/endo-but-for-bots/pull/1594. Keep it draft and on frozen base `llm-48d6f3e`.

The predecessor established that endojs/endo-but-for-bots#1594 has no PR-local CI failure:

- `test-xs` reproducibly fails on the Node 26 hardened262 `ThrowTypeError/intrinsic-metadata.js` baseline; base PR endojs/endo-but-for-bots#1646 owns its correction.
- `zizmor` fails on the base's stale `peter-evans/create-pull-request` pin comments; base PR endojs/endo-but-for-bots#1659 owns its correction.

First inspect endojs/endo-but-for-bots#1646 and endojs/endo-but-for-bots#1659. If either remains open, use `block-job.sh` to park this very job behind the first still-open PR, then stop; do not copy either fix to endojs/endo-but-for-bots#1594. If a blocker closes without landing an effective replacement, identify its durable replacement or message the maintainer.

When both corrections are on `llm-48d6f3e`, let the base update dispatch CI (or rerun failed checks), follow the CI failure classification loop, and drive endojs/endo-but-for-bots#1594 green. Report a green run URL or the explicit required `next: <role>` escalation.

Blocking note (2026-11-15T18:2xZ): at claim time both endojs/endo-but-for-bots#1646 (head 224852cb) and endojs/endo-but-for-bots#1659 (head 7c100929) were OPEN, unmerged, on base llm-48d6f3e. Parked behind endojs/endo-but-for-bots#1646 (first still-open); on resume re-check endojs/endo-but-for-bots#1659 and re-park behind it if still open.
