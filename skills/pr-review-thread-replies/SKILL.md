---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: pr-review-thread-replies

Reply on each inline review thread after addressing it, citing the commit SHA. Closes the loop without forcing the reviewer to re-walk the diff.

Consumed by the fixer step of the gardening state machine ([`scripts/jobs/gardening/garden-pr.sh`](../../scripts/jobs/gardening/garden-pr.sh); design [`../../designs/gardening-state-machine.md`](../../designs/gardening-state-machine.md)), as the close-out of [`../review-feedback-followup-commits/SKILL.md`](../review-feedback-followup-commits/SKILL.md).

## When to use

After pushing a fix-up commit that addresses inline review comments. The reply discipline applies whenever the response is substantive (a fix landed, a deferral was authorized, an invariant was verified).

## How

Find each thread's parent comment id:

```sh
gh api repos/<owner>/<repo>/pulls/<N>/comments --paginate \
  --jq '.[] | {id, path, line, user: .user.login}'
```

Reply on the thread (note: `/replies` endpoint, not the parent endpoint):

```sh
gh api repos/<owner>/<repo>/pulls/<N>/comments/<comment-id>/replies \
  --method POST \
  -f body="Addressed in <short-sha> (<commit-headline>). <one-line explanation if needed>."
```

For a deferral instead of an addressed item:

```sh
-f body="Following up in a separate PR. <one-line reason>."
```

**Never pass a file path as the body value.** `gh api -f body="@/tmp/reply.md"`
posts the literal string `@/tmp/reply.md` — no `@`-file dereference happens on a
`-f` field, so a maintainer sees a garbled one-token comment (the endo-but-for-bots
#592 "Weird response."). When the reply is long or comes from a file, read it into
the value with `-f body="$(cat /tmp/reply.md)"`, or use `--field body=@/tmp/reply.md`
(the `--field`/`-F` form is the one that reads from a file). Verify the posted body
by re-fetching the comment when in doubt.

Then post a top-level summary via `gh pr comment <N>` listing each item, the commit that addressed it, and any deferrals.

## Output

Each inline thread carries a SHA-citing reply (or a deferral note); one top-level summary maps every item to its outcome. The job's completion report records the same mapping.

## Pitfalls

- **Wrong endpoint.** Replying via the *parent* endpoint creates a new top-level comment, not a threaded reply. The `/replies` suffix is required.
- **Quoting.** Bash heredocs and `-f body=` interact poorly with backticks. Escape with `\`...\`` or use `--field` with a here-string.
- **Type-annotation review comments.** Fetch the `diff_hunk` (included in the comments payload); reviewers asking about a type are almost always pointing at what was lost in the refactor. Fix structurally rather than reverting.
- **Inline comments visible in the browser but not in REST.** When `GET /pulls/<N>/comments` returns `[]` and the `/replies` endpoint 404s for a comment whose body and position are visible on the PR page, the comment is real but not yet propagated. The maintainer likely left them as pending/draft review state. Fall back to a single top-level `POST /issues/<N>/comments` that maps each comment id to its outcome (applied + SHA, stalled + reason, replied-only). Cite the maintenance state in the top-level body.

## Authorization note

Posting a reply on someone else's repository PR requires explicit per-action authorization. The job a gardener claims carries that authorization in its body; absent it, the gardener stops and surfaces the gap to the maintainer over the message bus ([`../message-bus/SKILL.md`](../message-bus/SKILL.md)) rather than posting under the bot identity.

## Notes from the field

- _2026-05-13_: adopted from the reference. PR 111's eight-comment session example was the source of the "REST index lag" pitfall above; the abstract pattern survives, the specific PR lore went to the journal.
