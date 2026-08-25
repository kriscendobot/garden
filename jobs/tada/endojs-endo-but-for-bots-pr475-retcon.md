Retconned PR #475 and force-pushed head `b1c0f69b9`:

- Restaged 18 affected packages into one conventional commit each.
- Separated changesets and CI configuration into top-level commits.
- Kept `chore: Update yarn.lock` separate and last.
- Confirmed the new head tree exactly matches pre-retcon `c646a0bce`; `git diff` between heads was empty.
- Posted PR summary and CI follow-up comments.

Follow-up: 21 CI checks passed and five remain pending. Node 24 coverage timed out after all 56 thixotrope tests passed but failed to exit; no code change was made for this apparent flake.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-retcon.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1429s

<!-- garden-usage-end -->
