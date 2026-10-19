Opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1507 against frozen base `llm-92b91a7` at commit `93136aa71a`.

Implemented explicit transport registration/listening for `@endo/ocapn-noise`, including atomic hint publication and withdrawal, TCP/WebSocket migration, daemon integration, types, documentation, changeset, and lifecycle regression tests.

Verification:

- OCapN-Noise: 81 tests passed in each of three SES configurations.
- Focused daemon OCapN suite: 9 tests passed.
- Package lint/type checks and all 12 pre-push gates passed.
- Mutation testing confirmed the TCP retry regression test fails without bind-failure cleanup.
- Repository-wide verification exposed pre-existing zizmor parsing incompatibility and Unix-socket path-length failures in the long isolated worktree; these are documented in the PR.

Follow-up phases remain: composite transport/codec hints, ordered fallback, and TCP+CBOR framing. Reported stale library indexing to `role/scholar`.

Self-improvement: no role or skill changes needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-network-transport-separation-next-phase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 6168s

<!-- garden-usage-end -->
