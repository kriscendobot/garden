Completed and pushed to `main2`.

- Existing usage-meter fix/regression was already present in `dc35c6f057`.
- Widened mandatory shellcheck to all `scripts/jobs/*.sh`; fixed surfaced entrypoint findings and documented excluded nested trees.
- Fixed CI fixture tests to create temp directories under writable `$HOME`.
- Restored Scholar’s audited inbox allowlist entry.

Checks passed locally and [GitHub Actions run 33562549428](https://github.com/kriscendobot/garden/actions/runs/33562549428) is green.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-usage-meter-unbound-var-and-widen-shellcheck-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (7 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (7 engagement(s) unpriced)
- Wall-clock: 6994s

<!-- garden-usage-end -->
