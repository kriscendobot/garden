**book-copyedit: completion report**

I copy-edited all ten chapters, republished the book, and opened draft PR kriscendobot/garden-book#1 with the changes. The PR has had no review: I did not post a gauntlet for it.

**New edition:** https://7uzjtuxvwf7m6dcqjhrvdxuv7wr43245b5pgypkvrtqqudpoepsa.ocap.site/ (returns HTTP 200 and shows the "Edition of 2026-10-03, copy-edited" title page). I also sent this URL with `message-user.sh book-copyedit`.

**Where the work happened.** Since this job was first claimed, the book moved from `journal/projects/garden-book/` to its own repo, `kriscendobot/garden-book`. The journal copy is gone, and the project's rules say changes land as PRs. The earlier, interrupted attempt had edited the journal copy, and those edits were lost in the move, so I redid the whole pass in the new repo:
- I made the bare clone `worktrees/kriscendobot-garden-book.git` and worked in an isolated per-job worktree.
- The changes are on branch `book-copyedit`.
- The PR is against a frozen base, `main-bab8e7b`, because `ensure-pr.sh` refuses a floating `main`.

**The pass.** Five editors each took a group of chapters and read them in full, making about 1,900 line-level changes. It was a prose and structure pass, with no facts added or removed:
- **Terminology:** each mechanism now has one name across chapters (fix-loop, un-draft, jury seat, per-job worktree, the board, the bus). `rolling-deploy.sh` is now "the rolling deployer", because "conductor" is also the name of the merge role.
- **Tense, voice and audience:** present tense for how things work, past tense for history. Where the text addressed "you, the maintainer" it now refers to the maintainer in the third person, as the project README asks.
- **Cross-references:** I added many chapter and § pointers, including into chapters 9 and 10. Every § reference points to a real heading, and the built book has no broken in-book links.
- **Repetition:** material explained in several chapters now has one home that the others point to:
  - the sysop and the foreman brake: chapter 2 for the architecture, chapter 8 for the control loops
  - tiers: chapter 10
  - the gauntlet and the panel: chapter 7
  - the container guard: chapter 4
  - plan gates: chapter 2
- **Structure:**
  - chapters 9 and 10 now have numbered sections
  - chapters 8, 9 and 10 have a Contents list
  - the quick-reference sections of chapters 7 and 8 are numbered
  - I cut chapter 6's "Coverage status" section, which was a note between the original authors rather than for readers
  - one broken link to a skill in chapter 6 and several in chapter 5 now point to their entries in the book
- **House style:** no em-dashes in prose (the only ones left are inside verbatim quotes) and no Latin shorthand.
- **Edition history:** `build/README.md` lists the new edition at the top with the earlier ones kept below it, and `intro.html` has a new edition note.

**Follow-ups**
- **Review and merge:** say "run the gauntlet kriscendobot/garden-book#1" to have it reviewed before merging.
- **Factual gaps the editors flagged but left alone**, since this was not a fact-checking pass:
  - chapter 5 has no `accountant` entry
  - chapter 8 § 8.7 still describes the accountant as not yet existing
  - role files name the skills `ci-status-summary` and `ci-runtime-comparison`, which don't exist
  - chapter 10 and the text cut from chapter 8 disagreed on which roles have a mentor floor; that text had only designer and builder
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-copyedit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 78 tokens (3518383 cached reads)
- Output: 27778 tokens
- Cost: $17.878678799999996
- Wall-clock: 973s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
