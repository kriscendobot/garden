---
requires: host=endolin-garden-ece02cb4
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Post the follow-up plan reply on endojs/endo-but-for-bots PR #1018

Parent job `endojs-endo-but-for-bots-pr1018-e1ff4501` ran on host oros-studio-garden-ce242c49, where the bot PAT gets a 403 on endojs PR comments. Your only task is to post the comment below verbatim as an issue comment on https://github.com/endojs/endo-but-for-bots/pull/1018 (`gh pr comment 1018 -R endojs/endo-but-for-bots --body-file <file>`). First check that no comment carrying `<!-- garden-reply:5884163049 -->` and the text "Every deferred branch" already exists; if one does, do nothing.

----- COMMENT BODY -----
@kriskowal Every deferred branch of `designs/ironhorse-panic.md` is now planned on the board. The legs run in order, and each build opens a draft PR with `Refs: #1018` that goes through its own gauntlet.

**Open design questions (mentat, manual dispatch):** `endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat` answers the eight Open Questions from a survey of the live code: Decode/StepLimit membership, MeterAbort pause vs panic, the first transcript backend, the `-e ironhorse` dependency note, uncaught-throw disposition, SQLite I/O-failure disposition, the single-vat fsync bound, and the Halt shape fold. It also reconciles this design with #989 (quiescence embargo) and #1016 (reference-error panic). It lands the answers as a design-amendment PR and replies here.

**Serial orchestration `endojs-endo-but-for-bots-pr1018-followups-20260929`:**
1. `…-e2e-probe`: a gap-revealing end-to-end probe (stays draft). It drives panic → Panicked → embargo discard → terminate → restore → replay → debugger stop, and maps each gap to its leg.
2. `…-classification-lint`: a CI-enforced lint against raw `Halt` matches outside `is_panic()`/`ExecutionOutcome`.
3. `…-cxs-panicked-adapter`: live C-XS `fxAbort` exits plus the #1150 `XsnapError::Panicked` become one supervisor-visible `Panicked`, and the delivery path consumes `ExecutionOutcome`.
4. `…-debugger-panic-break`: a `<panic>` wire message and stop-the-world at the panic site.
5. `…-transcript`: the Slot Machine per-worker SQLite WAL transcript, with a crash-injection matrix.
6. `…-outbound-embargo`: commit-gated release and duplicate suppression.
7. `…-host-call-transcript`: host calls as transcript events, logical handles, barriers, and broken-handle re-seating.
8. `…-retry-replay`: terminate, restore, and replay up to the panicking delivery (replay == live).
9. `…-coda-reference-error`: the panic-on-reference-error option, pinned in the snapshot record.
10. `…-halt-shape-unification`: fold `StackOverflow`/`MeterAbort` into `PanicKind`.

(`…` = `endojs-endo-but-for-bots-ironhorse-panic`.) Legs 5–10 read the mentat's answers before building.

<!-- garden-reply:5884163049 -->
----- END COMMENT BODY -----
