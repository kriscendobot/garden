---
gate: go-ahead
priority: normal
posted_by: designer
posted_at: 2026-10-09T21:57:11Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# IronHorse: bump the XS oracle to Moddable 10.0.0 and mirror the compiler deltas

Repo: endojs/endo-but-for-bots, base `llm` (frozen `llm-<sha>` snapshot per skills/frozen-base-branch). Design: designs/ironhorse-moddable-10-0-0-port-plan.md on branch design/ironhorse-moddable-10-0-0-port-plan (endojs/endo-but-for-bots; design PR from job moddable-10-0-0-ironhorse-port-plan-20261009). Read the design first; its classification table and § Oracle and ratchet impact are normative for this child. Open a DRAFT PR via ensure-pr.sh; completion stages the gauntlet.

If you genuinely finish but do not achieve the gated outcome below, end your report with the exact lines `<<<GARDEN-ORCHESTRATION-FAILED>>>` then `<<<GARDEN-JOB-COMPLETE>>>`.

PRECONDITIONS (stop and message the maintainer via message-user.sh if any is unmet; do not work around them): design open questions 1–3 answered on the design PR (xsnap gitlink vs oracle-only pin; floor re-measure authorization; direct vs stepped bump); Moddable 10.0.0 marked latest (planned 2026-10-12); the ironhorse-test262-ratchet delegation paused and no crank PR open.

Work (precedent: job port-endor-oracle-bump-8-3-1): move the oracle pin 8.3.1 (`23b4d6b0a65f`) → 10.0.0 (`5f215f776f93` or the final tag commit) per the answered decision; define `mxImmutableArrayBuffers=0` explicitly in `xs-oracle/build.rs` (child ironhorse-immutable-arraybuffer flips it). Audit the 8.3.1→9.5.0 `xs/sources` delta (not covered by the design) and record it in `rust/engine/README.md` § upstream delta tracking. Mirror in this PR every compiler delta required for byte identity — at least the `switch` discriminant temp local (moddable 051b31b2: `coder.rs` `code_switch` + scoper push/pop of one variable) and the 65535 scope-slot "too many variables" SyntaxError (moddable cfe72a8c; IronHorse currently emits corrupt bytecode) — plus any runtime delta whose corpus rows would otherwise turn Covered→Divergent. Re-run stage-1 harness, compile-diff corpora, whole-tree sweep; regenerate `expectations/whole-tree/` and a new `baseline/refresh-<date>/` with provenance at the new oracle; update README/provenance pin text.

Gated outcome: all bars green at the new oracle with zero new divergences, and the re-measured floor presented for maintainer authorization (never self-promoted). Size L.
