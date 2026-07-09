Comment posted, closing the loop. No code changes were warranted — this was a deferral directive on a closed, superseded PR. Nothing to commit in either the garden worktree or a project repo.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #111 (comment 4921379336 by @kriskowal).

**What I found:**
- Preflight returned exit 0 (PROCEED — no peer had resolved it).
- The actual comment body is a single line: *"We will reconstruct these changes when implementation settles on the llm branch."* (The longer text in the job excerpt was preflight boilerplate appended by the posting machinery, not part of the comment.)
- PR #111 is **CLOSED** and was **superseded by #137** (kriscendobot, 2026-05-07). The maintainer's note is a forward-looking **deferral**, not a request to act now, and its reconstruction is gated on an external, not-yet-met condition (the `llm` branch settling).

**Routing decision:** No actionable code work. Treated the attention directive as a deferral / no-op — the correct routing given the PR is closed/superseded and reconstruction is explicitly future-tense and condition-gated.

**What I did:**
- Posted a concise disposition comment on PR #111 (https://github.com/endojs/endo-but-for-bots/pull/111#issuecomment-4928347525) carrying the `garden-reply:4921379336` marker, closing the loop the garden's earlier auto-reply ("will follow up here when it lands") had opened. It records: deferral acknowledged, superseded by #137, reconstruction to happen on the `llm` branch once it settles.
- No commits/pushes (no garden-library or project-repo changes were warranted).
- Drained inbox (empty).

**Follow-ups:** None required now. When the `llm`-branch implementation settles, the reconstruction of these `@endo/ocapn` codec/NonceLocator changes can be picked up fresh (reference: the original design lives in PR #111's body and #137/#59).
