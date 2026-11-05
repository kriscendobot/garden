Implemented and pushed file-based secret management to `main2` at `afd9d789d84`.

Changes include the read-only secrets mount, placement/import/status/watchdog tools, fixed-operation broker and wrappers, outbound ledgers, sandboxed per-job key injection, TypeSafe capability gating, systemd units, migration documentation, and updated provider guidance. No real secret values were accessed or changed.

Verification passed: secret management 15/15, broker 8/8, capability gating 28/28, fetch 106/106, classifier 19/19, Kimi 53/53, OpenCode 15/15, monk 20/20, Codex completion 29/29, provider and lifecycle suites, systemd documentation/install tests, shellcheck, and `git diff --check`.

Follow-up: the maintainer must rebuild and recreate each live container once, then import or place keys manually. Subsequent rotations require no recreation. Live mount/bubblewrap behavior was not verified in the existing pre-migration container because that requires the documented rebuild and recreation.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-secret-management-20261105.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2819s

<!-- garden-usage-end -->
