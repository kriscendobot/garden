---
ts: 2026-06-13T00:49:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--41ce63
prs:
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/439
  - https://github.com/endojs/endo-but-for-bots/pull/439#pullrequestreview-4490090195
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/153600Z-result-designer-6d2dcd.md
---

# dispatch: designer — apply kriskowal CHANGES_REQUESTED on consolidated formula-inspector.md (#439)

Second round of maintainer review on PR #439's consolidated
design doc. Prior designer `6d2dcd` did the consolidation +
@info-drop. Now kriskowal returns with CHANGES_REQUESTED
(review `4490090195`, body empty, 6 inline asks).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#439`, DRAFT, base `llm`,
  head `design/chat-value-modal-formula-view` at `8cf914a62`
  (dispatch-prepare picked up the prior head — FETCH if a
  newer head exists).

## Inline asks (per `Fetch ALL inline comments tied to a
review` rule; tied to review `4490090195`)

1. **`designs/formula-inspector.md:25`** (id `3406942548`):
   > This can be omitted.
2. **Line 109** (id `3406948310`) — **THE BIG ASK**:
   > We only need one surface. Please consolidate these.
   > Particularly, the gear icon is a good idea to flip from
   > Value to Formula. There should be a corresponding button
   > to flip back. Reaching the formula view directly from
   > the inventory is good, too. While one formula captures
   > state, we do not need these to be user editable at this
   > stage of development.
   
   Translation:
   - **One surface, not two**. The dual modal-back-face +
     dedicated panel approach from the prior designer's
     consolidation is wrong. Pick one.
   - **Gear icon flips Value → Formula** (the original
     `chat-value-modal-formula-view.md` proposal was
     directionally right).
   - **Corresponding button flips back** (Formula → Value).
   - **Direct reach from inventory** is good (preserve).
   - **Drop edit mode** ("we do not need these to be user
     editable at this stage of development"). The
     formula-inspector.md design's edit toggle goes away.
3. **Line 417** (id `3406950479`):
   > These can be elided as well since we have not yet
   > committed to compatibility.
   
   Likely backward-compat sections to remove (the @info
   compatibility-window discussion?).
4. **Line 436** (id `3406951046`):
   > Omit.
5. **Line 438** (id `3406955796`) — guidance, not removal:
   > I expect this to be a simple animation. However, if
   > animation becomes any more complex, please take design
   > cues from
   > https://github.com/kriskowal/peruacru/blob/master/animation.js
   
   Keep the animation simple; defer complexity to
   peruacru/animation.js as reference if it grows.
6. **Line 441** (id `3406956437`) — positive ack:
   > Shift+P is worth a try.
   
   Preserve the Shift+P proposal.

👀 reactjis posted on all 6 inline asks.

## Task

In your `project/` worktree on
`design/chat-value-modal-formula-view`:

1. **FETCH the latest head** before starting (if newer than
   `8cf914a62`).
2. **Read** `designs/formula-inspector.md` in full +
   the prior designer `6d2dcd`'s result entry.
3. **Address each inline ask in order**:
   - **Ask 1** (line 25 omit): inspect the section/lines at
     line 25; remove per the ask. Reply on the thread with
     "removed at <commit-sha>".
   - **Ask 2** (line 109 single-surface): this is the big
     architectural change. Rewrite the design around ONE
     surface, the modal back-face (the original PR's
     framing). Drop the dedicated wrench/gear panel.
     Specify:
     - Gear icon on Value modal → flips to Formula view.
     - Corresponding button on Formula view → flips back
       to Value.
     - Direct entry from inventory preserved.
     - **No edit mode**. The 33-formula-type taxonomy
       remains read-only.
   - **Ask 3** (line 417 elide compat): inspect; remove.
     Likely the @info deprecation-alias discussion (since
     "we have not yet committed to compatibility").
   - **Ask 4** (line 436 omit): inspect; remove.
   - **Ask 5** (line 438 animation): keep simple; add a
     note pointing at
     `https://github.com/kriskowal/peruacru/blob/master/animation.js`
     as the reference if complexity grows.
   - **Ask 6** (line 441 Shift+P): preserve. Reply with
     a "noted, kept" ack.
4. **Update** `designs/README.md` if the size/complexity
   shifted (single-surface design likely smaller than the
   dual-surface).
5. **Commit per logical step** — at minimum:
   - `docs(designs): collapse formula-inspector to single
     modal back-face surface per kriskowal review`
     (the big ask).
   - `docs(designs): elide @info compatibility window per
     kriskowal review`.
   - `docs(designs): omit minor sections + add peruacru
     animation reference per kriskowal review` (asks 1,
     4, 5 bundled).
6. **Push** to `design/chat-value-modal-formula-view`
   (append push only).
7. **Reply on each inline thread** citing the addressing
   commit SHA. Brief positive acks on asks 5 + 6.
8. **Post a top-level summary** on PR #439 at-mentioning
   `@kriskowal`.
9. **Re-request review** from kriskowal.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to
  `design/chat-value-modal-formula-view` (append push only).
- **Reply on inline threads**. Standing.
- **Top-level summary comment** on PR #439.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT add new substance beyond the 6 inline asks.
- Do NOT rebase or force-push.
- Do NOT touch source under `packages/`.

## Deliverable

A `result` entry under `journal/entries/2026/06/13/` naming:

- Pre/post branch tip SHAs.
- Per-ask resolution: what was removed / changed / preserved.
- The single-surface rewrite's key shape changes.
- Designer-level decisions if any (e.g., which specific
  text at line 25 / 436 was omitted; how the gear-flip
  semantics were specified).
- The 6 inline-thread reply URLs.
- The top-level summary comment URL.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
