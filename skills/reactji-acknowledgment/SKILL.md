---
created: 2026-05-13
updated: 2026-05-20
author: liaison, gardener
---

# Skill: reactji-acknowledgment

Adopted from `references/endo-but-for-bots/skills/reactji-acknowledgment.md`.

Leave an `eyes` reactji on the source comment at the moment a comment is first noticed, as a cheap "received and processing" signal. The substantive response follows.

## Authorization caveat

Reactions count as cross-repo activity. Posting from a bot identity on an upstream PR or issue requires explicit per-action authorization in the dispatch prompt. See `roles/COMMON.md` § External-repo etiquette. This skill describes the *technique*; whether to use it on a given PR is governed by authorization.

## When to use

**At the moment the activity is noticed and a response shape begins to form.** The triage role posts the reactji, not the dispatched worker. Worker latency (10 to 30 minutes from dispatch start) is unacceptable for a "received" signal; the human sees the reactji within seconds when the triage role's per-cycle sweep first reads the comment.

Worker roles (`fixer`, `weaver`, `shepherd`, `conductor`, `cleaner`, `designer`, `scribe`, `judge`, the jury seats) inherit the reactji from the triage role and do not re-react on comments the dispatch brief surfaced. Exception: when the worker discovers a comment the triage did not pre-surface (older drafts, comments on files the brief did not mention), react at the moment of discovery.

## Vocabulary

- **`eyes`** (👀) is the default. "Saw this; the response is in flight or no response is warranted." Use for the vast majority of cases.
- **`+1`** (👍): "Saw this; agree or thanks." Reserve for comments recommending a path the agent endorses, or for thanks/celebration where reactji-only is sufficient.
- **`rocket`** (🚀): celebrating a landed PR or shipped feature.
- **`heart`**, **`hooray`**: rare warmer-thanks shapes.
- **`confused`**, **`-1`**, **`laugh`**: do not use. Confusion warrants a reply asking for clarification; negative reactions carry tone the bot should not project.

Default to `eyes`. Mis-picking another reactji costs more than always defaulting to `eyes`.

## How

```sh
# Top-level conversation comment on a PR or issue
gh api -X POST repos/<owner>/<repo>/issues/comments/<COMMENT_ID>/reactions \
  -f content=eyes

# Inline review comment on a specific line of a diff
gh api -X POST repos/<owner>/<repo>/pulls/comments/<COMMENT_ID>/reactions \
  -f content=eyes

# Issue body itself (rare; usually warrants a reply, not a reactji)
gh api -X POST repos/<owner>/<repo>/issues/<N>/reactions \
  -f content=eyes
```

GitHub returns 404 if you mix `/issues/comments/` with `/pulls/comments/`. The JSON `path` field distinguishes inline (has `path`) from conversation (no `path`).

Posting the same reactji twice from the same identity is a no-op (deduplication). Don't bother checking for an existing reactji; just post.

## When not to use

- Comments authored by the same gh-auth identity as the agent (no self-`+1`-ing).
- Closed PRs or closed issues: closed state is inert; do not signal engagement on a settled artifact.
- Automated comments (CI status posts, other bot acknowledgments).
- Review-only mirror PRs: address upstream.

## Reviews are not reactable; comments are

GitHub exposes reactions on issue comments and PR review comments, but **not on PR reviews themselves**. A review (state `APPROVED` / `CHANGES_REQUESTED` / `COMMENTED`) carries an optional body that has no reactions endpoint. When a maintainer posts a substantive review body, the agent's acknowledgment is a substantive top-level conversation comment, not a reactji.

If unsure: `gh pr view <N> --json reviews` lists reviews (no reactions endpoint); `--json comments` lists conversation comments (reactable via `/issues/comments/`); `gh api .../pulls/<N>/comments` returns inline review comments (reactable via `/pulls/comments/`).

## Pitfall: the reactji is not the response

A reactji says "I saw this." It does not say "I am addressing this" or "I am ignoring this": those are different decisions communicated via the substantive response. Posting only a reactji on a question is silent-strand failure. The reactji is the cheap first half; the substantive response is the load-bearing second half.

## Notes from the field

- _2026-05-13_: adopted from the reference. The reference embedded references to other gardens' role files (`~/garden/roles/{steward,director,liaison}.md`); those were dropped because the corresponding roles in this garden may dispatch reactjis differently. The discipline (triage role posts, worker inherits) holds across gardens.

- _2026-05-20_: **Cadence-overrun is the dominant failure mode, not skill ignorance.** A 2026-05-19T23:46Z to 23:56Z burst of four `@kriscendobot` directives on `endojs/endo-but-for-bots` PRs (#301, #303, #305, #307) reached the steward via the at-mention-surveillance Monitor; the steward jumped straight to dispatch on three in parallel and routed the fourth to liaison, but acked none with the `eyes` reactji until the maintainer flagged two as "may have missed." Reactji was backfilled. The triage-role-posts-first rule in *When to use* above is correct in principle; the gap is the sequencing at the dispatch site. The per-surface sequencing now lives at [`skills/at-mention-surveillance/SKILL.md`](../at-mention-surveillance/SKILL.md) § Ack on pickup, before dispatch (for the at-mention-derived dispatch surface; other surfaces that gain a similar burst-triggered dispatch pattern should mirror the rule). Pattern to watch: any surveillance Monitor whose emit-line directly triggers a dispatch is at risk of the same cadence-overrun unless the dispatch site explicitly orders reactji-before-`Agent`.
