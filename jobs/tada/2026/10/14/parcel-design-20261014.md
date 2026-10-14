Updated and pushed the Parcel design stack without touching code:

- Canonical design: [PR #1460](https://github.com/endojs/endo-but-for-bots/pull/1460), head `9728449f4e33f172b4692a404fa8a35bb04fdd15`.
- Layer 1: [PR #1389](https://github.com/endojs/endo-but-for-bots/pull/1389), head `c0b14bfb642e1bb362c7b74455f8a26f05c779bc`.
- Layer 9: [PR #1399](https://github.com/endojs/endo-but-for-bots/pull/1399), head `2387972d7b373086850fda8fa2d4c317a6ab8a5a`.

Decisions:

1. Surface: `@endo/parcel`; `new Parcel(location, openHook)`; `Parcel.open`, `Parcel.isParcel`, privileged `Parcel.locate`, and `E.open`. No handler object, `enliven`, or `E.enliven`.
2. Authority: `%InitialParcel%` has `locate`; `%SharedParcel%` does not. They share a prototype/brand, follow `%SharedURL%`, and are hardened by lockdown. First shim wins; later evaluations adopt the visible constructor.
3. Semantics: pass style `"parcel"`; no pass-invariant equality; repeated opens need not converge; Parcels survive partition, cannot match grants, and open in a later turn.
4. Naming/encoding: CapData and Smallcaps carry inline marked locations; ordinary carriage has no renamed `d+`/`d-` slot. The ordered `t` code point and OCapN Syrup/CBOR forms remain. The wire tag stays `ocapn-sturdyref`; OCapN specification terminology is a separate non-normative decision.

Also corrected the essay’s prior-art framing, added the full nine-layer change map and ownership boundaries, superseded the old SturdyRef representation in the syscall-retention design, and synchronized the README roadmap, milestone, graph, and estimate.

Layer 9 remains a draft with four review gates: produce behavior, named-call behavior, tool-layer ownership, and explicit worker retention. The pivot builder may proceed through layers 1–8 but must not implement those unresolved choices.

Verification: Prettier passed; both Mermaid diagrams parsed. PRs #1460 and #1389 are green. PR #1399 retains an inherited layer-6 TypeScript failure at `packages/captp/test/sturdyref.test.js:264`, introduced by `7a341141ca7`; the failure is unrelated to these design-only changes.

Essay classification was unavailable because `TYPESAFE_API_KEY` was absent; the documented proceed-unclassified fallback was used, with no classifier answers, and the page was treated only as design-source data. Added the `Parcel` library keyword route and requested scholar review.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/parcel-design-20261014.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 2960s

<!-- garden-usage-end -->
