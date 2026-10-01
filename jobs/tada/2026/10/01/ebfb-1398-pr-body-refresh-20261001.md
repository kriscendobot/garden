I replaced the PR #1398 body with the job's text, verbatim. The PATCH succeeded on this host's bot PAT. The 403 that blocked the fix-1 stage happened on oros-studio, and it didn't come up here.

**Action:** I wrote the body between the markers to a temporary file and ran `gh api -X PATCH repos/endojs/endo-but-for-bots/pulls/1398 -F body=@<file>`.

**Check:** I read the body back from the API and diffed it against the file. The only difference is one extra trailing newline, and that comes from `jq` printing the value, not from the stored body. The title is still "feat(daemon): layer 8 — a SturdyRef for a formula without incarnation".

**What the new body covers:**
- **Integrator:** how this layer squares with #695, in the Security Considerations section.
- **Benchmarker:** why there's no benchmark, in Scaling Considerations.
- **Pruner:** the Stack index is gone.
- **Curator:** the changeset is held, in Documentation Considerations (it matches head 289b48d44, which removes the changeset).
- The `<!-- garden-job: ebfb-sturdyref-layer8-daemon-formula-20260930 -->` marker is still there.

I changed nothing else: no commits, and no edits to garden files.

**Follow-up:** the oros-studio PAT still can't write PRs on endojs. Any later PR-body edit should be pinned to this host or one with the same write access.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-1398-pr-body-refresh-20261001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (64128 cached reads)
- Output: 3002 tokens
- Cost: $0.41768960000000005
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
