# Hyperlink all PR/issue references in the journal-root pr-review-sequence report

**Target:** the report at the **journal2 root**, `pr-review-sequence.md`
(<https://github.com/kriskowal/garden/blob/journal2/pr-review-sequence.md>). It is
the maintainer's worklist for clearing the M3 merge bottleneck, and its ~26+
references render as **plain text** today. Maintainer directive (2026-07-11):
**pervasively promote every PR/issue reference in it to a working hyperlink** so the
maintainer can click straight from the review sequence to each PR.

**Land through the producer-clone discipline** (sync a producer clone, edit the
file at the current tip, CAS-push to `origin/journal2`) — never the live `journal/`
worktree, which can be arbitrarily stale. The root `pr-review-sequence.md` is not
under the `library`/`projects` allowlist, so `land-journal-edit.sh` will not take
it; use the same producer-clone + `commit_and_push` pattern the job-board producers
use (see `set-gardeners.sh` / `promote-plan.sh` for the shape).

## What to do — pervasively, every reference

Rewrite **every** GitHub reference in the file to a Markdown hyperlink:

- **`owner/repo#N`** (the dominant form, e.g. `endojs/endo-but-for-bots#678`) →
  `[endojs/endo-but-for-bots#678](https://github.com/endojs/endo-but-for-bots/issues/678)`.
  Use the **`/issues/N`** URL form — GitHub redirects it to `/pull/N` for a PR, so it
  is correct for both PRs and issues without having to classify each.
- **Bare `#N`** (e.g. `#617`) — this report's references are all
  **`endojs/endo-but-for-bots`**, so resolve a bare `#N` to that repo and link it the
  same way. (If any bare `#N` is genuinely ambiguous in context, fully-qualify it in
  the text rather than mislink.)
- **Any full `https://github.com/...` URL** → ensure it renders as a link (wrap a
  bare URL as `[text](url)` or leave it if already autolinking); do not double-wrap.
- **Issue-spine references** like `issue-kriskowal-garden-33` or a `kriskowal/garden`
  issue mention → link to the corresponding issue if one is named.

## Markdown-aware (do NOT rewrite inside):
- fenced code blocks (```` ``` ````, `~~~`); and
- inline code spans (`` `...` ``).
- Do not double-link a reference that is already a Markdown link.
Keep the prose and table structure intact; only the references become links.

## Verify
- The rewritten `pr-review-sequence.md` renders on GitHub with **every** reference
  clickable to the correct PR/issue; spot-check 2–3 links resolve to the right PR.
- No reference inside a code fence/span was rewritten; no double-links; the report's
  content/ordering is otherwise unchanged (diff is link-wrapping only).
- CAS-pushed to `origin/journal2` and reachable.

## Skills
- [relative-paths](../../skills/relative-paths/SKILL.md),
  [no-comment-banners](../../skills/no-comment-banners/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done
Every PR/issue reference in `journal2:pr-review-sequence.md` is a working hyperlink
(code fences/spans untouched, no double-links), landed via the producer clone and
reachable on `origin/journal2`. The `tada` report gives the commit SHA and the count
of references linked.
