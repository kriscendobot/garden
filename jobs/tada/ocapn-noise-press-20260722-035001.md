OCapN-over-Noise press, dispatch 15 (2026-07-22 ~03:55Z) — steady state confirmed, all milestones re-proven live.

**Assessment (nothing regressed, nothing to rebase):**
- Stack heads unchanged since the 2026-07-19 restack: #340 `6eb31274`, #684 `cc398cb1`, #688 `469335e6`, #693 `73ad1b6d`, #683 `64b6dac5`, crossed-hello fix #806 `1e4f9104`. All six OPEN, DRAFT, MERGEABLE.
- `llm` advanced `ec6deecfec` → `ede9066b81` — a single merge (#809, `packages/daemon/designs/daemon-persistent-stores.md`, a design doc only). Zero OCapN/Noise impact; every stack PR re-verified MERGEABLE against the new base, so per the settled policy (restack only on CONFLICTING or degraded checks) no rebase.
- #806 remains 22/22 checks SUCCESS with zero reviews and zero comments — its merge into `llm` is still the next external unblock.

**Live proofs (real command output captured this dispatch, from a fresh worktree at #693 head `73ad1b6d`):**
- Both endpoints answer 426: `https://minion.town/ocapn` and `/ocapn-daemon`.
- Greeter demo (`packages/daemon/demo/minion-town/run-demo.sh`): SSM-fetched the live daemon location (designator `810b996c…`, unchanged since dispatch 13), dialed `wss://minion.town/ocapn`, Noise IK completed, `RESULT {"ok":true,"reply":"Hello, the local peer!…"}`.
- Cross-host Pet-Daemon invite/accept (`run-cross-host.sh`): invitation minted on the minion.town daemon (container at `a371b007`), accepted by a local Pet Daemon over `wss://minion.town/ocapn-daemon`, peer bound as `minion`, `E(adder).add(2,3) = 5` plus greeting round-trip → **CROSS-HOST DEMO PASSED**. Trailing `Termination requested` is the known benign teardown race.

**What changed:** memory `ocapn-over-noise-goal` updated to record dispatch 15, the new `llm` head, and a simplified fresh-worktree recipe discovered this dispatch: `TMPDIR=<scratch dir> corepack yarn install` (sandbox disabled) builds `better-sqlite3` directly — `/tmp` being noexec was the real blocker, so the old skip-build + copy-the-`.node`-file dance is unnecessary. No evidence comment posted on #693 (nothing changed since dispatch 11's comment — no-repeat policy). No garden or project commits needed; this dispatch's project worktree was torn down after the proofs.

**Follow-ups:** (1) merge of #806 (green, unreviewed since 2026-07-20) into `llm` remains the next external unblock; restack after it lands to inherit the crossed-hello settlement fix. (2) Likely next implementation arc remains design #794 (key-only session boundary) — designer/builder scope, not press scope. (3) Standing open items unchanged: mutual bidirectional pairing, `daemon-agent-network-identity`, session-reconnect design, remote TCP+CBOR blocked by minion.town's 443-only security group. (4) Housekeeping observation: ~10 completed-dispatch `project-wt-ocapn-noise-press-*` worktrees are accumulating under `scratch/` (the 20260717-182002 reuse worktree is deliberately kept; the rest look reapable) — a candidate for a cleanup job if disk pressure appears.
