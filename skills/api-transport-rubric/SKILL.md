---
created: 2026-10-29
updated: 2026-10-30
author: liaison
status: draft
---

# Skill: api-transport-rubric

## Purpose

Decide, for one feature of an object-capability system, whether it belongs on a **REST endpoint** or on a **CapTP session**. Designers apply it while specifying an interface; builders apply it before adding an endpoint. Written for minion.town and the Familiar user agent; it transfers to any project that mixes HTTP with capability transfer.

## Inputs

The feature's caller, the authority the call needs, and whether the call passes or returns authority.

## Default (maintainer, 2026-10-30)

**Use CapTP in general; use REST only where it is absolutely necessary.** REST is necessary when the caller has no reference yet (login, minting the first locator, opening the session), when the caller cannot speak CapTP (curl, a login page, static content, webhooks), or when a platform boundary demands HTTP. The scoring table below finds the exceptions; it does not make REST the starting point. A feature that scores REST because the shell "has no session yet" is a missing prerequisite (build the session), not a REST feature.

## The question

**Is the caller exercising a held authority, or establishing who it is?**

- **REST at the door.** HTTP covers what happens before a capability exists: login, CSRF-checked account actions, minting a locator, static content. The cookie is the only authority, so the endpoint turns ambient identity into a specific, revocable object.
- **CapTP inside.** Once the caller holds a designating reference, further authority flows through it. Do not re-derive it from the cookie on each call.

## Procedure

Answer each row. Count the leans, then apply the overrides. A close count means the feature is probably two features: a REST mint and a CapTP use.

| # | Question | REST leans | CapTP leans |
| --- | --- | --- | --- |
| 1 | What authorizes the call? | Who the user is (cookie, owner-derived) | Holding a particular object |
| 2 | Does it pass authority to the callee? | No | Yes: attachments, endowments, callbacks, facets |
| 3 | State across calls? | No: one request, one response | Yes: a session, streaming, promise pipelining |
| 4 | Revoke, pause, or attenuate independently? | No | Yes: one object per grant, revoking it kills the grant |
| 5 | Who calls it? | Anything: curl, a login page, an unconfined page | Only a confined clip or a peer handed the reference |
| 6 | Is the result a live object? | No: plain data | Yes: the result is itself a capability |
| 7 | Does it create the first reference? | Yes | No |

### Overrides

1. **Mint by REST, use by CapTP.** A feature whose authority is an object gets exactly one REST endpoint, the locator mint: account-gated, expiring, revocable. Every later call uses CapTP.
2. **No REST endpoint takes a capability as an argument.** A string naming a power is a forgeable bearer name. If a call must pass one, it belongs on CapTP. A bearer token is acceptable only when it designates one specific object, not an identity.
3. **No ambient authority over the powerbox through REST.** If a cookie can reach a clip's powers directly, ask whether the clip could trigger the call. Chrome-only endpoints (clone, destroy) pass when only chrome code calls them; they still need CSRF checks and owner scoping.
4. **Secrets do not come back out.** Project responses onto an explicit non-secret schema. A feature that must return a secret is a design flaw, not a transport choice.
5. **A plain-data listing is not a reason for REST.** It may stay REST while no session exists; say so, and plan the CapTP facet.

## Output shape

A short table in the design or PR body: one row per feature, the transport chosen, and the rubric rows or overrides that decided it. Flag any feature that is REST today with a planned CapTP home.

## Worked checks (minion.town, 2026-10-29)

| Feature | Verdict | Why |
| --- | --- | --- |
| Provider key entry (#229) | REST today | Secrets never returned; revisit once the shell holds a session |
| Clip list for the gutter (#179) | REST today, CapTP once the shell has a session | Default is CapTP; REST only because the session does not exist yet |
| Governor powers read (#230) | CapTP | Powers are objects (row 6); needs the shell session |
| Clone and destroy (#230) | CapTP | Chrome-only calls on the owner's facet |
| Chat turn stream (#228) | Locator by REST, turns by CapTP | Rows 2, 3, 4 |
| Attaching a pet name to a message | CapTP | Rows 2, 6 |
| Spawning a subagent | CapTP | Rows 2, 4 |

## Notes

- The maintainer's default (CapTP unless REST is absolutely necessary) is recorded in the section above; older text in this skill that treats REST as the home for owner-derived calls is superseded by it.
- Status is draft: the rubric was derived from four open minion.town designs, not from shipped code. Revise as the first features are scored against it.
- A review-juror check (flag a capability passed as a string; flag a cookie re-deriving authority on every call) is a candidate follow-up, not part of this skill.
- Companion skills: [ownership-map](../ownership-map/SKILL.md) for who owns state at each boundary; [ocap-attenuation-authoring](../ocap-attenuation-authoring/SKILL.md) for narrowing a power.
