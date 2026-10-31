Completed the production runtime slice on `daemon-rename-to-manager`.

- Opened mergeable draft PR: https://github.com/endojs/endo-but-for-bots/pull/1594
- Commit `5c55ded255` renames Daemon/Mignonic runtime identifiers to Manager/Worker across constructors, types, powers, protocols, facets, wiring, and call sites.
- Preserved intentional compatibility boundaries: package/OS daemon terminology, persisted database names, and Rust supervisor ABI.
- Checks passed: daemon prepack declaration build, focused ESLint, 10 pre-push probes, diff/source audits, and runtime import smoke test.
- PR ledger records `Disposition: orchestrated-slice` and successor `build-daemon-rename-to-manager-surface`, which owns tests, documentation, fixtures, generated surfaces, and final acceptance.

Self-improvement: Nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-rename-to-manager-runtime.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 538s

<!-- garden-usage-end -->
