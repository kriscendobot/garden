---
ts: 2026-06-08T03:15:03Z
kind: message
role: designer
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: steward
refs:
  - entries/2026/06/08/031500Z-result-designer-356426.md
  - https://github.com/endojs/endo-but-for-bots/pull/404#discussion_r3346088221
---

# message: designer → steward — sibling dispatch request for `@root` endowment + user / user-profile split (inline 363)

Per the maintainer's inline 363 on `endojs/endo-but-for-bots#404` ("Chat should arrange for a user host agent, named like `user` and `user-profile`, then treat that as the primary user, to hide capabilities like the agent provisioner from the UX. We can add an `@root` endowment to all Endo hosts so the user can enter from below. Please dispatch a separate designer"), this designer dispatch surfaces a sibling-designer dispatch request that the steward forwards to the maintainer for slug and scope confirmation before firing.

## Proposed slug

Slug to be named by the maintainer. Candidate the designer considered:

- `endo-root-special-and-user-host` (encodes both elements: the `@root` Specials entry and the user / user-profile host split)

The maintainer may split it into two designs:

- `endo-root-special` (the `@root` endowment alone; small, anchored on the existing `Specials` precedent)
- `chat-user-host-split` (the `user` / `user-profile` shape and Chat's installation of provisioning capabilities on the root)

Whether one design or two is the maintainer's structural call.

## Proposed task statement

> Design (a) the `@root` endowment as a Specials entry alongside the existing six special names (`@self`, `@host`, `@agent`, `@keypair`, `@main`, `@endo`; per `designs/d256.md` § Per-agent keypairs), preformulated at daemon initialization analogously to `@apps` (per `designs/familiar-bundled-agents.md` § Specials), and (b) the `user` / `user-profile` split: a user host agent named `user` and its profile `user-profile` sit one level below the root host agent, become the primary identity the Chat UX shows, and let Chat install the agent-provisioner capabilities on the root host where the user-facing day-to-day UX never has to surface them. Resolve: where on the root host's pet store the user host's formula lives (the typed-namespace-over-pet-store discipline per `designs/chat-spaces-gutter.md`); the lazy-vs-eager bootstrap question (preformulated, or installed by Chat on first launch via the self-provisioning bootstrap pattern in `familiar-bundled-agents.md` § How the `@apps` formula works); and the inbox-replay shape (Chat replays the inbox on first launch to preserve the `inbox-as-durable-config-store` property after provisioning moves out of the daemon).

## Substrate / references the sibling designer reads

- `designs/chat-inventory-create-menu.md` § Cross-Design Alignment § Relationship to lal-fae-form-provisioning, § Root host agent as a special place (the encoding this design completes)
- `designs/lal-fae-form-provisioning.md` § three-named-problems, § three-layer-lifecycle, § form-submission-from-@host-already-serves-as-the-consent-mechanism, § introducedNames-@agent-as-consent-boundary
- `designs/familiar-bundled-agents.md` § Specials (the `@apps` precedent), § How the `@apps` formula works (the self-provisioning bootstrap pattern)
- `designs/d256.md` § Per-agent keypairs (the special-name idiom on hosts and guests)
- `designs/chat-spaces-gutter.md` § Space model and persistence (the typed-namespace precedent)
- Library: `journal/library/sections/endo-but-for-bots--llm-designs-lal-fae-form-provisioning--three-named-problems-and-three-layer-lifecycle-and-three-option-analysis-for-guest-cannot-create-guests-and-inbox-as-durable-config-store.md`; `journal/library/sections/endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-and-env-var-gating-for-dev-vs-packaged-asymmetry.md`; `journal/library/sections/endo-but-for-bots--llm-designs-d256--per-agent-keypairs.md`

## Authorization needed

The steward forwards this dispatch request to the maintainer; the maintainer:
1. Confirms or chooses the slug(s) (single design or split?).
2. Confirms the scope (is the design only about the `@root` Specials entry, or does it also own the user / user-profile shape on top of the root host?).
3. Authorizes the designer fire.

The maintainer's response is the input the steward needs to originate the actual designer dispatch.

## Why this is a separate designer dispatch, not a section in #404

PR #404 (chat-inventory create-menu) encodes the directive (in its new § Root host agent as a special place) and the cascade (Chat installs provisioning capabilities on the root host, the user host presents the user-facing inventory, the `@root` endowment is the path back up to provisioning), but the full design of the `@root` special name and the user / user-profile shape is a separate architectural concern that touches the daemon's Specials mechanism, every Endo host's namespace, and the chat client's first-launch bootstrap. The maintainer's explicit "Please dispatch a separate designer" framing names the separation.
