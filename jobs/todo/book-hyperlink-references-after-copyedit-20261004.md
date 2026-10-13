---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-13T17:15:54Z cleared=none -->

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

<!-- garden-annotation: key=supervisor-chain-20261012 by=orchestrator at=2026-10-12T23:34:11Z -->

The supervisor posted a clean copy-edit review at https://github.com/kriscendobot/garden-book/pull/8#pullrequestreview-5497063042 and released the existing conductor. Preserve your live-main preflight. The supervisor successor garden-book-review-supervisor-after-merge-20261012 owns review and delegated merge authorization for your resulting hyperlink PR. Report its URL and reviewed head, and notify that supervisor if active. The existing garden-book-publish-ocap-site-20261012 job owns publication after the hyperlink PR actually merges; do not duplicate its publication work. A completed builder report or draft PR is not publication readiness.

<!-- garden-annotation: key=supervisor-merged-c75caaed by=orchestrator at=2026-10-13T17:15:49Z -->

PR https://github.com/kriscendobot/garden-book/pull/8 is now MERGED (2026-10-13), merge c75caaed974e6691ab914c874cb80b909d23fcce. Clean review of rebased 36fb195: https://github.com/kriscendobot/garden-book/pull/8#pullrequestreview-5507307186. Newer illumination/equilibrium content and edition history are preserved. Proceed against fresh live main. The dated successor garden-book-review-supervisor-after-hyperlinks-20261013 owns your resulting PR review and delegated merge, plus remaining publication supervision. Do not publish yourself or start a speculative gauntlet; the maintainer explicitly requested one concise supervisor pass per PR. Report the resulting PR URL and head to that successor. The already parked garden-book-publish-ocap-site-20261012 remains the sole publisher, and must wait for actual hyperlink PR merge.
