I replaced the body of endojs/endo-but-for-bots#1481 with the pruner-trimmed text from the job spec.

- **Check first:** the live body still had a `### Scaling Considerations` section, so the trim had not been applied yet and this was not a no-op.
- **Edit:** I ran `gh pr edit 1481 -R endojs/endo-but-for-bots --body-file <file>` with exactly the text between the job's BEGIN/END markers.
- **Verification:** I read the live body back and compared it with the file. The only difference is one blank line at the very end, which came from the `gh` readback, not from the content.
- **Resulting sections:** the body now has only the Security, Testing and Upgrade sections. The new Security bullet on the per-peer resume handshake cap is in, and the `garden-job` marker is still there.

Nothing else on the PR was touched, and there were no garden-repo changes or commits. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-fix5-body-trim.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176709 cached reads)
- Output: 2486 tokens
- Cost: $0.4385658
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
