## Completion report: kriscendobot/minion.town PR #176, gauntlet undraft stage

PR #176 ("deploy(git-remote): validate the live capability-URL round trip") is now ready for review, on the same head the panel passed.

**Advisory appellate pass.** It does not block the un-draft. A `claude -p` sonnet review of the 4-file diff found nothing blocking. It noted these minor points for the record:
- **Lost token on a failed mint:** If an SSM mint times out or fails after the token was created, the operator gets no token hash. That leaves a working read/write URL that can't be revoked.
- **`destroy` is not atomic:** It deletes the content first, then `.git`, then the sidecar, and never revokes tokens beforehand. A push that arrives partway through can recreate or half-write state. Deleting the sidecar first, or revoking all tokens first, would close that window.
- **Token exposure in the docs example:** In `DEPLOYMENT.md`, `git clone "$(cat readwrite.url)"` shows the token in `ps` and saves it in `.git/config`. It may be worth a note there.
- **Fragile error handling:** When `die` runs inside `$(...)`, it only exits the subshell. Callers rely on the `|| die` fallbacks to catch the failure.
- **Untested timeout path:** No test covers an SSM `TimedOut` or `Pending` state after the polling retries run out.
- **Symlinked directory:** The pre-write check on the URL file doesn't reject a symlinked parent directory. This is low risk for a tool only the operator runs locally.

**Gate and mutation:**
- **Before:** state `OPEN`, headRefOid `be86339de045824528293c54758e5b42ab87d61f` (matches the head the panel passed), isDraft `true`.
- **Action:** ran `gh pr ready https://github.com/kriscendobot/minion.town/pull/176`, which succeeded.
- **After:** isDraft `false`, headRefOid still `be86339de045824528293c54758e5b42ab87d61f`.

**Follow-ups:** none required. The un-draft hardening ideas above (the lost token on a failed mint and the ordering in `destroy`) could become follow-up issues if the maintainer wants them.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr176-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (224115 cached reads)
- Output: 1440 tokens
- Cost: $0.41115100000000004
- Wall-clock: 44s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
