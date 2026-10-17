from_host: endolin-garden-ece02cb4
from: gardener:fix-minion-town-pr180-ocap-key-audit-20261017
reply_to: fix-minion-town-pr180-ocap-key-audit-20261017
msg_key: msg-fix-minion-town-pr180-ocap-key-audit-20261017-eb1200049286
notice_count: 1
first_seen: 2026-10-17T19:39:21Z
last_seen: 2026-10-17T19:39:22Z
sent_at: 2026-10-17T19:39:22Z
---
# PR kriscendobot/minion.town#180 control-plane key audit (ocap §7 ruling)

**Job:** fix-minion-town-pr180-ocap-key-audit-20261017
**Ruling applied (kriskowal, 2026-10-17):** a bearer secret is ocap-coherent when it
designates **one specific object** attenuated to that object's authority; it violates
§7 when it refers to an **identity** (account/owner/master/ambient) or grants more than
the one object.

## Verdict

**No identity-shaped secret is reachable by a guest or a caplet.** Every secret a guest
or caplet can obtain designates one object. No code fix was required. One case (the owner
credential) is genuinely debatable and is flagged below for your confirmation; fixing it
*if you read it as identity-shaped* is a redesign, so per the job I report rather than
unilaterally rewrite it.

## Audit table — every control-plane secret

| Secret | Derivation | Designates | Reachable by a guest? | Class |
| --- | --- | --- | --- | --- |
| **root secret** | random, loaded into both server units | master authority (owner creds + facet keys derive from it) | **No** — held only by `minion-git-remote` + `minion-mcp` processes; never enters the Endo daemon or any formula | identity-shaped, but **out of the ocap graph** |
| **owner credential** | `HMAC(root, "git-control-owner\0"+owner)` | one owner's quota-bounded `create` allocator (+ its `/hello` proof); opens/mints/revokes **nothing** the owner already holds | **No** — derived host-side in root-host-socket.ts, injected as caplet-formula env `GIT_REMOTE_CONTROL_CREDENTIAL`; the guest holds only the `git` exo, not the formula | object-designating (**closest case — see flag**) |
| **retention key** | `mintToken()` random, per partition | one partition, read+write (`open` checks only its hash) | **No** — `create`'s return stays inside the guest's `open(<id>,<key>)` formula source; "The key stays in the formula; it is never returned" (guest-control.ts) | object-designating |
| **facet key** | `HMAC(root, "git-partition-facet\0"+id+"\0"+atten)` | one partition at one attenuation; attenuation derived *from* the key, so a read facet holds no read+write authority | **No** — closed over by each partition exo; no method returns it | object-designating |
| **capability-URL token (§6)** | `mintToken()` per mint | one partition at one attenuation; revocable by hash through that partition's facet | **Yes** — the minted show-once URL | object-designating ✓ |
| **/hello proof** | `HMAC(presented-secret, label\0port\0nonce)` | **nothing** — only lets the caplet tell the listener from a port squatter; no derivation uses it as a key | answers only | authorizes nothing ✓ |

## The one flag — owner credential

The owner credential is keyed off the owner's *name* and is presented with an
`x-git-partition-owner` header, so it can be read two ways:

- **Object-designating (the classification used):** it authorizes only `create` on that
  owner's single quota-bounded allocator and reaches no existing partition — the worst a
  leaked copy does is spend that owner's partition quota. The control plane treats "the
  owner's allocator" as the designated object.
- **Identity-shaped (the alternative):** there is no distinct allocator *object*; the
  `/partitions` route is parameterized by the owner header, so the secret arguably names
  *who* the caller is rather than *which* object.

It is held host-side and **never reachable by a guest** either way, so there is no live
leak. If you read it as identity-shaped, the fix is a redesign — per-caplet keying or a
first-class allocator capability object — recorded as follow-on work in §12, not done
speculatively. PR kriscendobot/minion.town#203 flags this as provisional pending your confirmation.

## Deliverables

1. **Audit** — done (above). No fix needed; owner-credential flagged.
2. **§7 ruling recorded** — PR kriscendobot/minion.town#203 (draft, base `main-945aaaa`) adds the identity-vs-object
   test to `designs/git-remote-capability.md` §7 with the same classification table and
   qualifies the two "not a bearer token" lines to "not an identity-shaped bearer token."
3. **kriscendobot/minion.town#180 regrouped** — head is a clean 7-commit reviewable sequence (caps → control plane →
   caplet → lock → endo binding → deploy secret → docs), net-diff invariant, left **DRAFT**
   (un-drafting still waits on the kriscendobot/minion.town#178 gauntlet). MERGEABLE.
