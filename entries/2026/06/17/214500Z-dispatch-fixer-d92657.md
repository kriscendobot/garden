---
ts: 2026-06-17T21:45:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d92657
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/449
---

# dispatch: fixer — kriskowal 2 + erights view[0]=42 asks on PR #449

After fixer a58c91 addressed solicitor's panel verdict, NEW inline asks arrived:

## kriskowal 2 inline asks (2026-06-17T21:28-21:29Z)

1. **`packages/immutable-arraybuffer/src/lib.js:1`**: "Let's instead introduce a designs directory, designs/README.md index, and the two composite designs."
   - Move `packages/immutable-arraybuffer/DESIGN-immutable-arraybuffer.md` → `packages/immutable-arraybuffer/designs/immutable-arraybuffer.md`.
   - Move `packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md` → `packages/immutable-arraybuffer/designs/freezable-typedarray.md`.
   - Add `packages/immutable-arraybuffer/designs/README.md` index referencing both.
   - Update lib.js + cross-references.

2. **`packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md:29`**: "I believe we will be able to withdraw adapters for frozen Uint8 arrays backed by frozen immutable ArrayBuffer from `@endo/bytes` as the shim presents as sufficiently ergonomic without utility function..."
   - Add a note in the design about the future adapter withdrawal possibility.

## erights ask (2026-06-17T21:33Z, discussion `r3431601526`)

> "@kriscendobot remind me, how do we achieve `view[0] = 42; view[0]` ?"

- Clarify the indexed-assignment semantics in the design. The design's current text says "indexed assignment silently swallowed (per proposal-level constraint)". erights is asking: if `view[0] = 42` is silent-swallow, what does `view[0]` return after? Is it the original value or 42? Both?
- Add a worked example: `const view = new FreezableUint8Array(frozenBuffer); view[0] = 42; console.log(view[0]);` showing the result + brief rationale.
- If there's more erights inline activity since 21:33Z, address those too.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#449`, DRAFT, base `master-4a04d07`, head `6f7526a4a`.

## Task

In your `project/` worktree at `6f7526a4a`:

1. Enumerate all erights + kriskowal inline asks since 21:30Z via:
   `gh api repos/endojs/endo-but-for-bots/pulls/449/comments --jq '[.[] | select(.user.login == "erights" or .user.login == "kriskowal") | select(.created_at > "2026-06-17T21:25:00Z")]'`
2. Apply each ask. Most importantly:
   - Restructure into `designs/` subdirectory.
   - Add the `designs/README.md` index.
   - Add view[0] worked example to design.
3. Commit per logical group:
   - `chore(immutable-arraybuffer): move design files into designs/ subdirectory per kriskowal`
   - `design(immutable-arraybuffer): add view[0] worked example + adapter withdrawal note per erights/kriskowal`
4. Run pre-push-gates.
5. Push to `design/immutable-arraybuffer-freezable-typedarray-emulation` (append only).
6. Reply on each addressed inline thread with SHA.
7. Post top-level comment @-mentioning @kriskowal @erights with per-ask resolution.

## Authorizations

- Append-push.
- Inline replies + top-level comment.
- Do NOT touch upstream endojs/endo.
- Do NOT un-draft (judge does that).

## Out of scope

- Do NOT re-open prior-addressed solicitor must-fix items.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- Pre/post head SHAs.
- Per-ask resolution + commit SHAs.
- pre-push-gates result.
- Inline reply URLs + top-level comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: solicitor` for re-run.

End your turn with a concise summary back to the orchestrator.
