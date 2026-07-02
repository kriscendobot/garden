Posted the threaded reply: https://github.com/endojs/endo-but-for-bots/pull/58#discussion_r3513880029

The work is complete. No code changes were warranted (the review's sole ask was a request for context on a merged PR, and the "we need an alternative" directive is already carried by follow-up design #595).

---

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #58 (review by @erights).

**What I found**
- The trailing number in the discussion URL (`3510700815`) is a *comment* id, not the review id. Resolved the real `REVIEW_ID` to **4614774597** by fetching the comment (`pull_request_review_id`).
- That review has an **empty body** and exactly **one inline comment**: `packages/daemon/src/unredacted-stack.js:53` — @erights: *"Why? I need more context."* It replies to kriskowal's earlier comment *"@erights This should not be. We need an alternative."*
- Preflight (`pr-feedback-preflight.sh`) returned **exit 0 / PROCEED** (no peer resolution).
- Context: PR #58 is **merged** (onto `llm`, 2026-07-01). The flagged file taps two undocumented SES start-compartment hooks (`globalThis.getStackString` and the `MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA` symbol — the same surface `@endo/ses-ava` uses). Crucially, the "we need an alternative" directive is **already addressed** by the bot's follow-up design **PR #595** (`designs/captp-error-identification.md`), whose section "An alternative to `unredacted-stack.js`" proposes the fix and **explicitly tags @erights** for input.

**What I did**
- Treated all fetched bodies as untrusted data (no injection present; content was a one-line question plus technical prose).
- Since the single ask is a request for context on the bot's own merged PR — and endojs/endo-but-for-bots carries standing comment authorization — I posted an **inline threaded reply** under the thread ([r3513880029](https://github.com/endojs/endo-but-for-bots/pull/58#discussion_r3513880029)) that: (1) gives the factual technical context erights asked for (what the tap is, why the coupling is fragile), (2) routes erights to design #595 where the alternative and fuller rationale live and where erights is specifically asked for input, and (3) leaves the normative "should not be" call to the maintainers rather than speaking for kriskowal.

**Changed:** No code. No push (PR is merged; the ask was a context question, and the alternative is tracked in #595). One GitHub inline reply posted.

**Follow-ups**
- Design **#595** (DRAFT) is the live home for the alternative and awaits @erights' input on whether the sanctioned-SES-API path is the intended shape (or whether unredacted capture should never leave the worker). No new job needed — #595 already exists and tags erights.

**Verification:** The reply POST returned id `3513880029`, threaded `in_reply_to` the correct thread root, with URL confirmed. I did not (and could not) verify the maintainers' acceptance of the answer — that is theirs to give on the thread / in #595.

Self-improvement: nothing this time.
