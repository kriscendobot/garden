---
gate: blocked
blocked_on: https://github.com/kriscendobot/garden-book/pull/8
priority: normal
role: builder
posted_by: researcher
posted_at: 2026-10-04T07:58:30Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Follow-up: make every reference in Better Code and Gardens an actual hyperlink

Repository: `kriscendobot/garden-book`.

This is the durable successor to `book-hyperlink-references-20261004`, which was
promoted before its independent prerequisite was ready. It is blocked directly
on https://github.com/kriscendobot/garden-book/pull/8.

## Preflight after promotion

Run:

```sh
gh pr view https://github.com/kriscendobot/garden-book/pull/8 --json state,mergedAt,isDraft
```

Do not infer readiness from the predecessor job's completion report. If PR #8
merged, proceed against current `main`. If it closed without merging, message the
maintainer with `scripts/jobs/message-user.sh
book-hyperlink-references-after-copyedit-20261004`, name the PR, and stop rather
than editing a document whose intended copy-edit did not land. If an unexpected
state is observed, park another blocked notice and preserve this full task.

Also confirm that the illumination and data/equilibrium productions from
`book-illumination-and-data-orch-20261004` landed on current `main`; the original
job was promoted after that orchestration reported terminal success.

## Task

Walk every chapter and reader-facing front matter, including the title page,
table of contents, and reader-facing edition history in `build/README.md`, for
text that functions as a reference but is not an actual hyperlink.

- Convert internal cross-references such as “as in Chapter 2,” “see the section
  on Cybernetics,” and “discussed above/below” into links to the real generated
  heading anchors. Read the post-PR-#6 generator and `build/README.md` to establish
  its actual anchor algorithm; do not guess slugs.
- Convert bare external references (PR/issue numbers, repo names, design-document
  names, and references to `endojs/endo-but-for-bots`, `kriscendobot/*`, or
  similar) to verified GitHub URLs. Use `gh api` or `gh pr view` where applicable;
  do not invent plausible but dead URLs.
- Link figure/illustration references to in-page image anchors where that makes
  sense.
- Leave ordinary narrative prose alone. Do not invent references that the text
  does not already make.

Build the current edition and mechanically check every internal link against the
anchors in the built output. Run all verification documented in
`build/README.md`.

Open one draft PR against current `main` through:

```sh
/home/kris/garden/scripts/jobs/gardening/ensure-pr.sh \
  book-hyperlink-references-after-copyedit-20261004 \
  kriscendobot/garden-book <head-branch> main --title T --body-file F
```

Use the per-job isolated project checkout from
`scripts/jobs/ensure-project-worktree.sh`. In the PR body and completion report,
state roughly how many references were converted and identify any deliberately
left plain because they were too vague to resolve uniquely. Once merged, publish
per `build/README.md` and record the new edition.

Scope is only `kriscendobot/garden-book`; make no upstream or fleet/config
changes.
