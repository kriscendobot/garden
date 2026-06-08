---
ts: 2026-06-08T03:15:02Z
kind: message
role: designer
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: steward
refs:
  - entries/2026/06/08/031500Z-result-designer-356426.md
  - https://github.com/endojs/endo-but-for-bots/pull/404#discussion_r3346094334
---

# message: designer → steward — sibling dispatch request for provider-key recovery and rotation (inline 484)

Per the maintainer's inline 484 on `endojs/endo-but-for-bots#404` ("Agree this is a separate design. Dispatch a designer to leave a place-holder for this complication"), this designer dispatch surfaces a sibling-designer dispatch request that the steward forwards to the maintainer for slug and scope confirmation before firing.

## Proposed slug

Slug to be named by the maintainer. Candidates the designer considered:

- `chat-inventory-credential-recovery` (couples to the chat-inventory work)
- `endopi-credential-recovery-and-rotation` (couples to the endopi cluster; parallels `gateway-key-recovery.md` referenced in #404 Open Question 2)
- `endo-credential-lifecycle` (broader; absorbs recovery, rotation, and possibly revocation)

The third candidate is broader than the inline ask; the maintainer's framing ("a place-holder for this complication") suggests starting narrow. Naming is the maintainer's call.

## Proposed task statement

> Design the recovery and rotation story for provider credentials (pasted API keys today, future OAuth refresh tokens) used by Chat-provisioned agents. Address: (1) what the user does when an API key is lost (re-paste? recovery flow?); (2) who refreshes OAuth tokens when they expire (Chat? a background renewer in the daemon? the user on-demand?); (3) the parallel with public-key recovery in `designs/gateway-key-recovery.md` (which itself is a design gap); (4) the UI affordance on the Chat new-agent wizard's pane 2 (today: a "rotate" placeholder). Decide whether this design subsumes `gateway-key-recovery` or stays adjacent.

## Substrate / references the sibling designer reads

- `designs/chat-inventory-create-menu.md` § Open Question 2 (the placeholder this design fills in)
- `designs/endopi-provider-registry-and-oauth.md` (the registry the recovery flow plugs into)
- `designs/gateway-key-recovery.md` (the parallel gap referenced in #404 Open Q 2)
- Library: `journal/library/sections/endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question.md`

## Authorization needed

The steward forwards this dispatch request to the maintainer; the maintainer:
1. Confirms or chooses the slug.
2. Confirms the scope (key recovery only, or also rotation, or also the gateway-key-recovery parallel?).
3. Authorizes the designer fire.

The maintainer's response is the input the steward needs to originate the actual designer dispatch.

## Why this is a separate designer dispatch, not a section in #404

PR #404 is the chat-inventory create-menu design; credential lifecycle is its own architectural concern that touches the Chat UI, the daemon's credential store, and the provider registry. Folding it into #404 would broaden that PR beyond the maintainer's "place-holder for this complication" framing. The chat-inventory PR's Open Question 2 cites the sibling design without authoring it; the sibling design owns the substance.
