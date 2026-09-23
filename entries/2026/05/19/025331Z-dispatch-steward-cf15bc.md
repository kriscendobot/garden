---
ts: 2026-05-19T02:53:31Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 288
    role: target
---

# Dispatch: fixer on #288 — CHANGES_REQUESTED by kriskowal (17 inline comments)

kriskowal submitted formal review at 2026-05-19T02:52:13Z with state
`CHANGES_REQUESTED` and 17 inline comments. Dispatch root:
/home/kris/dispatches/fixer--7e0c14 on branch `feat/cbors-package`, head `c06186c2e`.

**Per-action authorizations carried**:
- Reply on each inline review thread.
- Top-level summary comment citing the addressing SHAs.
- `gh api .../requested_reviewers` re-request after CI converges.
- Push to `feat/cbors-package` via `git push origin HEAD:feat/cbors-package`.
- Standing broad authorization on endojs/endo-but-for-bots covers PR/issue comments.

**Out-of-scope for this fixer** (route via separate steward messages
to liaison; NOT this fixer's job):

1. **@endo/bytes import on `llm` branch**: kriskowal note on
   `test/cbor-frame.test.js:29` — *"This can be imported from `@endo/bytes`
   which has landed on master. If that is not already on the `llm`
   branch, please dispatch a weaver to update `llm` and, when that is
   done, rebase this change to t..."*. This is a weaver-dispatch ask
   that depends on llm branch state — surface via message.
2. **Builder PR for `@endo/stream` utility**: kriskowal on
   `test/cbor-frame.test.js:37` — *"Please dispatch a builder to create
   a PR that adds this to the utilities provided by `@endo/stream`,
   but without the slice. We will leave this as is, but consider
   making a note that this should be ref..."*. Builder-dispatch ask;
   surface via message.
3. **Style guide / future-builder notes** (several items request
   "Make a note in the style guide" or "Make a note for future
   builders"). The fixer applies the local edit per each note; the
   style-guide encoding is gardener-shaped and routes via a separate
   message after the fixer pass lands.

**Fixer scope (this dispatch)**: address every inline comment that is
a local edit on this PR — see the brief.
