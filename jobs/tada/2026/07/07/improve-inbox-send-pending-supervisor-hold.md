Done. Inbox is empty.

## Completion report

**Job:** `improve-inbox-send-pending-supervisor-hold` — make `scripts/jobs/inbox-send.sh` stage messages to a parked-but-unclaimed doer instead of dead-lettering them.

**What I did:** Confined a change to the "inbox dir absent" branch of `inbox-send.sh`. Before falling through to dead-lettering, it now checks whether the recipient is a parked/queued job — `jobs/plan/<doer>.md` or `jobs/todo/<doer>.md` (using `JOBS_PLAN`/`JOBS_TODO` from `common.sh`). If so, it pre-creates `inbox/<doer>/unread/` and deposits the message there using the same idempotent path/CAS/`GARDEN_MSG_ID`-skip logic as the live-delivery branch (checks both `unread/` and `read/` for the msgid, `mkdir -p`, `commit_and_push` with a rebase/backoff retry loop). Only a doer present in **no** board category falls through to the existing dead-letter path, preserving today's completed-doer-race behavior.

**Why it works:** `claim-job.sh` creates the inbox with a non-clobbering `mkdir -p` + `touch .gitkeep`, so a staged `unread/` message survives the claim and the supervisor drains it as a normal unread report at claim time — eliminating the five-dead-lettered-child-reports failure seen in xs2rust-endor fix round 1 and moving the hand-carried "no-inbox-send-to-parked-supervisor" discipline off the sending agent and into the delivery primitive.

**Changed:** `scripts/jobs/inbox-send.sh` — the parked-recipient branch plus an updated header comment documenting parked-staging vs. dead-mail fallback. `bash -n` clean; only benign SC1091 from shellcheck. The read side (claim-job.sh) needed no edit, as specified.

**Committed & pushed:** `846315d87` to `main2`.

**Follow-ups:** none.
