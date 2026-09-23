---
ts: 2026-06-12T15:24:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--6d2dcd
prs:
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/439
  - https://github.com/endojs/endo-but-for-bots/pull/439#pullrequestreview-4482857456
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/152200Z-result-researcher-d73da3.md
---

# dispatch: designer — consolidate formula view + drop @info hub on PR #439

User directive (kriskowal review `4482857456` on #439,
2026-06-12T05:53:28Z): consolidate the chat-value-modal-formula-
view design into the existing formula inspector design, and
remove the `@info` name hub in favor of a Host-agent-only
`getFormula(identifier)` method plus a new CLI/GUI verb.

The full `## Library and project references` section is at
`journal/entries/2026/06/12/152200Z-result-researcher-d73da3.md`
(researcher `d73da3`). **Read it verbatim** before starting.

## Headline findings (per researcher)

- **Two designs to consolidate**:
  `designs/chat-value-modal-formula-view.md` (this PR's
  in-modal card-flip) AND `designs/formula-inspector.md` (the
  existing 2026-02-14 Not-Started design proposing the
  separate panel + `endo inspect` CLI + edit toggle +
  retention-path reveal). Synthesize the best of both.
- **`@info` wiring is a 2-line delta** at
  `packages/daemon/src/host.js:209`. The host-vs-guest
  asymmetry at the special-name layer is *already* there;
  the redesign promotes it to a method-level split.
- **Precedent for host-only daemon methods**:
  `designs/daemon-retention-paths.md` § Daemon surface
  (host-only) — `listRetentionPaths` / `followRetentionPaths`
  only on `EndoHost`, with kriskowal's exact rationale
  ("guests must not enumerate... would reveal the host's
  internal naming, peer relationships, and which other
  guests share common roots"). Cite verbatim. Also
  `EndoHost.traces()` in the error-tracing design as a
  second precedent.
- **CLI verb names available**: 41 commands in
  `packages/cli/src/endo.js`; **none** of `inspect`,
  `examine`, `formula` are taken. `formula-inspector.md`
  already proposed `endo inspect <name>`.
- **Promise-formula view integrates with error-tracing**:
  `docs/error-tracing-design.md` § EndoHost `traces` facet.
  Rejected promise carries `errorId`; formula view fetches
  `E(host).traces().lookup(errorId)` on demand (matching the
  per-modal-session lazy-lookup discipline).
- **Cycle handling**: kriskowal ruled "do not unwind cycles"
  (principle of least surprise). Resolve PR #439 design's
  Open Question #5 in favor of no-unwinding; drop the
  alternative.
- **Stale citation to refresh**: `formula-inspector.md` and
  library section say `makePetStoreInspector` at
  `daemon.js:3210-3319`; actual at lines 5704-5829.
- **Three designer-level open questions**:
  1. Verb naming (`inspect` / `examine` / `formula`).
  2. `@info` compatibility window (single-release drop vs
     deprecation alias).
  3. Retire vs keep `InspectorHubInterface`.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#439`
  ("design(chat): Value modal Formula view (card-flip back
  face)"), DRAFT, base `llm`, head
  `design/chat-value-modal-formula-view` at
  `8cf914a62...`. Dispatch-prepare picked up
  `8cf914a62` directly.

## Inline asks (per `Fetch ALL inline comments tied to a
review` discipline; tied to review `4482857456`)

1. **`designs/chat-value-modal-formula-view.md:247`** (id
   `3400997331`): redesign away from `@info`, toward
   Host-agent-only `getFormula(identifier)` method, + new
   CLI/GUI verb.
2. **Line 297** (id `3400999456`): consolidate plan with
   existing plan. Synthesize the best of both.
3. **Line 300** (id `3401000880`, positive): "Stack model
   sounds good to me." → preserve.
4. **Line 302** (id `3401001866`, statement): "This will be
   new." → note.
5. **Line 306** (id `3401007599`): promise-formula view
   subscribes to promise + button-to-view-next-value or
   rejection reason; integrated with error tracing.
6. **Line 309** (id `3401012722`): "Do not unwind cycles."
   Principle of least surprise.
7. **Line 312** (id `3401018617`, positive): "Let's
   implement this." → preserve target.

## Task — consolidation + @info-drop redesign

In your `project/` worktree on
`design/chat-value-modal-formula-view` at `8cf914a62`:

1. **Read** both design docs in full
   (`chat-value-modal-formula-view.md` and
   `formula-inspector.md`) + the researcher's full
   references section.
2. **Read the precedent docs**:
   `designs/daemon-retention-paths.md` § Daemon surface
   (host-only); `docs/error-tracing-design.md` § EndoHost
   `traces` facet (or wherever it lives).
3. **Synthesize**: produce a single consolidated design
   document. Suggested approach:
   - **Keep** `designs/formula-inspector.md` as the primary
     home (existing prior-art shape). Rename if needed.
   - **Fold in** the card-flip-back-face content from
     `chat-value-modal-formula-view.md` as a primary UI
     surface alongside the separate inspector panel.
   - **Delete** `designs/chat-value-modal-formula-view.md`
     (its content lives in the consolidated doc).
4. **Replace `@info` with Host-agent `getFormula(identifier)`**:
   - Document the method's signature, return shape, host-only
     restriction (cite `daemon-retention-paths.md`'s rationale
     verbatim).
   - Document the implementation sketch (where in
     `daemon.js` it lives; how it routes through the
     existing `makePetStoreInspector`).
   - Decide and document the `@info` compatibility window
     (designer's call: single-release drop vs deprecation
     alias).
5. **Add a CLI verb section**: pick `inspect` (researcher
   notes the existing design already proposed it; consistent
   if no objection). Sketch the command's signature, output
   format, and how it routes to `getFormula`.
6. **Add a promise-formula view section** integrating with
   error tracing per inline ask #5.
7. **Apply the "no cycle unwinding" principle** explicitly
   in the consolidated design's Open Questions section (or
   wherever cycle handling is mentioned).
8. **Refresh stale citations**: the `makePetStoreInspector`
   line-number reference (5704-5829, not 3210-3319).
9. **Commit** the consolidated design + the deletion of the
   old design + any related citation refreshes. Recommend
   one commit per logical step (consolidation; @info-drop +
   getFormula; CLI verb; promise view; cycle principle).
10. **Push** to `design/chat-value-modal-formula-view`
    (append push; no force).
11. **Reply on each substantive inline thread** (1, 2, 5,
    6) citing the addressing commit SHAs. Brief positive
    acks on 3 and 7 (where kriskowal already said "sounds
    good" / "let's implement this").
12. **Post a top-level summary comment** on PR #439
    at-mentioning `@kriskowal` summarizing the
    consolidation + the 3 designer-level decisions on the
    open questions.
13. **Re-request review** from kriskowal.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to
  `design/chat-value-modal-formula-view` (append push only).
- **Reply on inline threads**. Standing.
- **Top-level summary comment** on PR #439.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT implement the redesign (this is a design-doc PR;
  implementation comes later in a separate PR).
- Do NOT touch source under `packages/`.
- Do NOT rebase or force-push.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` naming:

- Pre/post branch tip SHAs.
- The consolidation outcome (which doc became the home;
  what was merged where; what was deleted).
- The 3 open-question decisions + rationale.
- The CLI verb choice + sketch.
- The promise-formula + error-tracing integration sketch.
- Citation refreshes done.
- The 7 inline-thread reply URLs.
- The top-level summary comment URL.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
