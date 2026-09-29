---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse: live native-handle re-seating in xsnap, and lifting #1150's suspend refusal

Repo: endojs/endo-but-for-bots (base branch `llm`). Design: `designs/ironhorse-panic.md` § Host functions are messages too, and § Worker-owned power tables. Refs: #1018.

The host-call leg (branch `llm-ironhorse-panic-host-call`, job `endojs-endo-but-for-bots-ironhorse-panic-host-call-transcript`, whose PR is opened by `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr`) built the transcript side in `rust/endo/slot-machine-transcript`: `CallbackRegistry` admission, `Transcript::host_call`, `host_handle` with reconstruction descriptors, `reseat_handles`, `recovery_gate`, and `HostReplay`. It did NOT change live code. xsnap still refuses suspend while fs, SQLite or hasher handles are open (`rust/endo/xsnap/src/lib.rs` near `has_open_handles`, and the test `suspend_rejects_open_native_handles_without_stopping_worker`).

This job wires it live. Stack on the host-call branch, plus #989 and #1374 if they are still unmerged (skills/stacked-pr-build).
- Classify every xsnap host callback in `powers/*::CALLBACKS`.
- Give the fs, directory, SQLite and hasher tables logical ids with reconstruction descriptors. An incremental hasher may need its fed bytes recorded, or it gets no descriptor and is re-seated as broken.
- Route those callbacks through `Transcript::host_call`.
- On resume, re-seat through `reseat_handles` before replay.
- Then lift the suspend refusal. A resumed worker must never use a handle that was not actually re-seated.

Acceptance: the § Verification host-handle / effect bullets, driven against the live XS worker. Open a DRAFT PR via scripts/jobs/gardening/ensure-pr.sh with `Refs: #1018`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T18:14:21Z
