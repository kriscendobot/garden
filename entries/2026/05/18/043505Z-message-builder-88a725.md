---
ts: 2026-05-18T04:35:05Z
kind: message
role: builder
to: liaison
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

# Builder impasse: `chat-edit-message-ui.md` dep PR #125 still open

## What I was asked to do

Dispatch `dispatches/builder--ab96fc/`: implement
`designs/chat-edit-message-ui.md` on the `llm` branch of
`endojs/endo-but-for-bots`. The dispatch prompt described
`editMessage` / `messageHistory` as "already shipped per #23".

## What I found

PR #23 (the original `feat(daemon): add editMessage and messageHistory`)
was **closed without merging** on 2026-05-07. The re-opened version is
PR #125 ("re-opened from #23 under the bot"), **OPEN** against `llm`
with all 21+ CI checks green (last green run 2026-05-13). The merge
has not happened.

A grep across the live `llm` HEAD (`68246ad9`) for `editMessage` and
`messageHistory` returns zero matches in source. The methods exist
only on PR #125's head SHA (`128acba7d`), which adds them to mailbox,
host, guest, the least-authority guest exo stub, HandleInterface
(receiveEdit/openEdit), the LAL agent surface, the FAE agent surface,
and TODO pointers in `packages/chat/{inbox,channel}-component.js`
referencing a follow-up issue #203 for the recipient-side in-place
swap (separate concern from the sender-side affordances this design
covers).

Per builder norms in `roles/builder/AGENT.md`:

> **Check `Depends On` against the roadmap annotation.** A design
> that lists no dependencies but whose roadmap row reads "needs X"
> is under-declared; treat the roadmap annotation as authoritative
> and stop at impasse if the prerequisite is not yet built.

The design's Dependencies table cites the cap surface as "Implemented
in PR #23"; in reality the prerequisite implementation is still
in-flight as PR #125. This is the impasse case.

## Options I considered

1. **Stack on PR #125** per `skills/stacked-pr-build/SKILL.md`. The
   skill applies; PR #125 has green CI and the dispatch's implicit
   push + draft-PR-open authorization would cover the merge-and-push
   shape. Risk: judge panel would review both daemon API and chat UI
   together; if the maintainer is iterating on the daemon API in
   #125, my stacked PR's tests can churn against a moving base.

2. **Wait for PR #125 to merge first** and re-dispatch. Cleanest
   review surface (one feature, one PR), but blocks on a PR that
   appears to have been parked for five days (last commit
   2026-05-13).

3. **Build a stub that fails gracefully** when the daemon does not
   yet expose `editMessage`. Costly to write a real stub (the
   editor's whole purpose is the cap call); not really an
   implementation.

I did not pick. Per the dispatch's standing instruction ("if you hit
an impasse… stop and surface, don't fabricate"), routing this to the
liaison so the maintainer can decide.

## Specifically what the maintainer should pick

- (a) Land PR #125 first, then re-dispatch the builder on this design
      against the new `llm` HEAD.
- (b) Authorize the builder to stack on #125 per `stacked-pr-build`,
      acknowledging the moving-base risk.
- (c) Update `designs/chat-edit-message-ui.md`'s Dependencies row to
      cite #125 explicitly (currently still cites the closed #23),
      so a future builder gets the correct pointer.

## Adjacent open question that needs an answer either way

`designs/chat-edit-message-ui.md` § Open questions §1 names a
slash-command name collision with the existing shipped `/edit`
(blob editor, lives in `packages/chat/command-registry.js` and is
documented in the sibling design `chat-view-edit-commands.md`).

The design body uses `/edit` and lists three resolutions
((a) rename one of the two to `/revise` / `/amend` / `/edit-message`
or `/open` for the blob editor; (b) overload on argument type;
(c) ship this design first and rename the blob editor later). The
existing `/edit` is already shipped, so resolution (c) is no longer
available; the choice is (a) or (b). The dispatch prompt did not
resolve this.

Recommendation if option (a) is picked: `/edit-message` for this
new command and leave the existing `/edit` (blob editor) alone.

## Repo state at impasse

- `project/` worktree on `llm` HEAD `68246ad9`. No commits made; no
  branch created; no pushes.
- `pr-125` ref fetched locally for inspection; it can stay or be
  cleaned up by `dispatch-teardown.sh`. No upstream interaction.
- Journal: this entry. No `result` entry.

## What I recommend the liaison do

1. Re-issue once the question resolves: either rebase the dispatch
   against post-#125 `llm` HEAD (option a), or include
   `authorized: stack-on-PR-125` in the next builder prompt
   (option b).
2. Land the design's Dependencies fix as a small editorial commit
   regardless (point at #125, mark #23 as the closed source).

Self-improvement: nothing this time. The "design dependency lists a
closed PR" pattern is already addressed by the builder's existing
*Pre-flight design-status drift* and *Check `Depends On` against
the roadmap annotation* norms; the dispatch just needed the impasse
surfaced.
