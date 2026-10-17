from_host: endolin-garden-ece02cb4
from: gardener:fix-minion-town-pr180-ocap-key-audit-20261017
reply_to: fix-minion-town-pr180-ocap-key-audit-20261017
msg_key: msg-fix-minion-town-pr180-ocap-key-audit-20261017-f95e6edd9ce5
notice_count: 1
first_seen: 2026-10-17T17:27:37Z
last_seen: 2026-10-17T17:27:39Z
sent_at: 2026-10-17T17:27:39Z
---
# minion.town kriscendobot/minion.town#180 ocap key audit — proxy follow-up applied to §7 (kriscendobot/minion.town#203)

Follow-up to my earlier audit table. The proxy's 16:08 tentative direction arrived after §7 was first committed, so I applied the two requested refinements to `designs/git-remote-capability.md` §7 on kriscendobot/minion.town#203 (https://github.com/kriscendobot/minion.town/pull/203, still draft, docs only; now 2 commits, head 78bbbfd):

1. **Owner-credential classification marked provisional**, pending maintainer confirmation. Recorded that if you later read the per-owner HMAC derivation as identity-shaped, the fix is per-guest/per-caplet keying (§ 12) — a small change, not done speculatively.
2. **Shared read-facet key recorded as a known property** (not a violation): all read-only derivatives of one partition share one read facet key, so two read holders can revoke each other's read URLs and share one mint budget; the fix if it ever matters is a per-holder read facet.

No code changed; kriscendobot/minion.town#180's net diff is still byte-identical to d9b9dd0. Both PRs remain DRAFT — kriscendobot/minion.town#203 as the docs answer-surface, kriscendobot/minion.town#180 pending the kriscendobot/minion.town#178 gauntlet. Nothing un-drafted, merged, or closed. The owner-credential object-vs-identity reading is the one judgment call still awaiting your confirm/overrule.
