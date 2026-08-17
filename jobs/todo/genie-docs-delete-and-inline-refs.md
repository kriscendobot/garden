---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800

Repo: endojs/endo-but-for-bots (base `llm`)

MAINTAINER DECISION (kriskowal, 2026-08-17): delete the `PLAN/`, `TODO/`, and
`TADA/` directories from `llm`. For every reference to them elsewhere in the
tree, DELETE THE LINK and rephrase or remove the surrounding text so the salient
point is captured INLINE. Do NOT repoint the references anywhere: not at the
journal archive, not at git permalinks. The knowledge those citations pointed at
should live in the text that needed it.

Verbatim: "Delete the links. Rephrase or remove the surrounding text to capture
the salient point inline."

PRESERVATION IS ALREADY DONE, so deletion loses nothing:
- The content is archived, byte-identical, at `kriscendobot/garden` branch
  `journal2`, path `library/endo-but-for-bots/` (PLAN, TODO, TADA, plus a
  provenance README). That repo is PUBLIC and the copy is live. An earlier
  analysis called this a private journal; that was wrong.
- It also remains in this repo's own git history at commit `a54c3adb`.
- Verified counts: PLAN 11, TODO 1, TADA 172, so 184 files plus README. `llm` has
  not moved from `a54c3adb`.

THE WORK. A prior audit found 101 references across 43 files OUTSIDE the three
directories. Two distinct kinds, needing different judgment:

1. TEN BREAKING MARKDOWN LINKS, in `designs/`, `packages/genie/README.md`,
   `packages/genie/DESIGN.md`, `packages/sandbox/README.md`, and
   `packages/genie/AGENTS.md`. That last one is an AGENT-INSTRUCTION file, so
   treat it with extra care: an agent reading it must end up better informed, not
   left with a dangling gesture at something that no longer exists. For each,
   read what the linked document actually said, then rewrite the passage so a
   reader gets the point without the link.

2. ROUGHLY 91 CODE-COMMENT CITATIONS by doc number, across shipping genie and
   sandbox source and tests, in the shape
   `// Non-zero exits are data, not errors — see TADA/60`. Here the citation is
   usually a trailing provenance gesture on a comment that already states its
   point. Default to deleting just the citation clause and keeping the sentence.
   Where the citation was carrying the actual content (the comment does not make
   sense without it), inline the substance instead.

JUDGMENT, not sed. A blanket regex over `see TADA/\d+` will mangle comments where
the citation is the load-bearing half. Read each site. Where a reference was
purely decorative, remove it cleanly; where it carried meaning, inline that
meaning; where the surrounding prose only existed to introduce the link, remove
the prose too.

STAGE THE WORK, and land partial progress rather than failing wholesale. A prior
job on this PR family doomed at its wall. Order:
  (a) delete the three directories;
  (b) fix the 10 markdown links (highest value: these are the ones that actually
      break, and one is an agent-instruction file);
  (c) work the ~91 code comments.
If you approach your budget mid-(c), COMMIT what is done, open the PR, and report
precisely which files remain, so a follow-up can finish without re-deriving the
audit. Do not silently truncate: an unfinished pass reported honestly is a good
outcome; a half-done pass presented as complete is not.

PR note: state that the content is preserved in git history at `a54c3adb` and
archived publicly at `kriscendobot/garden@journal2:library/endo-but-for-bots/`,
and that references were dissolved inline rather than repointed, per maintainer
decision. Do NOT force merge.
