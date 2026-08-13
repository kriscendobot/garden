Disposition: **2 — partially honored**.

Freshly fetched refs:

- Current `origin/llm`: [`a54c3adbebf18fd837770d467433e480de498e8d`](https://github.com/endojs/endo-but-for-bots/commit/a54c3adbebf18fd837770d467433e480de498e8d)
- Pull-request head: [`e0c8accb3235a340ce2b4e4307138429a7d1e5f3`](https://github.com/endojs/endo-but-for-bots/commit/e0c8accb3235a340ce2b4e4307138429a7d1e5f3)

Evidence:

- The pull-request factory merely copies `opts.network` into the resolved slice specification and delegates it to the selected driver: [pull-request factory](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/sandbox/src/factory.js#L442-L489). Current `origin/llm` retains that behavior: [current factory](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/sandbox/src/factory.js#L402-L449).
- Current `origin/llm` already contains byte-identical copies of the pull request’s [private-address blocklist](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/sandbox/src/net/blocked-ranges.js#L28-L42), [nftables ruleset](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/sandbox/src/net/private-egress.nft#L33-L68), and [lockstep regression test](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/sandbox/test/blocked-ranges.test.js#L54-L78).
- The remaining bwrap gap is exact: `none` and `private` both retain the network namespace created by `--unshare-all`, while the supposed pasta process remains `null`; neither pasta nor `nft -f` is invoked. See [namespace selection](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/sandbox/src/drivers/bwrap.js#L228-L248) and [the inert placeholder](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/sandbox/src/drivers/bwrap.js#L733-L750). Thus bwrap `private` currently behaves like no egress, not public-only egress.
- Podman has a different unsafe partial state: it supplies NAT through pasta or slirp4netns, but explicitly leaves private-address filtering to the operator and never loads the nftables ruleset. See [Podman network mapping](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/sandbox/src/drivers/podman.js#L213-L227). It therefore permits public egress without enforcing the promised private-address denial.

Remaining gap: wire a per-slice routable namespace plus fail-closed nftables loading for bwrap, apply the same filter inside Podman’s rootless namespace, and add live tests proving public reachability while every documented private range is unreachable.

History disposition: no migration is needed. Current `origin/llm` already retains the desired policy in [the sandbox plan](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/PLAN/endo_posix_sandbox.md#L314-L327), the bwrap shortfall in [TADA 13](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/TADA/13_endo_posix_sandbox_phase1_bwrap.md#L179-L190), and the deferred runtime coverage in [TADA 14](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/TADA/14_endo_posix_sandbox_phase1_5_bwrap_hardening.md#L140-L159). Follow-up: [TADA 15](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/TADA/15_endo_posix_sandbox_phase2_podman.md#L55-L64) incorrectly marks Podman’s filtered `private` profile complete and should be reopened or corrected.

Verification: 52 targeted sandbox tests passed under the lockdown AVA configuration, including blocklist/ruleset consistency. Live bwrap, pasta, nftables, and Podman behavior was not verified because those executables were unavailable; the driver tests convert that condition into passing availability notices.

Changes: none. No files, commits, branches, pushes, or GitHub state were modified.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-private-network-egress.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 298s

<!-- garden-usage-end -->
