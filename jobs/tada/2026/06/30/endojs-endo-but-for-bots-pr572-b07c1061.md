Job complete.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #572 (design: `byteArray` maps a frozen `Uint8Array` view).

**The directive (re-fetched, treated as data):** kriskowal's inline reply at `designs/bytearray-uint8array-view.md:243` said "These are approved names." Tracing the thread: erights had deferred the design's **helper-naming** open question to kriskowal, and kriskowal's reply approves it. The names in question were the two helper vocabularies — wire-facing `byteArrayToHex` / `hexToByteArray` and JS-side `frozenBytes` / `thawnBytes`. "Approved names" = keep both, don't unify. This was the last of the design's three open questions still open (whole-buffer span and the #429/#57/#3226 disposition were already resolved earlier in the thread).

**What I did:**
- Created a detached worktree of endo-but-for-bots at the PR head (`c31c6a312`), edited the design doc to convert the helper-naming Open Question into **Design Decision 7 (keep both vocabularies)**, and removed the now-empty Open Questions section.
- Committed and pushed `886473696` to `design/bytearray-uint8array-view` (the PR branch) under the bot identity.
- Posted an inline reply on kriskowal's thread (#discussion_r3496468650) and a top-level summary comment (#issuecomment-4840318442) noting all three open questions are now decided and the design has no remaining open questions.
- Drained inbox (empty), removed the project worktree.

**State of the design after this:** fully resolved — no open questions remain. Decisions: (3) restrictive whole-buffer span, relaxation tracked on #573; (6) withdraw #429/#57/endojs/endo#3226 and open a fresh view-based PR; (7) keep both helper vocabularies.

**Follow-ups (already surfaced by earlier comments, not mine to execute):** the withdrawal of #429/#57 and the maintainer-coordinated closing of upstream endojs/endo#3226, plus opening the fresh implementation PR seeded from `feat/narrow-bytearray-to-uint8`. The PR remains DRAFT (it's a design doc); no code changes were involved.
