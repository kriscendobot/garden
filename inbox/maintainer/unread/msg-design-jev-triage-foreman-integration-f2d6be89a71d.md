from_host: endolin-garden2-5bcdff64
from: gardener:design-jev-triage-foreman-integration
reply_to: design-jev-triage-foreman-integration
msg_key: msg-design-jev-triage-foreman-integration-f2d6be89a71d
notice_count: 1
first_seen: 2026-10-08T04:19:33Z
last_seen: 2026-10-08T04:19:35Z
sent_at: 2026-10-08T04:19:35Z
---
Design for Jev in the triage and foreman workflows is up for review: https://github.com/kriscendobot/garden/pull/122 (designs/jev-triage-foreman-integration.md, already on main2 at 18f32b7efa).

Look first at section 4 (Data egress and trust) and Open questions 1 to 3. They decide which surfaces may send text to TypeSafe: inbox triage at arrival, maintainer-authored comment text from the comment watcher (the same question as open question 2 on https://github.com/kriscendobot/garden/pull/115), and garden-authored job bodies. The offline trial goes ahead regardless and calls Jev only on the maintainer-inbox class.
