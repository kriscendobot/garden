Both parts of the directive are complete. Writing the completion report.

## Completion report — attention directive on endojs/endo-but-for-bots PR #719

**Directive (from kriskowal, cid 4977170310):** "post a Fable security audit of this change and submit their feedback to a gauntlet fixer loop."

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved this. Container guard clean; inbox empty throughout.

**What I did**

1. **Fable security audit.** Pulled the full PR diff (9 files, +638) and the new `tame-url-constructor.js`, then dispatched a **Claude Fable 5** subagent with a SES/ocap-taming security lens. It traced every reachability path the shim could open — `URL.prototype.constructor` re-point, `construct(OriginalURL, rest, new.target)` delegation, `URL.parse()` return values, the `searchParams` getter, `@@species`, the hidden `URLSearchParams` iterator prototype — plus descriptor correctness, the missing/partial-host (XS) degradation path, and the pre-`harden` writability window.
   - **Verdict: sound.** No critical/high/medium security defects. The one non-obvious hole (the invisible `URLSearchParams` iterator prototype that `harden`'s transitive walk cannot reach) is correctly closed by the PR's explicit sampling in `get-anonymous-intrinsics.js`. Three *informational* notes only (host-conformance assumptions).
   - Posted the full audit verbatim as a PR comment: https://github.com/endojs/endo-but-for-bots/pull/719#issuecomment-4977234962

2. **Submitted the feedback to the gauntlet fixer loop.** The audit surfaced **zero must-fix and zero should-fix** security items, so the fixer loop terminated as a **clean pass — no follow-up commits**. The only actionable informational note (I-1: an optional sample-time assertion that all four `URLSearchParams` iteration methods share one prototype) was explicitly marked "None required" by the auditor; per fixer discipline I did not implement an informational note as if it were a must-fix driver (and this PR is a design alternative to #263 that may not land). I surfaced it in the comment so the maintainer can green-light it with a `fix #719 with I-1`.

**What changed:** one PR comment on endojs/endo-but-for-bots#719. No code changes — audit-only job; no garden-library (main2) changes, so nothing to commit or push. Project worktree left clean.

**Follow-ups (maintainer's call):**
- Optional hardening **I-1** — add a fail-closed `getPrototypeOf(usp.keys()) === getPrototypeOf(usp.entries())` assertion at sample time. Reply `fix #719 with I-1` to route it to a fixer.
- The PR remains a direction-choice between #719 (Date-style split, blob methods retained on start compartment) and #263 (universal removal). The audit clears #719 on security grounds but does not decide the direction.
