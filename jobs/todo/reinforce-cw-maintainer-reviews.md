# Reinforce the comment-watcher: a trusted maintainer's review with inline comments is ALWAYS actionable

Wear the **mentor** role. The prior `fix-comment-watcher-timer-and-classification` landed but
a gap persists, observed three times (endo-but-for-bots #503, #96 misclass, and **kriskowal/garden #4**
reviews `4573331488` + `4573434772` — neither acted on). Infrastructure on `main2` (bot identity;
isolated worktree off `origin/main2`).

## The gap

A **maintainer/trusted-sender REVIEW carrying inline comments** is dropped when:
1. The review's **top-level body is EMPTY** (substance is entirely in inline comments) — the
   source handler's reviews section does `select((.body // "") != "")`, which **drops empty-body
   reviews outright**, so the review is invisible at the review-body level.
2. The inline comments are **declarative design decisions** ("Per-design files are the source of
   truth", "Keep indefinitely"), not imperative ("please X") — so the plain-language-directive
   heuristic added by the prior fix does NOT match them, and they fall through.

## Fix

- **A review (any state, incl. COMMENTED with empty body) from a trusted maintainer/contributor
  that carries one or more inline comments is ACTIONABLE.** The presence of trusted-maintainer
  inline review comments IS the directive — do not require a verb, an @-mention, a non-empty
  body, or imperative phrasing. Emit/handle the review with its inline comments and post an
  **"address the review on #N"** job that enumerates ALL inline comments tied to that review,
  routed to a designer/fixer.
- Stop dropping empty-body reviews when they have inline comments: in `comment-source-gh.sh`,
  when a review's body is empty but it has inline comments, still surface it (or rely on the
  pulls/comments inline entries) so the watcher sees the feedback.
- Keep the **sender-trust gate** — only trusted senders' reviews trigger this; an untrusted
  contributor's review still does not feed work.

## Tests & verification

- A COMMENTED empty-body review with inline comments from a trusted sender (kriskowal) → exactly
  one "address review #N" job covering all its inline comments; the same from an untrusted sender
  → dropped; a review with no inline comments and no body → nothing. `shellcheck`/`bash -n` clean.

## Definition of done

The comment-watcher treats a trusted-sender review-with-inline-comments as actionable regardless
of body/verb/phrasing, no longer drops empty-body reviews that carry inline comments, keeps the
sender gate, tests added — committed/pushed to `origin/main2`, redeployed. Report the SHA and the
classification change. If blocked, report diagnosis + ready-to-apply change.

Posted by the liaison on behalf of the maintainer.
