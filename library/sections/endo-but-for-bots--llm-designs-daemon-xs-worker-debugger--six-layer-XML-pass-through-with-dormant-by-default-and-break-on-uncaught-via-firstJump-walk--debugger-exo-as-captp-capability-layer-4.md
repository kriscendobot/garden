---
source: designs/daemon-xs-worker-debugger.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
status: current
title: §Debugger exo as CapTP capability (Layer 4)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

```js
const DebuggerI = M.interface('Debugger', {
  go: M.call().returns(M.undefined()),
  step: M.call().returns(M.record()),
  // ... 14 more ...
  followBreaks: M.call().returns(M.remotable()),
  help: M.call().returns(M.string()),
});
```

§The-`makeExo`-pattern (cycle 108's exo-makers.js): the
Debugger is a remotable object with §runtime-method-guards.
§Cycle-117's-Exo-pattern naturally extends to the debugger
domain.

§Design-Decision-5-named-explicitly: "This is the Endo way:
everything is a capability. The debugger can be granted,
delegated, and revoked like any other capability. A guest could
debug its own sub-workers if given the debugger capability."

§Debugger-as-revocable-capability is a §powerful-property:

- §Delegate to a co-worker for collaborative debugging.
- §Restrict via attenuating proxy (e.g., read-only debugger with
  no `setBreakpoint`).
- §Revoke when session ends.
- §Audit via `passableAsJustin`-friendly diagnostic logging.

§Compare-to-cycle-170-daemon-capability-filesystem's §caretaker-
facet-separation (DirControl + FileControl held by host; Dir/
File granted to guest). §A-debugger-trio could be: §DebuggerView
(read-only inspection) + §DebuggerControl (step/breakpoint) +
§DebuggerAdmin (attach/detach lifecycle).

§Cycle-178-daemon-xs-worker-snapshot's §snapshot-as-internal-
implementation-detail contrasts with §debugger-as-explicit-
capability-surface. §The-snapshot-is-hidden; §the-debugger-is-
named.
