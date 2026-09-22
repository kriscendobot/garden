from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion-town-pr87-production-gate-20260922
reply_to: kriscendobot-minion-town-pr87-production-gate-20260922
msg_key: msg-kriscendobot-minion-town-pr87-production-gate-20260922-0f3f6f53eb0c
notice_count: 1
first_seen: 2026-09-22T02:08:55Z
last_seen: 2026-09-22T02:09:08Z
sent_at: 2026-09-22T02:09:08Z
---
Production-reality gate for kriscendobot/minion.town#87 — decision needed before merge.

Review 5273131188 ("evaluate end to end in production … this code does not yet connect
to reality; close that gap before we commit") had two asks:

1. Inline "keep test fixtures under test" — RESOLVED on head 8a0bf2b (fixtures moved out
   of the production path; fail-closed defaults; typecheck+test green). Replied on-thread.

2. Top-level production-reality ask — I could NOT honestly close it, and it is blocked on
   your decision, not on effort:
   - kriscendobot/minion.town#87's inference provider is deliberately unavailable-by-design
     because the step-1 substrate endojs/endo-but-for-bots#1015 (@endo/claude confinement
     core, the real confined `claude -p`) is still unmerged.
   - The CLI-vs-SDK exploration did not yield a comparison: Track A (CLI,
     kriscendobot/minion.town#105) is a draft that round-trips a FAKE claude binary — no
     live subscription; Track B (Agent SDK) FAILED (handler-timeout, no deliverable).
   - Genuine production evidence needs the deployed minion.town exercising the real
     setup-token credential path, not the fleet's OAuth creds or a local prototype smoke
     test. I did not reinterpret the fake-binary round-trip as production evidence.

Decision I need from you: (a) which backend is the production provider (CLI / Agent SDK —
re-run the failed SDK track first for a real comparison?); (b) proceed before
endojs/endo-but-for-bots#1015 lands, or gate kriscendobot/minion.town#87 behind it;
(c) what counts as acceptable production evidence (deployed AWS host + real guest
subscription vs. an authorized live local run) and whether credentials are provided.

kriscendobot/minion.town#87 is held DRAFT/unmerged; the auto-posted conductor was told to
stand down; and I parked a durable successor `minion-town-pr87-production-gate-resume-20260922`
(awaiting-maintainer) that owns integrating the chosen backend + getting production
evidence + merging once you decide — promote it when you answer. Status also recorded at
https://github.com/kriscendobot/minion.town/pull/87#issuecomment-5770203120
