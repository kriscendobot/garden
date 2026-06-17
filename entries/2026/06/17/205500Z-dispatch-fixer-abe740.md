---
ts: 2026-06-17T20:55:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--abe740
prs:
  - repo: endojs/endo-but-for-bots
    pr: null
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3427486065
  - https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3425079666
---

# dispatch: fixer — add Moddable XS row to immutable-arraybuffer README per erights + phoddie

erights' ask on PR #435 (now merged at `855a8f7bc`):

> 2026-06-17T01:49Z: "@kriscendobot, can you gather enough info on Moddable XS to add to the table? attn @phoddie"
> 2026-06-17T10:44Z (r3427486065): "@kriscendobot please add XS according to the info above from @phoddie. It is ok if approximate."

phoddie's reply with version info:

> 2026-06-17T03:17Z: "XS has had both `ArrayBuffer.prototype.transferToImmutable()` and `structuredClone()` for some time."
> 2026-06-17T04:01Z: "structuredClone was 4 years back, according to Git. Immutable stuff was when we got Stage 1."

## State at dispatch time

- **master**: `4a04d078b` (does NOT yet have PR #435).
- **master-4a04d07**: `855a8f7bc` (PR #435 merged into frozen base; live master will unfreeze in a future conductor pass).
- **PR #435**: MERGED, closed. Need a new PR for the XS-row addition.

## Task

In your `project/` worktree at `855a8f7bc`:

1. Read `packages/immutable-arraybuffer/README.md` to find the version-thresholds table that fixer e9696a added.
2. Add a row for **Moddable XS** to the engine table:
   - `structuredClone`: ~2022 (per phoddie "4 years back, per Git"). Approximate is OK — note "approximate" if uncertain.
   - `ArrayBuffer.prototype.transferToImmutable`: native at Stage 1 advance (~2023). Approximate.
   - Note: XS is unique in having native `transferToImmutable` (the others rely on the polyfill).
3. Optionally update prose to note XS coverage in the support narrative.
4. Open a new DRAFT PR from a new branch `docs/immutable-arraybuffer-xs-row` based on `master-4a04d07`:
   - Title: `docs(immutable-arraybuffer): add Moddable XS row to support table per phoddie info`
   - Body: cite erights' ask + phoddie's info + note approximation rationale.
5. @-mention @erights @kriskowal @phoddie in the PR body.
6. Reply on discussion `r3427486065` with link to the new PR.

## Authorizations

- Push to new branch `docs/immutable-arraybuffer-xs-row`.
- Open new DRAFT PR.
- Inline reply on r3427486065.

## Out of scope

- Do NOT touch any existing PR.
- Do NOT touch upstream endojs/endo.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- New PR number + URL + head SHA.
- XS row data + rationale.
- Inline reply URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (erights/phoddie/kriskowal review).

End your turn with a concise summary back to the orchestrator. 10-15 min job.
