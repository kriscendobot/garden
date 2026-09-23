---
ts: 2026-05-14T19:54:32Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: builder lands ses-top-level-await design as draft PR on llm

Dispatch root: `dispatches/builder--46ee5a/`. Project worktree on `endojs/endo-but-for-bots@llm` (detached).

The TLA design landed today (designer dispatch `759853`) as `journal/projects/endo/drafts/ses-top-level-await.md`. Per the maintainer's policy update 2026-05-14 ("the designer should in general open pull requests against the llm branch when producing a draft"), this builder transcribes the preserved design into a draft PR on `endojs/endo-but-for-bots@llm`.

## Per-action authorization

Standing on endo-but-for-bots: push the branch + open the draft PR.

## Task

1. Read the design at `<garden>/../../journal/projects/endo/drafts/ses-top-level-await.md` (the dispatch root's journal worktree has it under `journal/projects/endo/drafts/ses-top-level-await.md`).
2. Create a branch `design/ses-top-level-await` off `endojs/endo-but-for-bots@llm`.
3. Copy the design verbatim into `designs/ses-top-level-await.md` on the new branch. The file's frontmatter / metadata table is already set by the designer; no edits to body. If the project's `designs/` directory has a README index that lists current designs, append a row for the new design.
4. Commit with message `design(ses,module-source): top-level-await proposal (leads with the test suite)`. One commit.
5. Push to `design/ses-top-level-await`. Open the PR with `gh pr create --base llm --draft --title 'design(ses,module-source): top-level-await proposal' --body <body referencing the design file and noting low priority>`.
6. Do NOT un-draft. Do NOT request a reviewer (this is a draft for later maintainer triage).
7. Standing comment authorization applies; post a one-line summary comment on the PR if the build expects it (e.g., crosslink to the journal draft path). Optional; if no value, skip.

## Out of scope

- No code in `<project>/packages/`.
- No PR title/body rewriting beyond what is named here.
- No second PR for the import-attributes design; that is its sibling builder dispatch (`8c11f7`).

## Report

≤ 200 words: PR URL, branch head SHA, file path, one-line `Self-improvement: ...`.
