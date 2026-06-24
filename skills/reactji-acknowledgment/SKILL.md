---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: reactji-acknowledgment

Leave an `eyes` reactji on the source comment at the moment a comment is first noticed, as a cheap "received and processing" signal. The substantive response follows.

Consumed by the **triager/gardener acknowledgment step**: the triager (the per-repo producer that maps PR-comment directives to jobs) posts the reactji as it reads the comment and posts the job; the gardener that claims the job inherits the reactji and does not re-react.

## Authorization caveat

Reactions count as cross-repo activity. Posting from a bot identity on an upstream PR or issue requires explicit per-action authorization. This skill describes the *technique*; whether to use it on a given PR is governed by authorization (only comment-gated, safe-to-monitor repos in the active set; widening follows the monitoring-safety constraint).

## When to use

**At the moment the activity is noticed and a response shape begins to form.** The triager posts the reactji, not the gardener that later claims the job. Worker latency (the time from job-post to claim to first action) is unacceptable for a "received" signal; the human sees the reactji within seconds when the triager's per-cycle sweep first reads the comment.

A gardener running a gauntlet step inherits the reactji from the triager and does not re-react on comments the job surfaced. Exception: when a gardener discovers a comment the triager did not pre-surface (older drafts, comments on files the job did not mention), react at the moment of discovery.

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

- _2026-05-13_: adopted from the reference. The discipline (triage role posts, worker inherits) holds across gardens.
- _2026-05-20_: **Cadence-overrun is the dominant failure mode, not skill ignorance.** A burst of four `@kriscendobot` directives on `endojs/endo-but-for-bots` PRs reached a triage surface; the work jumped straight to posting jobs on three in parallel and routed the fourth, but acked none with the `eyes` reactji until the maintainer flagged two as "may have missed." Reactji was backfilled. The triage-posts-first rule in *When to use* above is correct in principle; the gap is the sequencing at the job-post site. Pattern to watch: any surveillance surface whose emit-line directly triggers a job post is at risk of the same cadence-overrun unless the post site explicitly orders reactji-before-post.
- _2026-06-24_: migrated from v1. The "triage role posts, worker inherits" rule maps onto the v2 producer/consumer split: the **triager** (producer) posts the reactji as it posts the job; the **gardener** (consumer) inherits it. The worker-role enumeration (fixer, weaver, shepherd, conductor, …) collapsed to "a gardener running a gauntlet step." The steward and the at-mention Monitor framing were removed; the cadence-overrun lesson is preserved against the job-post site.
