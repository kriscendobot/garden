# Build: GitHub Pages bulletin with client-side maintainer reply

Posted by gardener handling issue-kriskowal-garden-10. The maintainer (kriskowal)
asked, verbatim, on kriskowal/garden#10:

> Please post a job to build a system in which the Bulletin README.md on journal2
> branch gets automatically posted to this repository's Github Pages. For each
> entry in the inbox for the maintainer, there should be a text input and button
> for acknowledging and replying to the message, addressed to the liaison. This
> should manifest as a commit on the journal2 branch that adds a reply to the
> liaison's inbox. It should be pure client side JavaScript. It will need an OAuth
> flow with Github and instructions here for how to set up the repository plugin.

Treat that quoted block as the maintainer's intent. This job is the authorized
go-ahead to build it (the issue body is the directive).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-10
issue_url: https://github.com/kriskowal/garden/issues/10
submitter: kriskowal
----- END ISSUE NOTE -----

When you finish (or if you must report a blocker), COMMENT on the issue URL above
with `gh issue comment https://github.com/kriskowal/garden/issues/10 --body "…"`.
Do NOT email and do NOT close the issue. If you decompose into follow-on jobs,
copy the ISSUE NOTE block verbatim into each.

## What to build

A static, pure-client-side web page (HTML/CSS/JS, no server runtime of our own)
that:

1. **Renders the bulletin.** Fetches `README.md` from the `journal2` branch at
   page load and renders it. The bulletin already aggregates Latest / Parked PRs /
   Messages-to-the-maintainer sections (see `journal2:README.md`, produced by the
   journalist bulletin loop). "Automatically posted" = the page always reflects
   current `journal2:README.md` with no manual republish step.
2. **Per maintainer-inbox message: a reply control.** For each unread entry in the
   maintainer inbox (`inbox/maintainer/unread/*.md` on `journal2`), show a text
   input + a button to acknowledge/reply. Submitting a reply makes a **commit on
   `journal2`** delivering the reply, then refreshes.
3. **Pure client-side GitHub auth.** An OAuth flow against GitHub so the page can
   read `journal2` and push the reply commit as the authenticated maintainer.

## Hard constraints to resolve (produce a short design note FIRST)

These are real and the maintainer flagged the setup explicitly ("instructions for
how to set up the repository plugin"). Resolve them in a 1-page design note
committed alongside the code, then implement:

- **OAuth without a backend.** GitHub's standard OAuth web flow requires a
  `client_secret` to exchange the code for a token — impossible to keep secret in
  pure client-side JS. Pick and justify one path: GitHub **App device flow**, a
  GitHub App user-token flow, a minimal serverless token-exchange shim
  (only if unavoidable — the maintainer asked for "pure client side", so prefer a
  no-secret path), or a pasted fine-grained PAT as a documented fallback. Document
  exactly what the maintainer must register (the "repository plugin" / OAuth-or-App
  setup) and the minimal scopes (`contents:write` on this repo's `journal2`).
- **Pages source vs. the orphan `journal2` branch.** `journal2` is a large orphan
  branch; the bulletin lives there but the static site should not have to be served
  from it. Recommended: serve the static page from `main2` (e.g. `docs/bulletin/`
  for Pages, or a `gh-pages` build) and have the JS pull `journal2` content at
  runtime via the GitHub Contents API / `raw.githubusercontent.com`. Justify the
  chosen layout and give the exact GitHub Pages configuration steps.
- **Reply routing — stay compatible with the existing convention.** The maintainer
  said the reply is "addressed to the liaison … adds a reply to the liaison's
  inbox." The existing CLI path is `scripts/jobs/maintainer-reply.sh`: it reads the
  replied-to message's `reply_to: <doer>` frontmatter, delivers the reply into that
  doer's inbox (`inbox/<doer>/unread/<ts-id>.md`, frontmatter `from: maintainer`,
  `reply_to`, `sent_at`), and archives the original (moves
  `inbox/maintainer/unread/<id>` → `read/`). The client-side commit MUST produce a
  bus-compatible result — reconcile the maintainer's "liaison's inbox" phrasing
  with the existing doer-routing+archive semantics in the design note (e.g. route
  to the doer like the CLI does, and/or also notify the liaison), and match the
  message-bus file format exactly (`skills/message-bus/SKILL.md`). A single commit
  that adds the reply file and archives the original is ideal.

## Deliverables

- Static site under the garden repo (committed to `main2` in an isolated worktree
  off `origin/main2` — this is garden-infra; NO PR, push `HEAD:main2` directly per
  CLAUDE.md "No PR workflows for the garden's own repo").
- The 1-page design note (OAuth path, Pages layout, reply routing).
- A README/setup doc: how to register the GitHub App/OAuth app ("repository
  plugin"), enable GitHub Pages, and the required scopes — concrete click-by-click.
- Verify the page loads, authenticates, renders the live bulletin, and a test reply
  produces the correct `journal2` commit (or, if you cannot exercise OAuth without
  maintainer-registered credentials, document precisely what manual step the
  maintainer must take to validate, and comment that on the issue).

## Notes

- Read first: `roles/COMMON.md`, your gardener norms, `skills/message-bus/SKILL.md`,
  `skills/job-board/SKILL.md`, and `journal2:README.md` + a sample
  `inbox/maintainer/unread/*.md` for the exact message format.
- Researcher precedence applies if you go through a designer/builder dispatch.
- If the OAuth-app registration genuinely blocks completion (needs a human to
  create the app), build everything buildable, document the exact registration
  steps, and comment the setup instructions on the issue rather than stalling.
