Landed `ce9bc5e711d` on `main2`.

Added the host-only OpenShell pilot kit, pinned installer, rootless user services, synthetic isolation checks, gated GitHub/AWS stages, reporting, teardown, and host instructions.

Validation: 21 tests, ShellCheck, local CI checks, and [remote CI](https://github.com/kriscendobot/garden/actions/runs/36506836609) passed.

No OpenShell or Podman was installed or run in the container. Host compatibility remains unverified. Follow-up: run host preflight and explicitly resolve any package, subordinate-ID, linger, cgroup, or kernel prerequisites.

Reference preclassification: proceed; injection 0.22, neutral 1.0; 21,748 input/71 output tokens.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-openshell-host-pilot-kit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2003s

<!-- garden-usage-end -->
