---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/captp/src/trap.js
source_line_range: 1-105
file_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
file_commit_date: 2025-10-09
file_commit_author: Kris Kowal
comment_subject: Trap — synchronous CapTP proxy lifted from E.js with three-method TrapImpl and no this-receiver-check
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-sixth comment-fragment ingest (cycle 154). **First
  @endo/captp source file ingested** (the captp cluster has
  six substantial source files; trap.js is the smallest and
  most pedagogically clear). 105 lines.

  §Load-bearing-relationship: file's one-line opening comment
  declares *Lifted mostly from `@endo/eventual-send/src/E.js`*.
  Cycle 146 ingested E.js; this file *mirrors* its structure
  with synchronous-blocking semantics in place of eventual-
  send semantics. §lifted-from-X-comment discipline names the
  relationship at the file top. §shared-shape-different-
  semantics observation: same lattice, different operator.

  §Three-method-TrapImpl interface: applyFunction /
  applyMethod / get. Narrower than E.js's five-surface API
  (E + E.get + E.resolve + E.sendOnly + E.when). §narrowed-
  API-for-narrower-semantics — each removed method was
  promise-related; Trap's whole point is *no promises*.

  Single most structurally interesting move: §no-`this`-
  receiver-check (vs cycle 146's §this-receiver-check via
  concise-method-syntax). Returned function is an *arrow
  function* — no `this` to depend on; detach-attack vector
  doesn't exist. §arrow-function-is-already-detach-safe
  property emerges *for free* from closure semantics. No
  defensive code needed.

  §baseFreezableProxyHandler identical to E.js (four meta-
  traps return false). §code-reuse-via-duplication discipline
  (not via shared import) preserves package independence —
  cross-package shared helper would create dependency between
  @endo/captp and @endo/eventual-send.

  §funcTarget + §objTarget identical to E.js with §verbatim-
  comment-shared-across-derived-files pattern (same JSDoc
  word-for-word about §preparing-for-stabilize.md). §rationale-
  is-load-bearing observation.

  §nearTrapImpl default: §local-fast-path-via-trivial-impl —
  trivial dispatcher that lets the same `Trap(x)` surface
  work in both near and far cases; only the *injected
  trapImpl* differs. §minimal-trampoline form (each method
  body one line). Parallel to cycle 119's §pattern of *same
  envelope verbs whether in-process or cross-process*.

  §makeTrap factory: §callable-with-methods discipline
  (parallel to E.js's makeE) — Trap is function + .get
  property. §simpler-shape-because-fewer-methods: direct
  property assignment vs E.js's Object.assign. Final
  harden(Trap) makes whole structure immutable.

  §has-trap-pretends-everything-exists with §honest-TODO: *TODO:
  has property is not yet transferrable over captp*. §has-
  property-not-yet-transferrable-over-captp acknowledgment —
  for synchronous calls, accurate `has` would be implementable
  but isn't yet. §honest-acknowledgment-of-API-gap.

  §sibling-files-completing-the-CapTP-surface — together with
  cycle 146's E.js, this file describes the full CapTP
  application interface. captp.js (1012 lines, not yet
  ingested) sits below both as the wire protocol.

  Same coordinated-update commit `e56bf00f` as cycles 108 +
  110 + 115 + 118 + 123 + 125 + 132 + 134 + 136 + 138 + 140 +
  144 + 148 + 150 + 152 + 154 — coordinated-update cluster
  grows to 16 files.

  Cycle 154 was nominally chat-lane (exhausted at 20/20);
  papers-lane blocked 48+ consecutive cycles. Pivoted to
  comments-lane.
---

> Abstract: `trap.js` (105 lines) is the **synchronous-CapTP
> proxy surface**. The file's one-line opening comment
> declares its derivation: *Lifted mostly from `@endo/
> eventual-send/src/E.js`* (cycle 146). Last touched 2025-10-
> 09 by Kris Kowal in cycle 108's coordinated-update commit.
>
> **First @endo/captp source file ingested.**
>
> §Load-bearing-relationship: §lifted-from-X-comment
> discipline names the relationship at file top. §shared-
> shape-different-semantics — same lattice, different
> operator (synchronous-blocking vs eventual-send).
>
> §Three-method-TrapImpl interface (applyFunction /
> applyMethod / get) — narrower than E.js's 5-surface API;
> §narrowed-API-for-narrower-semantics (no promise-related
> methods).
>
> **Single most structurally interesting move**: §no-`this`-
> receiver-check. Returned function is an *arrow function* —
> no `this` to depend on; detach-attack vector doesn't exist.
> §arrow-function-is-already-detach-safe property emerges
> *for free* from closure semantics.
>
> §baseFreezableProxyHandler + §funcTarget + §objTarget all
> *identical* to E.js. §code-reuse-via-duplication preserves
> package independence. §verbatim-comment-shared-across-
> derived-files pattern.
>
> §nearTrapImpl default — §local-fast-path-via-trivial-impl
> lets same surface work near and far; only injected
> trapImpl differs. §minimal-trampoline form.
>
> §makeTrap factory: §callable-with-methods + §simpler-
> shape-because-fewer-methods.
>
> §has-trap with §honest-TODO about wire transferrability.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check](../sections/endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check.md) | captp, eventual-send, hardened-javascript | current |

Tight 105-line file. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@HEAD` (commit
  `e56bf00f289ff8484094b785b11636b8bc71d87e`) via the local
  bare-clone.
- Last substantive touch 2025-10-09 by Kris Kowal in commit
  `e56bf00f` ("feat: Adopt @endo/harden"). Same coordinated-
  update commit as cycles 108 + 110 + 115 + 118 + 123 + 125 +
  132 + 134 + 136 + 138 + 140 + 144 + 148 + 150 + 152 + 154
  (16 files now).
- **Thirty-sixth comment-fragment ingest.** **First @endo/captp
  source file ingested.**
- Cycle 154 was nominally **chat-lane** (exhausted at 20/20);
  papers-lane blocked **48+ consecutive cycles**. Cycle 154
  pivoted to comments-lane.
- One cohesion-honest section.
