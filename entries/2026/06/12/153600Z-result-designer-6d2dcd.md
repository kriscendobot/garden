---
ts: 2026-06-12T15:36:00Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/designer--6d2dcd
prs:
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: target
refs:
  - entries/2026/06/12/152400Z-dispatch-designer-6d2dcd.md
  - entries/2026/06/12/152200Z-result-researcher-d73da3.md
  - https://github.com/endojs/endo-but-for-bots/pull/439
  - https://github.com/endojs/endo-but-for-bots/pull/439#issuecomment-4692731066
---

# result: designer — consolidated formula view + dropped @info on #439

## Summary

Applied kriskowal review `4482857456` on PR #439. Rewrote `designs/formula-inspector.md` as the consolidated design (synthesizing the best of both prior drafts), deleted `designs/chat-value-modal-formula-view.md`, updated `designs/README.md` (table row, mermaid graph, M9 row, total count), commit `eccd7e503` pushed to `design/chat-value-modal-formula-view`. Posted 7 inline replies (4 substantive, 3 positive) and one top-level summary at-mentioning kriskowal. Re-requested review.

## Substantive changes to the design

1. **Drop `@info`, replace with host-only daemon method.** New `EndoHost.getFormula(identifier)` method on `HostInterface` (not on `GuestInterface`). The "Why host-only" rationale cites the precedent in `daemon-retention-paths.md` § Daemon surface (host-only) and the `EndoHost.traces()` facet in `docs/error-tracing-design.md`. `@info` is removed from `host.js` line 209's `specialNames` map; the three `@info` regression tests in `endo.test.js` lines 2377-2510 are rewritten to call `getFormula` directly; no deprecation alias. `InspectorHubInterface` is retired; `makePetStoreInspector`'s inner per-type metadata function survives as the implementation of `getFormula`.

2. **Consolidation into single design.** `formula-inspector.md` carries a § Consolidation Note explaining the merge. Two Chat surfaces (Value modal back face + dedicated wrench/gear panel) share one `packages/chat/formula-view-registry.js` per-type layout source of truth. The modal back face is the everyday-inspection moment (one flip, no context switch); the dedicated panel is the power-tool moment (read/edit toggle, retention-paths embed via `daemon-retention-paths.md`). The 33-formula-type taxonomy table, the stack navigation model, and the property-name reference-button discipline all moved into the consolidated doc.

3. **CLI verb: `endo inspect`.** Picked from the maintainer's three candidates (`inspect` / `examine` / `formula`) for parallelism with the existing `formula-inspector.md` proposal, with the *Pop the bonnet* metaphor, and with the single-word noun-style-verb shape of `endo paths` and `endo locate`. None of the three is taken in the existing 41-verb CLI landscape; choice unconstrained by collision.

4. **Promise-formula view + error-tracing integration.** New § Promise-formula view splits the `promise` formula's back face by status: pending shows a "View next value" button subscribing via the `store` reference; fulfilled shows a "value" reference button; rejected shows the rejection reason as a literal plus a "View trace" button that fetches `E(host).traces().lookup(errorId)` on demand and renders the `TraceReport` (causal `causes` chain plus `related` window) per `docs/error-tracing-design.md` § EndoHost `traces` facet. Trace fetch is on demand (not eager), matching the per-modal-session cache discipline.

5. **No cycle unwinding (principle of least surprise).** New § Cycle handling section locks the navigation model: `A → B → A` is recorded as `[A, B, A]`; Backspace pops one frame at a time. The earlier draft's Open Question 5 (de-duplicate versus leave-as-is) is resolved in favor of leave-as-is and removed. The Options Considered table carries the maintainer's quoted ruling.

## Inline-comment replies (7 total)

| Comment ID | Line | Topic | Reply ID | Disposition |
|---|---|---|---|---|
| 3400997331 | 247 | Drop `@info` → host method | 3404477009 | substantive |
| 3400999456 | 297 | Consolidate plan | 3404478462 | substantive |
| 3401000880 | 300 | Stack model | 3404479295 | positive ack |
| 3401001866 | 302 | Card-flip novelty | 3404479629 | positive ack |
| 3401007599 | 306 | Promise view + error tracing | 3404480258 | substantive |
| 3401012722 | 309 | No cycle unwinding | 3404480682 | substantive |
| 3401018617 | 312 | Enter-Profile Shift+P | 3404481012 | positive ack |

Top-level summary at-mentioning kriskowal: `https://github.com/endojs/endo-but-for-bots/pull/439#issuecomment-4692731066`.

Re-review requested via `POST /repos/endojs/endo-but-for-bots/pulls/439/requested_reviewers`; `kriskowal` now appears in `requested_reviewers`.

## Changes to designs/README.md

- Row for `chat-value-modal-formula-view` dropped from the summary table.
- Row for `formula-inspector`: Updated date refreshed to 2026-06-12; size estimate bumped from M / 4-5 days to M-L / 6-8 days to reflect the larger consolidated scope; description refreshed to name the two surfaces, the host-only `getFormula` method, the `endo inspect` CLI, the promise-formula view, and the retention-paths embed.
- Mermaid dependency graph: `cvmfv` node removed; the `invgt → cvmfv` edge replaced with `invgt → finsp`; the dotted `finsp -.-> cvmfv` line removed.
- Project status summary rows: `formula-inspector` row refreshed; `chat-value-modal-formula-view` row removed.
- M9 row: count drops from 13 to 12 designs (drop `chat-value-modal-formula-view` from the enumeration).
- Total remaining: 56 → 55.

## Style discipline applied

- Em-dashes converted to colons in the per-type taxonomy table and the Affected Packages list.
- Latin shorthand (`etc.`, `e.g.`) replaced with English equivalents.
- Bare `vs` replaced with `versus`; the hyphenated compound modifiers `host-vs-guest` and `Literal-vs-reference` are standard English compounds and left intact.

## Verification

- `git status` clean on project worktree post-push.
- Push to `endojs/endo-but-for-bots:design/chat-value-modal-formula-view` succeeded (commit `eccd7e503`); fast-forward from `8cf914a62`.
- All 7 inline replies posted with non-empty bodies; all show `in_reply_to_id` pointing at the original maintainer comment IDs.
- Top-level summary posted as `issuecomment-4692731066` with `@kriskowal` at-mention at the head.
- `requested_reviewers` API call returned 200 with `kriskowal` in the response array.

## Open items for the orchestrator

None. The PR remains DRAFT (designer does not un-draft; un-drafting after maintainer re-review is the maintainer's call or a downstream solicitor / appellate flow).

Self-improvement: nothing this time.
