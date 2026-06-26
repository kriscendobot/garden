# Watcher filter: ignore feedback on mention-only authors' PRs unless @kriscendobot is mentioned

Wear the **mentor** role. A contributor (**0xpatrickdev**, for himself and **0xpatrickbot**) asked
that kriscendobot **ignore feedback on PRs/issues they author unless the feedback directly mentions
kriscendobot**. This is the first of likely several such requests, so it is **list-driven**.
Infrastructure on `main2` (bot identity; isolated worktree off `origin/main2`; redeploy the
watcher).

## The list (already created in the journal)

`journal2:mention-only-pr-authors/allowlist` — header-commented, one GitHub login per line,
case-insensitive, '#'/blank ignored (mirrors `trusted-senders/allowlist`). Seeded with
`0xpatrickdev` and `0xpatrickbot`. Adding a login must require **no code change** — just append +
push, like the trusted-senders list.

## The filter (wire into the comment-watcher / repo-watcher dispatch path)

When the comment-watcher classifies a comment or review for dispatch to triage, **look up the
PR/issue's AUTHOR**; if that author is on `mention-only-pr-authors/allowlist`, **DROP the dispatch
(do not triage, do not react) UNLESS the comment/review body directly @-mentions kriscendobot**
(`@kriscendobot`). Log the drop (so it is visible, not silent). For PRs/issues authored by anyone
NOT on the list, behavior is unchanged.

- Read the list the same way the watcher reads `trusted-senders/allowlist` (shared loader if one
  exists). The author lookup: the comment-source already has the PR/issue number — fetch/carry the
  author login (`gh` built-in `--jq`, not external jq; `require_tools`-guarded).
- This composes with the existing sender-trust gate and the @-mention/verb classification — the
  mention-only author filter is an ADDITIONAL gate applied when the PR author is listed.
- Note the relationship to the earlier policy ("heed 0xpatrickdev/0xpatrickbot directives on PRs
  they create"): that still holds — the @-mention is now the required trigger to act on their PRs.

## Tests & verification

- A comment WITHOUT `@kriscendobot` on a PR authored by a listed login (0xpatrickbot) → dropped
  (logged, no dispatch). The SAME comment WITH `@kriscendobot` → dispatched. A comment on a PR
  authored by a non-listed user → unaffected. Case-insensitive author match; list reload needs no
  code change. `shellcheck`/`bash -n` clean.

## Definition of done

The comment-watcher/repo-watcher filters dispatches so feedback on mention-only authors' PRs is
ignored unless kriscendobot is directly @-mentioned, driven by `mention-only-pr-authors/allowlist`
(append-to-add, no code change), logged not silent, tests added — committed/pushed to
`origin/main2`, redeployed. Report the SHA and the filter behavior.

Posted by the liaison on behalf of the maintainer (0xpatrickdev request, 2026-06-26).

---
claim:
  host: endolinbot
  gardener: 39
  claimed_at: 2026-06-26T05:51:47Z
