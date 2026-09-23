---
ts: 2026-05-19T02:37:10Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs: []
---

PR #288 title and description updated to match the renamed `@endo/cbor-frame` package per the maintainer's directive at https://github.com/endojs/endo-but-for-bots/pull/288#issuecomment-4483922372.

Actions (part a of the directive):

- `gh pr edit 288 --title` set to `feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing`.
- `gh pr edit 288 --body-file`: replaced every `@endo/cbors` with `@endo/cbor-frame`, `packages/cbors/` with `packages/cbor-frame/`, `makeCborsReader` with `makeCborFrameReader`, `makeCborsWriter` with `makeCborFrameWriter`, test path `packages/cbors/test/cbors.test.js` with `packages/cbor-frame/test/cbor-frame.test.js`, and changeset path `.changeset/add-endo-cbors.md` with `.changeset/add-endo-cbor-frame.md`. Prose structure, RFC 8949 links, design-doc reference, deferral list, and test-plan checklist preserved verbatim; only the names changed. The three remaining `designs/cbors.md` path mentions are intentional (the design file itself was not renamed on the branch).
- Reply posted on the maintainer comment thread (https://github.com/endojs/endo-but-for-bots/pull/288#issuecomment-4483933172) acknowledging the title/description update and noting the standing-instructions revision (part b) is routed to gardener via a separate journal message handled by the orchestrator.

Dispatch scope was strictly part (a). Surfaced for the orchestrator (not acted on here): the changeset file on the branch is still named `.changeset/add-endo-cbors.md` and its inner YAML still declares `'@endo/cbors': minor` with prose body referencing the old `@endo/cbors` / `makeCborsReader` / `makeCborsWriter` names. The PR description now describes the post-rename state, so the changeset is a real source-of-truth drift on the branch that a follow-up fixer or shepherd dispatch should reconcile (rename the changeset file to `add-endo-cbor-frame.md`, update the YAML key and prose names). Flagging because the next jury / CI cycle will see the mismatch.

Self-improvement: nothing this time.
