---
ts: 2026-05-15T03:05:21Z
kind: result
role: liaison
project: garden-library
refs:
  - entries/2026/05/15/030521Z-message-liaison-21a158.md
  - entries/2026/05/15/030521Z-message-liaison-8b23df.md
---

# Liaison: first *notice / investigate / propose* pass on the chat-spaces numbering case

## Maintainer ask (2026-05-15)

> *"Since you are beginning to notice inconsistencies, it might be
> good to search the source for a ground truth or whether the
> inconsistencies reflect inconsistencies among different parts of
> the code. Let's make it part of your job to notice, investigate,
> and propose corrections in pull requests."*

Extends the scholar role from passive *noticing* to active
*investigating against source* and *proposing PRs upstream*.

## What this dispatch did

### 1. Investigated the chat-spaces numbering case

The cycle-57 result entry said *"chat-spaces-home corrects
chat-spaces-gutter on numbering"*. Investigation against
`packages/chat/spaces-gutter.js` on `endojs/endo-but-for-bots` `llm`
branch reveals the opposite:

- **Source** implements: `Cmd+1` = home, `Cmd+2..9` = first 8 user
  spaces, no `Cmd+0`. The handler at lines ~907-921 uses
  `allSpaces = [homeSpaceConfig, ...getSpacesArray()]` and
  `index = num - 1` with an explicit `num < 1 || num > 9` guard.
- **chat-spaces-gutter design** matches source.
- **chat-spaces-home design's** *Numbering Scheme* table lists
  `Cmd+0 = home`, `Cmd+1..9 = user spaces` — this is target state,
  **not implemented**. The design's own indelible-invariant table
  also lists *"keyboard shortcut Cmd+0"* (inconsistent with what
  the design implements via `HOME_SPACE_DEFAULTS` + the source's
  handler).
- The chat-spaces-home design is therefore *internally inconsistent*:
  its `spaces/0` storage scheme is real; its `Cmd+0` keyboard scheme
  is aspirational.

Cycle 57 drew the wrong conclusion from the documents. Investigation
against source corrects it.

### 2. Corrected the library

Three library files updated to reflect source as ground truth:

- **`chat-spaces-gutter/interactions-keyboard-and-future`** — the cycle-57 corrective See-also (which claimed *"the keyboard handler shown above is out of date"*) is rewritten. The handler shown IS the source-of-truth; what's out of date is *the chat-spaces-home design's table*.
- **`chat-spaces-home/indelible-space-zero-and-numbering`** — the *"Numbering scheme (and the correction to chat-spaces-gutter)"* subsection is rewritten to *"Numbering scheme — design intent vs. current source"*. Distinguishes the config-key column (matches source) from the Shortcut column (aspirational). Frontmatter `notes` rewritten. The indelible-invariant table's *"Always first"* row no longer claims `Cmd+0`.
- **`space` concept page** — the *Numbering and keyboard shortcuts* subsection and the *Common confusions* block were rewritten to reflect ground truth and flag the previous-cycle misframing as exactly the kind of confusion the concept page should warn against.

### 3. Drafted the upstream PR proposal

Sibling missive `030521Z-message-liaison-21a158.md` to boatman
proposing two resolutions:

- **Option A** (docs-only): edit `designs/chat-spaces-home.md` so its Numbering Scheme table matches source (`Cmd+1` = home, `Cmd+2..9` = user spaces); fix the strikethrough-on-shipped roadmap item in `designs/chat-spaces-gutter.md` enhancement #5; fix the *"Always first"* invariant row.
- **Option B** (code change): edit `packages/chat/spaces-gutter.js` to add `Cmd+0` and shift shortcuts; add tests; align source to design intent.

Both options are small. The maintainer picks; the boatman ferries.

### 4. Drafted the scholar AGENT.md update

Sibling missive `030521Z-message-liaison-8b23df.md` to gardener
proposing a *"Notice, investigate, propose"* section in
`roles/scholar/AGENT.md` formalizing the discipline. Key
constraint: scholar does NOT open upstream PRs directly — scholar
diagnoses and drafts; boatman ferries with maintainer authorization.

## What this changes about the scholar's job

The new responsibility is:

> When a cycle surfaces an inconsistency, *follow it to source*. If the design is wrong, draft a correction-PR message to boatman. If the code is wrong, draft a builder dispatch description for the maintainer to authorize. The library itself gets corrected as part of the investigation — source-of-truth as the library's frame, design statements as the *claims* that may or may not match.

This is the same shape as the cycle-52 library-bug-fix work
(round-2 A/B follow-up) applied **outward** to the source corpus,
not just inward to the library.

## Why I (liaison) did this rather than scholar

Three reasons:
1. The user was in the loop with a directional message; reacting
   inline produced a faster proof-of-concept than waiting for the
   next scholar cycle.
2. The cycle-57 error I needed to correct was mine to fix; I'd
   stated it confidently when I shouldn't have.
3. The first instance of any role expansion is liaison-appropriate
   — calibrate the shape, then let the autonomous role inherit it.

Future investigations of this kind belong to scholar's autonomous
cycle. The gardener missive formalizes that hand-off.

## Library state

- Sources: 105 (unchanged).
- Sections: 466 (unchanged in count; 2 edited).
- Concepts: 21 (unchanged in count; 1 edited).
- Topics: 26 (unchanged).
- Roles: 3 (unchanged).
- Keywords: ~211 (unchanged).

## Notes for future cycles

- The Q5 syrup-record-positionality case (cycle 52) was the first instance of *notice + library-side correction* of an upstream-design error; this cycle's chat-spaces case extends it to *notice + investigate + propose-PR*. Future investigations should follow the same pattern.
- The `space` concept page now has a substantive *Common confusions* block — a worked example for future concept pages where source-vs-design tensions are likely.
- The boatman missive is open work; nothing fires upstream until the maintainer picks Option A or Option B.
- The gardener missive is open work; the scholar AGENT.md edit lands when the gardener's next cycle picks it up.
