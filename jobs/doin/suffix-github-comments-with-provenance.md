role: builder
# Suffix every GitHub PR/issue comment with a small-text provenance line:
# model, harness, and the deployed garden main2 hash (hyperlinked)

Maintainer directive (kriskowal, 2026-07-28): suffix every PR or issue comment on
GitHub with the model, harness, and garden `main2` hash (hyperlinked) used to produce
the response, in small text.

Garden repo, `main2`, **DIRECT push, NO PR** per CLAUDE.md § Conventions.

## The content

One line, rendered small, appended to the comment body. Suggested shape (adjust the
wording, keep the three facts):

    <sub>model <code>claude-opus-5</code> - harness <code>claude</code> - garden
    <a href="https://github.com/&lt;owner&gt;/garden/commit/&lt;sha&gt;"><code>bb971c9a</code></a></sub>

- **model** - the model actually resolved for the job (`role_default_model` /
  `resolve_model_tier` in `scripts/jobs/common.sh`), not the role's nominal default.
- **harness** - the worker kind / provider that ran it (claude, codex, ollama; the
  gardener / cleric / hermit / mystic / monk distinction).
- **garden hash** - the **DEPLOYED** sha from `.garden-state/deploy/deployed-sha`,
  which is the code that actually produced the behavior. Do NOT use `origin/main2`
  tip; the root is a deployed version and routinely lags tip. Hyperlink it to the
  commit, fully qualified per `skills/fully-qualified-github-urls/SKILL.md`, and show
  a short sha as the link text.

**Resolve the repo URL, do not hardcode it.** The garden repo is mid-transfer: the
git remote still reads `kriskowal/garden` while GitHub reports it moved to
`kriscendobot/garden` (job `garden-repo-transfer-followthrough` is in flight).
Derive the URL so it stays correct after the transfer settles.

## Where to implement it - read this before choosing

There is a single chokepoint. `scripts/jobs/bin/gh` is the fleet's gh wrapper; it
sits at the FRONT of the fleet's PATH (prepended in `common.sh`, which every fleet
entrypoint sources), and its own header notes the change "propagates to every child
-- including the `claude -p` gardener subagents and their Bash tool calls." Every
`gh` call any agent makes therefore passes through it.

Enforcing the suffix there is far more reliable than a skill telling agents to
remember, and it matches the garden's standing preference for moving a responsibility
off an agent into a script (`roles/mentor/AGENT.md`). **Evaluate the wrapper approach
first.** If you conclude it cannot be done safely, say exactly why and fall back to a
documented norm plus whatever partial enforcement is achievable; do not silently
choose the easier path.

The hard part is invocation surface. Cover at least:

- `gh pr comment` / `gh issue comment`, with `--body`, `--body-file`, and body on stdin
- `gh pr review --body` / `--body-file` (the review summary)
- inline review comments and threaded replies posted via `gh api`
  (`repos/.../pulls/N/comments`, `.../comments/ID/replies`), including `-f body=`,
  `--field`, `--raw-field`, `--input <file>`, and `--input -` JSON on stdin

## Hard constraints

- **Never corrupt a body.** A body passed as JSON must stay valid JSON; a
  `--body-file` must not be mutated on disk. Build the modified body in memory or a
  temp file.
- **Idempotent.** If the body already ends with the provenance line, do not append a
  second one. An agent that adds it by hand must not produce a doubled footer.
- **Only comment-creating calls.** Reactions (`reactji`, no body), label edits,
  merges, `gh api` reads, and every non-comment call pass through untouched. A
  reactji path that suddenly grows a body would be a regression.
- **Never touch git commit messages** - this is a GitHub-comment norm only.
- **Fail open, not closed.** If the model, harness, or deployed sha cannot be
  resolved, post the comment WITHOUT the suffix (or with the fields that did
  resolve) and log. A comment that fails to post because provenance was
  unavailable is worse than a comment missing its footer.
- Scripts that post comments directly (`scripts/jobs/issue-inbox-watcher.sh`,
  `scripts/jobs/comment-watcher.sh` reply paths) must carry the suffix too. If they
  go through the wrapper they get it for free - verify that they do.

## Scope decision to make and report

The directive says "PR or issue comment". Decide whether it also covers PR **review
summary bodies** and **inline review comments** (they are comments, and the same
provenance question applies) or only top-level comments. State your choice and the
reasoning in the report.

## Tests + verification

Tests under `scripts/jobs/test/` covering: each invocation form above gains exactly
one suffix; JSON bodies stay valid; `--body-file` is not mutated on disk; a body that
already carries the suffix is not doubled; reactji and other non-comment calls are
untouched; unresolvable provenance degrades gracefully rather than failing the post.

Run the CI-equivalent checks locally before pushing.

## Definition of done

Every comment the fleet posts to GitHub carries the small-text provenance line;
non-comment gh calls are unaffected; the deployed sha (not tip) is what is linked;
the repo URL survives the pending transfer. Direct push to `main2`. Report where you
enforced it and why, and the review-comment scope decision.

<!-- garden-reaped: 3 -->

---
claim:
  host: ps23-garden-f65473ae
  gardener: 20
  worker_kind: gardener
  claimed_at: 2026-07-28T16:43:09Z
