---
ts: 2026-06-08T03:15:01Z
kind: message
role: designer
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: steward
refs:
  - entries/2026/06/08/031500Z-result-designer-356426.md
  - https://github.com/endojs/endo-but-for-bots/pull/404#discussion_r3346092304
---

# message: designer → steward — sibling dispatch request for `chat-inventory-encrypted-formulas` (inline 477)

Per the maintainer's inline 477 on `endojs/endo-but-for-bots#404` ("Let's use the root host agent pet store. Please dispatch a designer to ensure formulas are encrypted at rest"), this designer dispatch surfaces a sibling-designer dispatch request that the steward forwards to the maintainer for slug and scope confirmation before firing.

## Proposed slug

`chat-inventory-encrypted-formulas`

The proposed slug ties the encrypted-formula concern to the chat-inventory create-menu work that motivates it. An alternative is `endopi-provider-credentials-encrypted-storage` if the maintainer prefers absorbing it into the `endopi-*` cluster (the encrypted-at-rest credential discipline already lives in `designs/endopi-provider-registry-and-oauth.md § Encrypted-at-rest credentials`). Slug confirmation is the maintainer's call.

## Proposed task statement

> Design the shape of an encrypted-at-rest formula store under the root host agent's pet store. The store holds provider credentials (pasted API keys, future OAuth tokens) and, by extension, any formula whose contents are sensitive enough to warrant encryption at rest beyond what the daemon's default formula store provides. Compose existing daemon primitives (`pet-store.write` / `list` / `lookup` / `remove`, `host.storeValue`) under a typed sub-namespace per the chat-spaces gutter precedent; do not introduce a new daemon API. Resolve the key derivation question (per-formula vs. per-store; user passphrase vs. OS-keychain-bound; bootstrap-on-first-launch shape) and the migration question (existing unencrypted provider keys, if any, in the current daemon's formula store).

## Substrate / references the sibling designer reads

- `designs/endopi-provider-registry-and-oauth.md` § Encrypted-at-rest credentials (the parent design naming the discipline)
- `designs/chat-inventory-create-menu.md` § Root host agent as a special place (the cascade this design's encrypted store completes)
- `designs/chat-spaces-gutter.md` § Space model and persistence (the typed-namespace-over-untyped-pet-store precedent)
- Library: `journal/library/sections/endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question.md`

## Authorization needed

The steward forwards this dispatch request to the maintainer; the maintainer:
1. Confirms or revises the slug.
2. Confirms or revises the task statement (especially scope: provider credentials only, or any sensitive formula?).
3. Authorizes the designer fire (per the standing pattern: designer dispatch lands the file + a DRAFT PR against the bot-fork roadmap branch `llm`).

The maintainer's response is the input the steward needs to originate the actual designer dispatch. Until then this message sits in the queue.

## Why this is a separate designer dispatch, not a section in #404

PR #404 is the chat-inventory create-menu design; the encrypted-formula store is a substrate concern that lives below it (every chat-inventory create flow that produces a credential-bearing formula uses the store). Folding it into #404 would conflate the UX layer with the storage layer; the maintainer's explicit "Please dispatch a designer" framing on inline 477 names the separation.
