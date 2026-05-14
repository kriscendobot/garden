---
ts: 2026-05-14T19:54:32Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: builder lands ses-import-attributes design as draft PR on llm

Dispatch root: `dispatches/builder--8c11f7/`. Project worktree on `endojs/endo-but-for-bots@llm` (detached).

The import-attributes design landed today (designer dispatch `96bd08`) as `journal/projects/endo/drafts/ses-import-attributes.md`. Per the maintainer's policy update 2026-05-14, this builder transcribes the preserved design into a draft PR on `endojs/endo-but-for-bots@llm`.

## Per-action authorization

Standing on endo-but-for-bots: push the branch + open the draft PR.

## Task

1. Read the design at `<garden>/../../journal/projects/endo/drafts/ses-import-attributes.md`.
2. Create a branch `design/ses-import-attributes` off `endojs/endo-but-for-bots@llm`.
3. Copy the design verbatim into `designs/ses-import-attributes.md` on the new branch. If the project's `designs/` directory has a README index, append a row.
4. Commit with message `design(ses,module-source): import-attributes proposal`. One commit.
5. Push to `design/ses-import-attributes`. Open the PR with `gh pr create --base llm --draft --title 'design(ses,module-source): import-attributes proposal' --body <body referencing the design file and noting medium priority>`.
6. Do NOT un-draft. Do NOT request a reviewer.

## Out of scope

- No code in `<project>/packages/`.
- No PR title/body rewriting beyond what is named here.
- No second PR for the TLA design; that is its sibling builder dispatch (`46ee5a`).

## Report

≤ 200 words: PR URL, branch head SHA, file path, one-line `Self-improvement: ...`.
