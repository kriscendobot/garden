This leg is done. Draft PR [#1372](https://github.com/endojs/endo-but-for-bots/pull/1372) (head `llm-ironhorse-panic-e2e-probe`, commit `db4c6fd77b`, `Refs: #1018`) was already open from an earlier attempt, and its gap report is already posted as a PR comment. This run confirmed that state and reconciled the report with the open-questions answers, which landed after the probe ran.

**Found in place (earlier attempt, committed and pushed):**
- **The test:** `rust/endo/xsnap/tests/panic_e2e_probe.rs` drives one real C-XS worker through three panic sources: an FFI callback panic, a stack overflow and a meter abort.
  - It has 5 passing tests that record today's behaviour and 6 skipped tests, one per missing stage, each naming its missing mechanism and the leg that owns it.
  - CI on `db4c6fd77b` is green (CI, OCapN Guile interop, IronHorse oracle sanitizers, security audit, mutual dependency versions). I did not rerun the tests locally.
- **The gap report** is in the PR body and in the marker comment `garden-probe-gap-report`. It has 12 gaps and a map from each gap to its later leg.
- **The PR stays draft.** It is marked as a probe, so no gauntlet follows.

**Pipeline stages today:**

| Stage | Exists? |
|---|---|
| 1. Panic mid-delivery | Partly: stack overflow and meter abort can't be caught, but after an FFI panic the guest keeps running |
| 2. One supervisor-visible `Panicked` | No |
| 3. Embargo discard | No: the pre-panic frame leaks for all three sources |
| 4. Terminate | Yes, but a stack overflow is misreported as a metering death |
| 5. Snapshot restore | The mechanism exists; nothing decides when to snapshot |
| 6. Replay up to the panicking delivery | No: re-delivery rebuilds the exact pre-panic heap but sends every frame again |
| 7. Debugger stop at the panic site | No |

**Gap → leg map:**

| Gap | Owner |
|---|---|
| 1 FFI panic runs on | cxs-panicked-adapter, needs a design call first |
| 2 every exit reported as "terminated" | cxs-panicked-adapter |
| 3 seven C-XS abort exits unclassified | cxs-panicked-adapter; halt-shape-unification; classification-lint |
| 4 no embargo | outbound-embargo |
| 5 which side writes the transcript | transcript (was unowned) |
| 6 a crank spans several envelopes | transcript, depends on #989 |
| 7 no replay mode | retry-replay |
| 8 host callbacks unclassified | host-call-transcript |
| 9 no restore point while native handles are open | host-call-transcript and retry-replay |
| 10 no `<panic>` message | debugger-panic-break |
| 11 uncaught throw not probed | retry-replay |
| 12 Ironhorse not on the delivery path | **unowned** (stage 8/9 integration) |

**Reconciled with the answers (design amendment #1370):**
- **Answered:** Gap 6 (a crank needs #989's one-delivery admission) and Gap 11 (normal rejections commit and continue; a throw that escapes the delivery adapter terminates).
- **Filed:** Gap 12 is now recorded as a dependency in `ironhorse-engine.md`.
- **Partly answered:** Gap 3 (which halts count as panics is settled, but the mapping of the other C-XS abort exits is not) and Gap 5 (the supervisor owns the records, but the module home is unnamed).
- **Still open:** Gap 1. The amendment describes the current guard but never says whether the guest may keep running after an FFI panic, or where the debugger stops for that source.

The PR body's list of open-question decisions still reflects the design's earlier leanings, not these answers. The addendum is the correction.

**Addendum not posted yet:** this host's bot token gets a 403 when commenting on endojs PRs. I posted a small job, `endojs-endo-but-for-bots-ironhorse-panic-e2e-probe-addendum`, pinned to `endolin-garden-ece02cb4`, to post the addendum comment word for word. It changes no code. The main deliverable does not depend on it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-e2e-probe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 112 tokens (5344499 cached reads)
- Output: 45099 tokens
- Cost: $3.7078718000000004
- Wall-clock: 992s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
