**Design landed, but the root cause of the #128 gap isn't proven.** The evidence that would settle it is on endolin, and the job collecting it hadn't been claimed when I finished. The design is `designs/issue-inbox-timely-acknowledgement.md` (`746d220507c`, pushed bare to `main2`, no open questions).

## Root cause of the #128 gap
- **Ruled out:**
  - Poll cadence: the timer is 120s, and 29 of the last 30 issues got `eyes` within 390s.
  - Trust gate: dckc was already acked on #126 and the allowlist didn't change.
  - Leader change: endolin was leader throughout.
- **What happened:** one tick did all the work at 04:31:57–04:32:13Z (`eyes`, job post, cursor). Nothing failed partway and retried.
- **Two separate waits:** intake took 55 minutes, then the claim took another 62 (04:32 to 05:34). Fixing intake alone would still leave about an hour's wait for a reply.
- **Why the latency watch didn't catch it:** it recorded no `comment-ack-*` notice from 01:51Z through at least 06:15Z. It only observes and alerts the maintainer, so it could never have repaired #128 or told dckc anything.
- **Leading hypothesis (unproven):** a REST cooldown latch held on endolin, because that would silence both the issue watcher and the latency watch while still exiting 0. The cursor-lock skip and journal-outage latch are still possible.

## Chosen rule
- **`eyes`:** stays the instant ack; lateness gets fixed as a liveness defect.
- **Status comment:** at most one per arrival, and only if no bot comment has followed it.
  - **Timeout:** 20 minutes.
  - **Deep queue:** 5 minutes if the job is in `todo` with 6 or more unpinned jobs ahead.
  - **After a claim:** hold for 5 minutes, but no later than 25 minutes after arrival.
- **Rejected:** numeric ETAs, free-gardener counts, and skipping the ack on a short queue.
- **Evidence:**

| Sample | Result |
|---|---|
| Last 30 issues | 21 got a first reply within 20 minutes (slowest 961s), so none of those would have got a status comment |
| Queue depth 0–2 (reconstructed from commits, approximate) | 22% of jobs waited over 20 minutes |
| Queue depth 6+ | 41 of 54 jobs waited over 20 minutes |

- **Where it runs:** a new leader-only `issue-status-pass.sh`, with fixed text and no LLM. The trust gate runs before any body is read, and a hidden marker in the comment prevents double posting.
- **Limit:** if a REST latch was the cause, the status comment could only have posted when it lifted, around 04:32Z, not 03:58Z.
- **Sibling watchers:** the lateness fixes cover all three sources, but the status comment is issue-inbox only. The PR watcher already replies in the same tick as `eyes`, and automated comments from the @-mention watcher could land on third-party repos.

## Latency-watch defects found in the code
- The checker exits on a REST cooldown before classifying heartbeats, so a continuously held latch can never raise its stuck notice.
- Its issue-inbox check is looser than the watcher's exact first-line rule, so it reports correct drops as blind. The open notice on a #117 comment looks like this. The endo-but-for-bots blind notice (179 occurrences) may be the same, and the build checks it.
- Heartbeats don't name which gate caused a skip, which is partly why this couldn't be diagnosed from the journal.

## Jobs posted
- **`build-issue-inbox-timely-acknowledgement`:** in `todo`; builds the checker fixes and the status pass, shipping in dry-run. It tells the builder to post a parked follow-up to remove the flag.
- **`diag-issue-inbox-gap-20261104-endolin`:** a read-only log pull pinned to endolin, unclaimed since 05:50Z. Its results are rerouted to the build job, which adds a targeted fix if they name a cause the design doesn't cover.

## Comment on #128
I didn't comment, since the job only asked for one if there was a useful root-cause finding and this one is unproven. A gardener has also been replying on the issue since 05:36Z.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-issue-inbox-timely-acknowledgement-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (2678869 cached reads)
- Output: 43364 tokens
- Cost: $2.6665737999999997
- Wall-clock: 2314s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
