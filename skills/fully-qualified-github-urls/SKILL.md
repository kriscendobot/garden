---
created: 2026-07-20
updated: 2026-07-20
author: gardener
---

# Skill: fully-qualified URLs when communicating through GitHub

## The rule

When a role writes text that will render on GitHub — an issue comment, a pull-request comment or description, a review, a commit message that GitHub displays — every **reference to a repository, commit, branch, release, file, issue, or pull request** is a **fully-qualified `https://` URL**, not a shorthand.

Shorthand that must be expanded:

- `owner/repo` -> `https://github.com/owner/repo` (optionally as a link keeping the identifier text: `` [`owner/repo`](https://github.com/owner/repo) ``).
- A bare commit SHA (`7a6ca39`, `a3ebcca974c5...`) -> `https://github.com/owner/repo/commit/<sha>`.
- A cross-repo issue or pull request (`endojs/endo#123`) -> `https://github.com/endojs/endo/issues/123` (or `/pull/123`).
- A bare hostname or site (`main0.ymax.app`) -> `https://main0.ymax.app`.
- A file or path reference meant to be navigable -> the `https://github.com/owner/repo/blob/<ref>/<path>` URL.

The reason GitHub's own autolinking is not enough: `owner/repo`, `#123`, and bare SHAs only autolink **within the same repository's** rendering context, and often not at all in a foreign repo, a notification email, or a copied excerpt. A fully-qualified URL resolves for every reader, in every surface, regardless of which repository the text is displayed in.

## Scope

This is a **GitHub-communication** rule, distinct from `relative-paths` (which governs links *inside one document tree*, where relative is correct). The two do not conflict:

- Inside a garden document tree (a role file linking a skill file): **relative** path (`relative-paths`).
- In text published to GitHub for a human reader (an issue/PR comment): **fully-qualified** `https://` URL (this skill).

It also does not change `## External-repo etiquette`: fully-qualifying a reference is a formatting rule for references you are *already authorized* to make. It never authorizes a new cross-reference, `@`-mention, or upstream comment. A reference that etiquette forbids stays forbidden whether or not it is fully qualified.

## Procedure

Before posting any GitHub-rendered text, scan it for:

1. `owner/repo` tokens (including in code spans) that name a repository -> expand to its URL.
2. Bare commit SHAs -> link to the commit.
3. Bare hostnames / site names -> `https://` form.
4. Cross-repo `#N` or `repo#N` references -> the full issue/pull URL.

Keep the human-readable identifier as the link text where it aids reading (`` [`owner/repo`](https://github.com/owner/repo) ``); a plain `https://` URL is also fine. Do not double-wrap a reference that is already a link.

## Notes

- Maintainer directive, 2026-07-20 (kriskowal, on garden issue [#57](https://github.com/kriskowal/garden/issues/57#issuecomment-5026079913)): "Please revise all references above to fully qualified URLs. Please take this advice generally when communicating through Github."
- This applies fleet-wide to every role that authors GitHub-rendered text (`fixer`, `builder`, `weaver`, `shepherd`, `conductor`, `designer`, `triager`, `gardener`, and the like). It is indexed alongside the other standing-style skills in `roles/COMMON.md` § House style.
