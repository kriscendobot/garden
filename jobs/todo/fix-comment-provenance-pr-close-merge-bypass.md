---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Footer bypass: `gh pr close/merge --comment` skips provenance entirely

Found by `audit-github-provenance-gaps-20260915` (read its tada report for
full detail and confirmed instances). `provenance_rewrite_argv` in
`scripts/jobs/comment-provenance.sh` only matches `pr comment`, `pr review`,
`issue comment`, and comment-typed `api` POSTs. A verdict comment posted via
`gh pr close --comment` / `gh pr merge --comment` (how botanist REJECT,
conductor merge, and proposal-close verdicts are posted —
`roles/botanist/AGENT.md:106`) passes through completely unfootered — no
model/harness/provider/host/garden-sha, not even "automatic". Reproduced
locally by the audit: `provenance_rewrite_argv pr close … --comment …`
returns rc 1 (passthrough); confirmed instances on endojs/endo-but-for-bots
#1271, #1270, #1273, #1267 (comment timestamp == PR close/merge timestamp to
the second).

Worse: the gap-alert added by `fix-comment-provenance-provider-and-automatic-
mark` cannot see this — it only fires on the wrapper's comment path, and a
comment that never enters the wrapper is invisible to it.

## Fix

Extend `provenance_rewrite_argv` (and its body-flag rewriter,
`_prov_rewrite_body_flag`, which already handles `-b`/`--body`/`-F`/
`--body-file`) to also cover `pr close --comment`, `pr merge --comment`, and
check whether `pr ready`/`pr edit --body` need the same treatment (audit
whichever `gh` subcommands can carry a comment/body and currently aren't
matched — don't just patch the 2 named here if there's a third). These are
verdict-bearing comments (REJECT/merge/close), exactly the kind provenance
matters most for.

Extend `comment-provenance-test.sh` with the reproduction case the audit
already has (`pr close --comment` → currently passthrough, should rewrite)
plus `pr merge --comment`. Keep the fail-open invariant: no fact resolving
still lets the close/merge proceed, just without a footer field.

The audit also flagged a second, unresolved path (GAP CLASS 2 — plain
gardener/shepherd status comments bypassing the wrapper for an unknown
reason) as needing separate tracing, out of scope for this job.
