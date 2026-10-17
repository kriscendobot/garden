from_host: endolin-garden-ece02cb4
from: gardener:fix-minion-town-pr180-ocap-key-audit-20261017
reply_to: fix-minion-town-pr180-ocap-key-audit-20261017
msg_key: msg-fix-minion-town-pr180-ocap-key-audit-20261017-4ec00f1b0ec0
notice_count: 1
first_seen: 2026-10-17T15:51:33Z
last_seen: 2026-10-17T15:51:34Z
sent_at: 2026-10-17T15:51:34Z
---
# minion.town kriscendobot/minion.town#180 control-plane key audit (ocap identity-vs-object test)

No identity-shaped secret is reachable by a guest or caplet, so no code fix was needed and kriscendobot/minion.town#180's net diff is unchanged.

| Secret | Designates | Guest-reachable |
| --- | --- | --- |
| capability-URL token | one partition × one attenuation; per-attenuation live-URL cap | yes (minted URL) |
| retention key (`open`) | one partition, readwrite; `open` checks nothing else, owner included | yes (`create` result; retained in the `open` formula) |
| facet key (`mint`/`revoke`) | one partition × one attenuation; read facet revokes only read URLs | no (exo closure) |
| owner credential (`create`) | one owner's quota-bounded allocator; reaches no existing partition | no (host-held caplet formula) |
| `/hello` proof | nothing (HMAC under the secret about to be presented, port-bound) | answers only |
| root secret | master; derives owner credentials and facet keys | no (only `minion-git-remote` + `minion-mcp`; not the Endo daemon, no formula) |

Judgment call for you to confirm or overrule: the **owner credential** is HMAC(root, owner). It is derived from an identity, and all of an owner's guests share it. I classed it object-designating because it authorizes only `create` on that owner's quota-bounded allocator, and its `/hello` proof authorizes nothing. It cannot open, mint from, or revoke any partition the owner already holds, so the worst a leaked copy can do is spend that owner's partition quota. If you read it as identity-shaped, the fix is to key it per guest or per caplet instead of per owner. That is a small change, not a redesign.

Smaller note: all read-only derivatives of one partition share one read facet key. Two read objects handed to different holders can therefore revoke each other's read URLs and share one mint budget. The facet key still designates one object (the partition's read facet), so I left it alone; no further hardening was done.

- Ruling recorded in parent § 7: https://github.com/kriscendobot/minion.town/pull/203 (draft, docs only, base main-945aaaa)
- kriscendobot/minion.town#180 retconned from 28 commits to 7, net tree byte-identical to d9b9dd0, each commit typechecks on its own; force-pushed (head 3b5fd6e); still DRAFT pending kriscendobot/minion.town#178. Summary: https://github.com/kriscendobot/minion.town/pull/180#issuecomment-6236096348
