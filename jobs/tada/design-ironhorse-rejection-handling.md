Done. Here is my completion report.

---

## Completion report: `design-ironhorse-rejection-handling`

**Deliverable:** A rationale/analysis design document, `designs/ironhorse-rejection-handling.md` (303 lines), on the `endojs/endo-but-for-bots` fork, delivered as **draft PR #1016** against the `llm` roadmap branch. Single-file diff (design file only).

**What I wrote.** Per the job's structure, ending in a concrete recommendation for a future design/build job:

- **§1 — Why panic-on-reference-error matters.** Argued that unwinding through a `catch`/rejection handler before inspection destroys the exact program counter and heap at the fault site; that panicking freezes the world for a snapshot *even when a `catch` would have intercepted*; and that a reference error is the odd one out today (ordinarily recoverable) where `Halt::StackOverflow`/`Halt::MeterAbort` already get abort-to-host non-recoverability for free. Grounded in the actual engine facts — engine-raised reference errors build `Halt::Throw` today (`XS_CODE_GET_VARIABLE`/`XS_CODE_GET_LOCAL`), and the `Halt::StackOverflow` "abort to the host, not a catchable `RangeError`" doc comment — and framed the option as an opt-in diagnostic mode.
- **§2 — Interaction with unhandled/unwatched rejection.** "A promise can always be handled later" (timing guess vs. fact); why this is sharp over CapTP (eventual-send / promise-pipelining handoff, obligation owned by the far side — using the library's established vocabulary from `@endo/eventual-send`); Node's escalate-on-unhandled-rejection as exactly the nobody-subscribed-yet heuristic, wrong on both the deferred and handed-off cases; defensible only absent a precise mechanism. **Recommendation:** Endo/Ironhorse should not adopt Node's behavior; prefer visibility-over-escalation for genuinely-abandoned rejections (report at a terminal boundary à la XS's `fxAddUnhandledRejection`/`fxCheckUnhandledRejections`, never abort on a timer).
- **Debugger note.** Reactive pending-promises (creation line/column attribution) and unwatched-rejections (live, retracting on handler-attach) panels.

**Cross-links.** `ironhorse-debugger-recovery-and-uncaught` (item 3: rejection tracking is separate from throw-time classification), `ironhorse-engine` (Halt vocabulary), `unhandled-rejection-display` (diagnostic rendering), plus the eventual-send/captp packages.

**Sibling cross-link status.** `design-ironhorse-panic` has **not** landed (no board job, branch, design file, or PR exists). I referenced it by name, marked it "not yet landed, expected at `designs/ironhorse-panic.md`", and left an explicit note (in the intro and Dependencies table) for whoever lands it to add the reverse cross-link — per the job's instruction for the not-yet-landed case.

**Follow-ons named in Open Questions** (rather than left implicit): a rejection-tracker design job, the debugger panels' data-plumbing build job, panic-scope narrowing (deferred to the panic design), and handoff-marking for the panel feed.

**Verification.** PR confirmed via `gh pr view`: `isDraft: true`, `state: OPEN`, base `llm`, one file added. No mermaid fences (nothing to validate); no latin-shorthand. Left the PR **draft** — its design-panel gauntlet is staged automatically by the completion machinery; I did not un-draft or hand-post a gauntlet. Inbox drained (empty).

**Note for operators:** `ensure-pr.sh` initially refused (open-PR marker query truncated at its 200 page limit); succeeded with `GARDEN_ENSURE_PR_LIST_LIMIT=600`. The fork now has >200 open kriscendobot PRs, so the default limit is under-sized for this repo.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-ironhorse-rejection-handling.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 41 tokens (1742247 cached reads)
- Output: 19088 tokens
- Cost: $2.2025635
- Wall-clock: 315s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
