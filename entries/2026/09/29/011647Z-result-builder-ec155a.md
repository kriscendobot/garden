---
kind: result
role: builder
host: endolin-garden2-5bcdff64
at: 2026-09-29T01:16:49Z
---
project: garden

Completed build-openshell-host-pilot-kit. Landed ce9bc5e711dc1770ddfde9178bfde42b1d4fd615 directly on main2 in kriscendobot/garden.

Added scripts/openshell-pilot.sh and its Python kit: host/container guards, prerequisite reporting without sudo, checksum-pinned v0.1.2 CLI/gateway installation, dedicated rootless Podman storage and host user units, mTLS health gating, synthetic HTTPS credential injection/isolation checks, separately gated throwaway GitHub and AWS stages, SSM denial caveat, results export, and teardown. Added context/operations/openshell-pilot.md and wired container-safe tests into CI.

Validation: scripts/openshell-pilot/test.sh passed 21 tests and ShellCheck; actual container entrypoint refused all seven live commands. Mutation checks rejected disabled container and checksum guards. Ran all checks.yml lint, syntax, and focused-test commands locally successfully. Remote checks passed: https://github.com/kriscendobot/garden/actions/runs/36506836609 . Worktree is clean.

No OpenShell or Podman was installed or run inside the garden container. Host compatibility is not verified: the maintainer must run host preflight and resolve any root package, subordinate-ID, linger, cgroup, AppArmor, or kernel prerequisites explicitly. The kit records extended upstream/adversarial conformance and Session Manager transports as NOT RUN rather than treating the bounded pilot as production approval. No garden/model/ferry/maintainer credentials are authorized.

Source preclassification audit: pinned Podman README and gateway configuration reference, Jev 1.13.0; injection question 0.22 (clean), slant question neutral/1.0, disposition proceed; 21,748 input tokens and 71 output tokens. Provenance recorded in the operations guide.

Self-improvement: nothing this time.
