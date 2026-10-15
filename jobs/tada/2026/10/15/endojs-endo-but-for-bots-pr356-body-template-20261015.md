I replaced the body of https://github.com/endojs/endo-but-for-bots/pull/356 with the template text from the job spec. That clears the panel-1 integrator/pruner must-fix: the body now has the template sections and no longer has the per-file tour.

- **Edit:** `gh pr edit 356 -R endojs/endo-but-for-bots --body-file <file>` exited 0. The PAT 403 that blocked the fix-1 stage on oros-studio did not happen from this host.
- **Check:** I read the body back with `gh pr view 356 -R endojs/endo-but-for-bots --json body` and diffed it against the spec text. The only difference was one extra trailing newline that `jq` adds to its output; the content matches exactly.

Nothing else changed: no garden or project-repo commits. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr356-body-template-20261015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (65236 cached reads)
- Output: 1292 tokens
- Cost: $0.3715112
- Wall-clock: 16s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
