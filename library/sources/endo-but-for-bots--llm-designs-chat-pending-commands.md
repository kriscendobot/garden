---
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
section_count: 4
status: current
notes: |
  **Status: Not Started** upstream. A UI-only solution to the
  blocked-command-bar / no-command-history / asymmetric-command-record
  problems caused by the indeterminate spinner gating the entire command
  bar on each in-flight operation. Names the deeper daemon-side
  alternative (`daemon-commands-as-messages`) and dual-positions itself
  as both near-term solution and fallback if the daemon change is
  deferred. Notable as a worked example of *near-term-UI vs. invasive-
  daemon-change* dependency framing.
---

> Abstract: Familiar Chat's pending-commands region — a near-term UI
> fix for the indeterminate-spinner behavior that today locks the
> entire command bar on each in-flight operation
> (`contentEditable = false`, `pointer-events: none`, `opacity: 0.5`).
> The design adds a visually distinct region between the transcript and
> the command bar that holds one card per dispatched command, with
> per-card progress indicator, elapsed-time display, and explicit
> success/failure transitions (success fades, failure persists). The
> implementation change is small (three chat-package files including
> one new `pending-commands.js`): `executeWithSpinner` is replaced with
> a *dispatch-then-release* pattern that adds a card to the pending
> region, fires the command but does not await it, routes the eventual
> `.then` to the card's `resolve` / `reject`, and exits command mode
> synchronously. This unlocks the bar mid-flight and admits multiple
> concurrent commands; the only ordering concern is *user intent*
> (rename-after-adopt), which the pending region makes visible by
> showing what is still in flight. The design self-positions as a
> UI-only fix and names a deeper daemon-side alternative (`daemon-
> commands-as-messages`, not yet ingested) that would model commands
> themselves as self-addressed messages with reply-message results,
> subsuming the pending region into the transcript. The dual
> positioning — *both* near-term solution *and* fallback if the daemon
> change is deferred — is itself an exemplar of *near-term-UI vs.
> invasive-daemon-change* dependency framing in this design corpus.

| Section | Topics | Status |
|---------|--------|--------|
| [motivation-and-problems](../sections/endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems.md) | chat-ui | current |
| [pending-region-and-card-states](../sections/endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states.md) | chat-ui | current |
| [unlocking-and-concurrent-commands](../sections/endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands.md) | chat-ui | current |
| [relationship-to-commands-as-messages](../sections/endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages.md) | chat-ui | current |

## See also

- [endo-but-for-bots--llm-designs-chat-command-bar.md](endo-but-for-bots--llm-designs-chat-command-bar.md) — the command-bar state machine; `executeWithSpinner` is the gate this design opens; the bar is released mid-flight rather than after settle.
- [endo-but-for-bots--llm-designs-chat-edit-message-ui.md](endo-but-for-bots--llm-designs-chat-edit-message-ui.md) — sibling design whose in-flight edits also use the indeterminate-progress affordance; the two designs share a UI shape for in-flight operations.
- [endo-but-for-bots--llm-designs-chat-invariants.md](endo-but-for-bots--llm-designs-chat-invariants.md) — the six chat UI invariants; the asymmetric persistence (success fades, failure persists) is an instance of *errors deserve attention*.
- `daemon-commands-as-messages` (not yet ingested) — the deeper daemon-side alternative this design defers to and dual-positions against.
