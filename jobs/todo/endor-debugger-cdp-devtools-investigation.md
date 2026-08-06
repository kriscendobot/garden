---
role: researcher
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-08-06T05:45:59Z cleared=none -->

# Investigate speaking V8's debugger protocol so Chrome DevTools and VSCode can drive Endor

Maintainer directive (kriskowal, 2026-07-28, via the liaison on
`endolin-garden-ece02cb4`): a follow-up for Endor after xs2rust, to investigate
*"converting the debugger protocol to v8's debugger protocol such that it can be
driven from Chrome's devtools or VSCode."*

**Research and proposal only. Write no implementation in this job.** The output is
findings plus a filed issue.

## Where this picks up

The debugger row of the port landed on
https://github.com/endojs/endo-but-for-bots/pull/600 (branch `xs2rust-endor`) as
the `endor-debug` crate at `rust/engine/endor-debug`, speaking **xsbug's XML
protocol**: `command.rs` parses client to VM xsbug XML (a port of `fxDebugParse`
from `c/moddable/xs/sources/xsDebug.c`), `echo.rs` serializes VM to client
`<xsbug>` CRLF-framed messages, and `transport.rs` abstracts XS's five C platform
hooks behind a `DebugTransport` seam carried over the daemon's
`debug`/`debug-attach`/`debug-detach` envelope verbs. Slice 3 confirmed that seam
end to end against a live `endor_vm::Interp`.

That protocol has exactly one client, xsbug. This job asks what it would take to
speak the protocol that Chrome DevTools and VSCode already speak.

## Get the protocol landscape right first, because it is easy to conflate

Establish and state plainly, verified against published specifications rather than
recall:

- **CDP**, the Chrome DevTools Protocol, is what V8 and Chrome expose and what
  Node's inspector implements a subset of. JSON messages, conventionally over a
  WebSocket, with an HTTP discovery surface.
- **DAP**, the Debug Adapter Protocol, is what VSCode's editor UI speaks to a debug
  adapter. It is **not** CDP.
- VSCode's JavaScript debugging goes through its `js-debug` adapter, which speaks
  DAP to the editor and CDP to the target.

So the question "can VSCode drive it" probably resolves to "does `js-debug` attach
to it as a CDP target", not "do we implement DAP". **Verify that** rather than
assuming it, and say what the actual attach path and configuration would look like.
If a thin DAP adapter turns out to be the cheaper route to VSCode than full CDP
fidelity, say so.

## The questions to answer

1. **Minimum viable domain and method set.** Which CDP domains and which methods
   inside them are actually required before Chrome DevTools will attach and be
   useful, as opposed to the full surface. Expect at least `Debugger` and
   `Runtime`, and say what the real floor is: script registration, breakpoint set
   and clear, pause and resume events, the stepping verbs, call frames with scope
   chains, expression evaluation in a frame, and pause-on-exceptions. Name what
   DevTools degrades gracefully without and what it refuses to start without.
2. **The object model gap, which is the substance of the work.** xsbug echoes
   frames, locals, and globals as serialized XML with hex address handles. CDP
   hands out `RemoteObject` values with `objectId` handles that the client
   dereferences lazily on demand. These are different models, not different
   spellings. Work out the mapping: handle lifetime and invalidation, when a handle
   is released, how object graphs are expanded lazily, and how this interacts with
   `endor-vm`'s slot arenas and its garbage collector. Say whether the existing
   `<toggle>` expansion path (noted as parsed but inert in `session.rs`) is the
   right seam or the wrong one.
3. **Script identity and source.** CDP wants script ids, URLs, and retrievable
   source, plus source maps. Say what Endor can honestly supply, and treat
   **compartments and SES** as a first-class complication rather than a footnote:
   the same source text can be instantiated in several compartments, module
   identity is not a file path, and a DevTools client assumes a URL-shaped world.
   Say how that is reconciled, or that it is not cleanly reconcilable and why.
4. **Transport and discovery.** CDP clients expect a WebSocket and a discovery
   endpoint. The current seam is a byte transport over the daemon envelope bus.
   Say what has to exist, where it would live, and whether the `DebugTransport`
   trait survives as the seam or needs replacing.
5. **Strategy, with a recommendation.** Compare at least three shapes and say which
   you would pick and why: (a) native CDP inside `endor-debug`, alongside or
   replacing the xsbug protocol; (b) an external bridge process translating CDP to
   the existing xsbug seam, which keeps the engine untouched and may be far cheaper
   to prove; (c) a DAP adapter aimed at VSCode only. Address whether xsbug support
   is kept, deprecated, or dropped, and what parity with the C-XS path requires.
6. **Security, and treat this as first-class.** A debugger endpoint is total
   authority over the vat: arbitrary evaluation in any frame, full heap
   inspection. CDP over an open WebSocket has a history of exposure through
   listening on reachable interfaces and through browser-origin attacks against
   discovery endpoints. Work out how attach is authorized in the daemon, why it
   must not listen on a public interface by default, how this composes with the
   ocap discipline the platform depends on, and what the failure mode is if someone
   ships it enabled.
7. **Cost when disarmed.** The row's standing bar is metering neutrality and
   "always compiled, dormant by default". Confirm the proposal keeps that, and do
   not perturb the C-XS path.

## Relation to the sibling investigation

Plan job `xs2rust-endor-debugger-caught-vs-uncaught` asks how to express a
break-on-caught versus break-on-uncaught distinction on the current protocol.
**CDP already models this natively**, as a pause-on-exceptions state with distinct
values for none, caught, uncaught, and all. Verify the exact enum against the
specification rather than trusting this summary. If it holds, the two jobs
converge: adopting CDP largely answers the sibling job's protocol-shape question,
leaving only its VM-side question of whether the live handler chain can tell, at
throw time, that a catch sits above the throw. Read that job's findings if it has
landed, and say explicitly in your report whether adopting CDP subsumes it.

## Deliver

A `jobs/tada/` report with the findings, **and file an issue** on
https://github.com/endojs/endo-but-for-bots with the same findings, framed as
preparation for writing a proposal: the problem, the options with their
trade-offs, the security analysis, and a recommendation with a rough sense of the
work involved. Link the issue in your report. Do not open a pull request and do
not modify engine code in this job.

Ground every claim in specifications or code you actually read, and cite them.
Protocol details recalled from memory are exactly the kind of thing that is
plausibly wrong, so verify before asserting, and leave open what you cannot
establish.
