from_host: endolin-garden-ece02cb4
from: gardener:daemon-rename-to-manager-build
reply_to: daemon-rename-to-manager-build
msg_key: msg-daemon-rename-to-manager-build-8df87dd68f46
notice_count: 1
first_seen: 2026-11-02T13:17:13Z
last_seen: 2026-11-02T13:17:15Z
sent_at: 2026-11-02T13:17:15Z
---
build `daemon-rename-to-manager-build` was a duplicate re-post, closed with no new PR.

- Phase 1 (file renames) is merged: https://github.com/endojs/endo-but-for-bots/pull/598.
- Phases 2 and 3 (Daemon/Mignonic → Manager/Worker identifiers, docs, changeset) are already built in draft https://github.com/endojs/endo-but-for-bots/pull/1594 (orchestration build-daemon-rename-to-manager-split, completed 2026-10-31). Its gauntlet HALTED at fix-5 (5/6 rounds). The CI follow-up is draft https://github.com/endojs/endo-but-for-bots/pull/1598.
- The older phase-2 draft https://github.com/endojs/endo-but-for-bots/pull/780 (2026-07-17) is superseded by https://github.com/endojs/endo-but-for-bots/pull/1594. Recommend closing it.
- Parked plan `daemon-rename-to-manager-phase3` (blocked on https://github.com/endojs/endo-but-for-bots/pull/780) is also covered by https://github.com/endojs/endo-but-for-bots/pull/1594. Recommend dropping it, or re-pointing it at that PR.
- Why it was re-posted: `designs/daemon-rename-to-manager.md` on `llm` still has the header **Status: Not Started**. https://github.com/endojs/endo-but-for-bots/pull/1594 fixes that header, so producers will keep re-posting this until that PR lands.

Decision needed: push https://github.com/endojs/endo-but-for-bots/pull/1594 through (resume or restart its halted gauntlet) or retire it.
