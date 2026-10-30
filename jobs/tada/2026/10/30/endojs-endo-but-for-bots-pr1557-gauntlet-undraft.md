# Gauntlet undraft: endojs/endo-but-for-bots#1557

PR #1557 ("feat(exo-git): adopt git capability URLs as GitRemotes without leaking the token") is now ready for review and still at head `931f5ea3982a199776bbaccb971b32865d33b1d7`.

**What I did**
- **Check before un-drafting:** the PR was OPEN and draft, with head `931f5ea…`, the exact commit the passing panel reviewed.
- **Un-draft:** I ran `gh pr ready`.
- **Check after:** `isDraft=false`, and the head is still `931f5ea…`.

**Advisory appellate pass (does not block the un-draft)**
A `claude -p` (sonnet) read of the diff only, without the full repo, found nothing that should block. Possible gaps the panel may have missed:
- **Query and fragment still shown:** `redactGitRemoteUrl` removes only the user:password part of the URL. The error for a URL with embedded credentials still prints the path, query and fragment. That is a leak only if a token can sit in a query or fragment, but the changeset says more broadly that credentials are "no longer echoed".
- **Other places that may print the raw URL:** the reviewer couldn't check whether `git-cloner.js`, the daemon's `provideGitClone`/`provideGitRemote` checks, or native git failure messages put the raw URL into errors or logs.
- **Returned `url` keeps query and fragment:** `splitGitCapabilityUrl` passes them on into the formula and the git command-line arguments.
- **Edge case:** a token containing a literal `%` makes `decodeURIComponent` throw. That fails safely with a generic error, and `%41` is silently decoded to `A`. This only matters if tokens can contain characters that aren't URL-safe.

Possible follow-up for the maintainer: decide whether URL query and fragment parts need redacting too. I did not post a job for it.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1557-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (231394 cached reads)
- Output: 1647 tokens
- Cost: $0.43142679999999994
- Wall-clock: 48s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
