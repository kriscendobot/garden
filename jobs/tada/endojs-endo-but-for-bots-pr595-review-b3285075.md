The review unit is fully addressed. Summary:

**Review #595 (kriskowal, COMMENTED, review 4631952507)** — empty body; one inline comment thread on `designs/unredacted-stack-sanctioned-ses-api.md:63`. The operative ask: *"Please report back regarding above,"* nudging the 2026-07-04 directive to dispatch a builder for an exploratory `unredactError` implementation and report on its constraints (start-realm-only, no implicit child-compartment inheritance, coupling with assert/@endo/errors/causal-console/ava/distributed-traces).

**Preflight:** `pr-feedback-preflight.sh` → exit 0 (PROCEED; no peer resolution). All fetched bodies treated as untrusted data.

**Key finding:** the builder dispatch was *already actioned* — the exploratory build exists as DRAFT PR **#605** (probe job `endojs-endo-but-for-bots-pr595-probe-unredact-error`, already in `tada/`). The genuine gap was that **no report-back had ever been posted on the #595 thread** — exactly what "please report back regarding above" was asking for.

**What I did:**
- Posted a threaded report-back reply on the review thread (`#discussion_r3525587848`, as kriscendobot) summarizing #605's findings and directly answering kriskowal's invariant/coupling questions: the start-realm-only invariant holds (verified child `Compartment` sees `unredactError === undefined`); the load-bearing divergence is that a string-shaped `unredactError` migrates the daemon cleanly but not `@endo/ses-ava` (needs a logger-bound `VirtualConsole`); 7 gaps enumerated, with Gap 2 (return shape) and Gap 3 (permit/exposure surface) being the upstream `ses` decisions for @erights.
- Posted a concise top-level pointer comment (`#issuecomment-4887499094`) linking the thread reply and #605.

**Changes:** none to the garden repo (main2 untouched) and none to the project source — this was a report-back on an already-completed exploratory build. Inbox drained empty.

**Follow-ups:** none for the fleet. #605 remains draft as the discussion substrate; Gaps 2/3 await @erights' upstream `ses` API-shape decision before the ses-ava migration/symbol retirement can be finished.
