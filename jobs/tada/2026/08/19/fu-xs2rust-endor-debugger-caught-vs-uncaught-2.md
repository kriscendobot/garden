Done. The job asked to "fix **or** gate" the silent no-op; the native fix is blocked and design-forbidden as an interim, so I delivered the gate.

## Completion report

**Job:** endojs/endo-but-for-bots PR #600 follow-up — fix or gate `setExceptionBreakMode('uncaught')`, a live silent no-op.

**What I found (re-verified against current `llm` head):**
- This is follow-up #2 of four derived from `designs/ironhorse-debugger-recovery-and-uncaught.md` (research issue #940): fu-1 *recover the debugger row* (blocks all), fu-2 = this job, fu-3 *engine-raise unwind*, fu-4 *BreakpointTable parity nits*.
- The **native fix is blocked**: the `ironhorse-debug` crate is not yet on `llm` (fu-1 unbuilt), and it also needs fu-3; the Ironhorse campaign is paused for budget (2026-08-16). Native break-on-uncaught is Phase 5 of the design.
- The design **explicitly forbids** an interim C-XS fallback/capability-negotiation/alias and wants the shipped client wire commands byte-identical so the mode goes live automatically once Ironhorse implements `uncaughtExceptions`. A runtime gate would violate that or break the forward-compat pinned by `debugger-captp.test.js:352`.
- The concrete defect: on C-XS, `'uncaught'` sends `clear exceptions` + `set uncaughtExceptions`; the unrecognized pseudo-path is a phantom never-hit breakpoint, so the mode **silently disables** exception breaking.

**What I did (the gate — zero wire/behavior change):** removed only the *silent* property, documenting the caveat at every client API site (`packages/daemon/src/debug-session.js`, `debugger.js`, `types.d.ts` DebugSession/Debugger interfaces) and relabeling the Chat debugger-panel option to "Exceptions: uncaught (engine support pending)" with an honest tooltip (`packages/spaces-util/src/debugger-panel.js`).

**Verification:** 16 daemon `debugger-captp` tests + chat `debugger-panel` component tests pass unmodified; `eslint` 0 errors and `prettier --check` clean on all four changed files.

**Output:** draft PR **endojs/endo-but-for-bots#1038** vs `llm` (job-marker recorded). Messaged the maintainer with the blocked-native-fix rationale and an offer to pursue a hard runtime gate via a design amendment if preferred.

**Follow-ups (unchanged, owned elsewhere):** the real fix stays with fu-...-1 (recover the debugger row) + fu-...-3 (engine-raise unwind), both still `todo` under the paused campaign.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-xs2rust-endor-debugger-caught-vs-uncaught-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4323490 cached reads)
- Output: 36217 tokens
- Cost: $4.075802999999999
- Wall-clock: 598s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
