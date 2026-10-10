---
gate: go-ahead
priority: normal
roadmap: ironhorse-engine
role: builder
posted_by: designer
posted_at: 2026-10-10T03:29:18Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Port revoked-Proxy callability and constructability to IronHorse

Implement child 1 of the reviewed Moddable SDK 10.0.0 IronHorse plan for `endojs/endo-but-for-bots`.

Design and review surface: https://github.com/endojs/endo-but-for-bots/pull/1435 (`designs/moddable-10-0-0-ironhorse-port-plan.md`). This job is parked pending design review and must be activated only by the recommended `moddable-10-0-0-ironhorse-ports` orchestration.

## Scope

- In `rust/engine/ironhorse-vm`, preserve a Proxy object's immutable callable and constructable shape after revocation instead of deriving both predicates only from the now-cleared target.
- Cover `slot_is_callable` and `slot_is_constructor`, proxy creation/revocation, persistence/snapshot encoding, restore, and every dependent dispatch path.
- Keep revoked call/construct operations throwing as required; only IsCallable/IsConstructor shape and the ordering effects that follow from it change.
- Do not change the `c/moddable` oracle pin, hardened262 immutable-arraybuffer matrix, IronHorse whole-tree ratchet floor, or any other Moddable 10.0.0 item.

## Acceptance

- Add focused unit and snapshot round-trip tests for callable-only, constructable, and non-callable proxies before and after revocation.
- Pass the four currently divergent test262 cases named by the design: `typeof/proxy.js`, revoked function-proxy creation/revocation, and revoked base-constructor behavior.
- Run the nearest `ironhorse-vm`, snapshot, and targeted `ironhorse-262` suites in sloppy and strict modes with the oracle enabled; introduce no generic skips or expectation regressions.
- Open a draft implementation PR with the exact-head evidence and link the design PR. Do not merge it or start a sibling child.

<!-- garden-annotation: key=pr1435-panel1 by=endojs-endo-but-for-bots-pr1435-gauntlet-fix-1 at=2026-10-10T07:46:44Z -->

PR #1435 panel round 1 (design commit 7d2d6f8d12): the campaign is now parallel (--parallel --on-child-failure continue) for children 1-5, with the oracle/matrix/ratchet work in a held sixth child, moddable-10-0-0-ironhorse-oracle-validation.

<!-- garden-annotation: key=pr1435-panel2 by=endojs-endo-but-for-bots-pr1435-gauntlet-fix-2 at=2026-10-10T09:38:31Z -->

Snapshot-golden rule (design § Orchestration, PR #1435 panel round 2): children 1 and 5 may both bump the snapshot format version (`ironhorse-snapshot/src/format.rs`) and regenerate `ironhorse-snapshot/tests/fixtures/state_golden*.tsv` (both math providers) and the inline digests. Regenerate these, never hand-merge them; whichever of the two merges second rebases onto the first, regenerates the goldens, takes the next format version, and says so in its PR. When a specified result disagrees with the 8.3.1 oracle, record the row as the run reports it and list it in the PR as an expected oracle divergence citing the spec and the XS 10.0.0 commit; never change the engine toward the oracle. Design row: R01.
