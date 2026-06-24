---
ts: 2026-06-18T08:35:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--7da62d
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 450
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/450
  - https://github.com/endojs/endo-but-for-bots/pull/450#pullrequestreview-4519898190
---

# dispatch: designer — #450 presence-severance-observation r2 (kriskowal CHANGES_REQUESTED)

kriskowal CHANGES_REQUESTED on #450 (2026-06-17 21:56:55Z)
with 5 inline asks on `designs/presence-severance-observation.md`.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#450`, DRAFT, base `llm`, head
  `design/presence-severance-observation` at `4f4546f09`.

## Inline asks

1. **Line 190** (comment 3431693753): "I believe these are
   synonymous." → merge the two concepts under one name.
2. **Line 192** (comment 3431694725): "Correct." → acknowledge;
   no change needed but reply to confirm.
3. **Line 194** (comment 3431697617): "We simply will not pursue
   this. Being able to forget severed presences after partition
   is a garbage collection feature." → DROP this section from
   the design.
4. **Line 198** (comment 3431702776): "If we are to address this,
   we will address it with abstractions in the network transport
   layer that prolong the duration of a logical session to
   straddle multiple physical sessions, or simply create
   sessions from a sessionless transport layer." → REWRITE this
   section with the maintainer's suggested approach.
5. **Line 202** (comment 3431704649): "Returning a promise is
   sufficient." → SIMPLIFY the API at this point to just return
   a promise.

## Task

In your `project/` worktree at `4f4546f09`:

1. Read `garden/roles/COMMON.md`, `garden/roles/designer/AGENT.md`.
2. Read the existing design at
   `designs/presence-severance-observation.md` in full,
   especially lines 180-210 for the context around the 5 asks.
3. Revise per the 5 asks above (in order). Use judgment on
   exact prose; keep maintainer intent intact.
4. For ask #1 (synonymous concepts): identify which two
   concepts kriskowal means + collapse to one.
5. For ask #3 (drop section): remove the "forget severed
   presences after partition" path entirely; replace with a
   one-sentence acknowledgment that it's a GC feature, out of
   scope for this design.
6. For ask #4 (network transport): rewrite the partition
   section to favor the transport-layer approach kriskowal
   described.
7. For ask #5 (promise is sufficient): simplify the API.
8. Reply inline on each of the 5 comments confirming the
   change + citing the new commit SHA.
9. Run pre-push-gates.
10. Commit: `design(presence-severance-observation): address kriskowal r1 review (5 asks)`
11. Push to `design/presence-severance-observation` (append-only).

## Authorizations

- Push commits to `design/presence-severance-observation` (append-only).
- Inline replies on 5 comments.

## Out of scope

- Do NOT mark PR ready (still DRAFT; solicitor handles).
- Do NOT touch other PRs.

## Deliverable

A `result` entry per the standard designer shape:
- Pre/post head SHAs.
- Per-ask address summary.
- Inline reply URLs.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: solicitor` for r2 panel.

End your turn with a concise summary back to the orchestrator.
