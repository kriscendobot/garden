Comment posted. Work complete — writing my report.

---

## Completion report — `issue-kriskowal-garden-10`

**What the issue asked:** kriskowal (trusted maintainer) asked me to *post a job* to build a system where the bulletin `README.md` on `journal2` is auto-published to the repo's GitHub Pages, with a per-maintainer-inbox-message text input + button to acknowledge/reply, where the reply is a pure-client-side-JS commit to `journal2` adding a reply to the liaison's inbox, via a GitHub OAuth flow plus setup instructions.

**What I did:**
1. Re-fetched the issue verbatim (the `gh issue view` TTY render returned empty; the `--json` form worked).
2. Explored the relevant garden structures read-only: the bulletin (`journal2:README.md`), the maintainer inbox (`inbox/maintainer/{unread,read}/`), the message-bus format, and the existing `maintainer-reply.sh` routing semantics (read `reply_to: <doer>`, deliver to that doer's inbox, archive original).
3. Wrote and posted a build-job spec **`build-github-pages-bulletin`** to the board via `post-job.sh` (body passed as a file, wrapped in `timeout`, per the producer-hang guidance). It's already been claimed into `jobs/doin/`.
4. Copied the **ISSUE NOTE block verbatim** into the job body so the downstream builder comments back on the right issue, and instructed it not to email/close.
5. Commented the status + plan on the issue ([comment](https://github.com/kriskowal/garden/issues/10#issuecomment-4826627834)); left the issue **open** for the submitter to close.
6. Drained my inbox at the checkpoint — empty.

**Key spec decisions surfaced to the builder (as a required design note before coding):**
- **OAuth without a backend** — GitHub's web OAuth needs a `client_secret` (can't be client-side); builder must justify a no-secret path (App device flow) with a PAT fallback, plus minimal scopes.
- **Pages source vs. orphan `journal2`** — recommend serving the static page from `main2` (`docs/bulletin/`) and pulling `journal2` at runtime via the GitHub API.
- **Reply routing** — reconcile the maintainer's "liaison's inbox" phrasing with the existing `maintainer-reply.sh` doer-routing + archive convention so one commit stays bus-compatible.
- Deliverables go to `main2` directly (garden-infra, no PR per CLAUDE.md), in an isolated worktree.

**Follow-ups:** None owed by me. The build is in flight under `build-github-pages-bulletin`. Likely human-gated step downstream: the maintainer will need to register a GitHub App/OAuth app and enable Pages — the builder will document exact steps and comment them on the issue if it blocks completion.
