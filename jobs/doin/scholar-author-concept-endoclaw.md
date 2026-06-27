# scholar-author-concept-endoclaw

Author the missing `library/concepts/endoclaw.md` concept page and resolve the
remaining `endoclaw.md` dangling references the hourly cycle
`scholar-library-cycle-20260627-105244` could not finish within budget.

## Background

The `endoclaw` capability cluster has a parent design and ~12 member designs,
all already ingested as library sources
(`library/sources/endo-but-for-bots--llm-designs-endoclaw*.md`). Member design
abstracts and section bodies carry `Parent: [endoclaw](endoclaw.md)`-style
relative links. There is no `concepts/endoclaw.md` page for them to resolve to,
so the standing `--all` link scan flags ~10 residual section-body links to
`endoclaw.md` as dangling. The hourly cycle already repaired the 6 source-page
`Parent:` links (plain-texted) plus 2 sibling cross-refs; what remains is the
concept page itself plus the verbatim-body links.

## Task

1. Read the parent design source page
   `library/sources/endo-but-for-bots--llm-designs-endoclaw.md` and
   `...endoclaw-six-design-cluster.md`. Author `library/concepts/endoclaw.md`
   with a specific abstract-at-the-top per `skills/context-library/SKILL.md`:
   what "endoclaw" names (the capability cluster), the member designs, and the
   recurring "capability vs. UI feature" classification the members use.
2. Add the `keywords.md` row and the `concepts/README.md` index row.
3. Light-clean the residual verbatim section-body `](endoclaw.md)` links in the
   endoclaw-cluster `sections/*.md` files to point at `../concepts/endoclaw.md`
   (this is the permitted light-cleaning of a relative link that does not
   resolve in the library's flat namespace, not a rewrite of source prose).
4. Run `scripts/jobs/library-link-check.sh --library <lib> --all` and confirm the
   `endoclaw.md` dangling cluster is cleared. Journal a `result`, complete.

Land all writes on `journal2` from a fresh detached worktree off
`origin/journal2` (do NOT rebase the live `journal/` worktree). Budget: one
scholar cycle.

---
claim:
  host: endolinbot
  gardener: 55
  claimed_at: 2026-06-27T11:04:22Z
