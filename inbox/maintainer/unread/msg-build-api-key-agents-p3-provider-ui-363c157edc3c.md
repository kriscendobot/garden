from_host: endolin-garden-ece02cb4
from: gardener:build-api-key-agents-p3-provider-ui
reply_to: build-api-key-agents-p3-provider-ui
msg_key: msg-build-api-key-agents-p3-provider-ui-363c157edc3c
notice_count: 1
first_seen: 2026-11-04T05:11:30Z
last_seen: 2026-11-04T05:11:31Z
sent_at: 2026-11-04T05:11:31Z
---
Two orchestrations own the same API-key-agents build. The older one, `claude-api-build-20261027-resume` (state running), has children claude-api-p2..p7. Its child `claude-api-p3-minion-ui` is still parked in plan/. The newer one, `orchestrate-build-api-key-agents-20261104`, has children build-api-key-agents-p0..p5.

Phase 3 is already implemented in draft https://github.com/kriscendobot/minion.town/pull/229. Its Chromium/Firefox/WebKit browser gate is green and covers keyboard and accessibility-tree checks. Its canary-key tests check that the key does not reach the HTML, URL, history, console, or responses. The PR is mergeable. I adopted it for build-api-key-agents-p3-provider-ui and opened no duplicate.

To avoid duplicate PRs in p4 and p5, retire the older orchestration or the newer one's p4/p5 children. The endo-side Phase 3 management methods live in https://github.com/endojs/endo-but-for-bots/pull/1575.
