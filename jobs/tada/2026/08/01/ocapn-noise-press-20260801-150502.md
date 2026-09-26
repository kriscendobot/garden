Dispatch complete. This was a verification-only pass — no garden-repo source changed, so nothing to commit to `main2`; all project-worktree activity was demo execution (no source edits pushed).

## Completion report

**Job:** standing press-driver for OCapN-over-Noise (`endojs/endo-but-for-bots`, base `llm`), dispatch of 2026-08-01 ~15:13Z.

**Assessment (idempotent, assess-don't-assume):** All five stack PRs are unchanged since the prior dispatch — #340 `83f55ea9`, #683 `a1abe571`, #684 `b18eee0c`, #688 `a137a121`, #693 `803ef977`. A full opus M5 re-proof had already posted to #693 ~10:41Z today. All five remain MERGEABLE. Base `llm` has advanced to `3ec55851d` (stack now 133 behind), but GitHub's 3-way merge still reports every PR MERGEABLE, so I held to the settled restack-only-on-conflict policy and did **not** rebase (also avoiding a collision with the live `pr340-shepherd`).

**Fresh empirical proofs captured this dispatch (every "works" claim = real command output), at head `803ef977f`:**
- **Transport surfaces live now:** `https://minion.town/ocapn` → 426, `/ocapn-daemon` → 426, `tcp/8929` CONNECTED; toy `endo-ocapn-tcp-toy` Up 3 days, stable designator `c1ac846d…`.
- **Cross-host TCP+CBOR** (`ocapn-tcp-client.mjs` → `minion.town:8929`, raw TCP + netstring CBOR + Noise IK): `RESULT {"ok":true,…}`, `getNodeId()` == designator → reverse peer auth shown empirically.
- **Cross-host M5 WS via pure `endo` CLI** (`run-cross-host-cli.sh`): `endo invite` on minion.town → local `endo accept` over `wss://minion.town/ocapn-daemon` + Noise IK → bidirectional message round-trip — `CROSS-HOST CLI DEMO PASSED`.
- **Local two-daemon both transports** (`two-daemon-invite-accept/run.mjs`): invite/accept + `add(2,3)=5` + Far-identity preservation — `DEMO PASSED` on `ocapn+noise+tcp` and `ocapn+noise+ws`.

**Finish line:** M1–M5 hold empirically today over both WS/HTTPS and TCP+CBOR, cross-host, culminating in Pet-Daemon↔Pet-Daemon invite/accept. The sole remaining gate is maintainer-only: **#340 is APPROVED + MERGEABLE + 25/25 green, awaiting the merge word** (already surfaced in prior dispatches — not re-nudged to avoid 6-hourly noise).

**Outputs:** Dispatch summary posted to #693 (issuecomment-5152024262). Memory `ocapn-over-noise-goal.md` updated with dispatch-25 state + env gotchas.

**Follow-ups (unchanged, all beyond press-verification scope):** the #340 merge word; kriskowal's review of design #886; daemon-level cross-host *TCP* (boot script gates only `ws-listen-addr`); mutual/bidirectional pairing; `daemon-agent-network-identity` items 3–4; `ocapn-noise-session-reconnect` (Proposed, unimplemented).

**Env note for next dispatch:** `ensure-project-worktree.sh`'s warm-cache links `node_modules` for the `llm` **base** — after checking out the #693 head, re-run `yarn install` to link `@endo/ocapn`/`@endo/ocapn-noise` into `packages/daemon/node_modules`, else the spawned daemon throws "Cannot find package '@endo/ocapn'". Use `TMPDIR=/run/user/$(id -u)` (short + exec; `/tmp` and `/dev/shm` are noexec).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocapn-noise-press-20260801-150502.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 71 tokens (2517163 cached reads)
- Output: 26366 tokens
- Cost: $2.7994815
- Wall-clock: 520s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
