# convert PR #440 formula-inspector chat views to confined Preact

Source: maintainer directive by kumavis on endojs/endo-but-for-bots PR #440.
Comment: https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4808004318
> @kriscendobot preact conversion work landed, can the new views be updated to preact?

Routed from attention job `endojs-endo-but-for-bots-pr440-0053f267` (reactji-acked 👀).

## What landed

The chat UI confined-Preact conversion landed on `llm`: #471
(migrate Chat UI to confined Preact via `@endo/preact-container`) and #516
(outliner conversion + chat-UI split into `space-*` packages, merged
2026-06-26T08:46Z, two minutes before kumavis's comment). Untrusted content now
renders through `renderConfined`; in-chat views are extracted into reusable
`space-*` packages (`space-channel`, `space-chat`, `spaces-util`, ...).

## The gap

PR #440 (kriscendobot, `feat/formula-inspector`, base `llm-6d889af`, state
CHANGES_REQUESTED) added the formula-inspector views in the **old imperative-DOM
style**, before the conversion:
- `packages/chat/formula-view-component.js`
- `packages/chat/value-component.js`
- `packages/chat/formula-view-registry.js`
- imperative wiring + DOM split in `packages/chat/chat.js`
- `packages/chat/index.css` (card-flip animation)

PR #440's base `llm-6d889af` is a frozen snapshot that **predates** the
conversion: it has `preact-container` but is missing `space-channel`,
`space-chat`, `spaces-util` (confirmed via `git ls-tree`). So the preact infra
is not even reachable from the current base.

## The work

1. **Advance the base.** Re-snapshot the frozen base to a current `llm-<sha>`
   that includes #516/#471 (per `skills/frozen-base-branch/SKILL.md`), then
   rebase `feat/formula-inspector` onto it. Expect non-trivial conflicts in
   `chat.js`: #516 deleted the imperative outliner and split `chat.js` into the
   `space-*` packages, and #440 also edits `chat.js`.
2. **Rewrite the views to confined Preact.** Convert the three formula-inspector
   components to render through `renderConfined` following the post-#516 pattern
   (study `space-channel`/`space-chat` and the value/inventory components on
   current `llm`). The formula back-face renders daemon-supplied `FormulaRecord`
   data, including untrusted property values and pet names — these MUST go
   through `renderConfined` (the conversion's whole point is closing XSS on
   untrusted interpolation). Keep the keypair `privateKey` suppression.
3. **Port the tests** (`test/component/formula-view-component.test.js`,
   `test/component/value-component-flip.test.js`,
   `test/unit/formula-view-registry.test.js`) to the new component shape; keep
   the `test.fixme` e2e stub.
4. **Also still owed on #440:** kriskowal's 2026-06-15 CHANGES_REQUESTED is open;
   fold any still-unaddressed asks into the same pass if cheap, else note them.
5. Post a top-level summary comment on #440 (head SHA, what changed, verification:
   `yarn ava`/lint/types in `packages/chat`) per the completion-summary norm.
   Commenting is standing-authorized on this repo.

## Notes

- This is builder + weaver work (rebase across a moved base, then a framework
  rewrite). A single gardener can supervise both; consider doing the base-advance
  rebase first, confirm the chat package builds on the new base, then rewrite.
- Branch/identity: kriscendobot. Do NOT involve kriskowal/boatman; this stays on
  the bot fork's PR branch.
