I didn't open a new PR: the review this job asks for is already carried out in draft PR https://github.com/endojs/endo-but-for-bots/pull/1487. A second PR would have duplicated it.

**What #1487 already covers**
- **Where it stands:** it is on head `build/ocapn-noise-cryptographic-review`, based on the frozen `llm-a794753`, and still a draft.
- **R1 (key confirmation):** a new test shows that a key-compromise-impersonation SYN never graduates, and the README now states the key-confirmation rules.
- **R4/R5 (wire contract, no 0-RTT):** the README now has a normative `np/1` wire-contract section, which includes the no-0-RTT rule.
- **R3 (Rekey-only reconnect):** `designs/ocapn-noise-session-reconnect.md` § 4 is amended to reconnect by Rekey only.
- **Checks and review:** CI is green. The code panel ran three rounds and passed on round 3. Its final status is held-draft at head `58443878ae`: the review passed, but the PR stays draft because one recommendation (R2) is owned by a later job.
- **R2 (per-connection `sessionId`):** not built here. Job `endo-but-for-bots-ocapn-noise-session-id-r2-build` owns it and is on the board, waiting on open question Q2 in #1475.

**Why the job still says "Not Started"**
The design file on `llm` hasn't been updated because the design PR that rewrites it (https://github.com/endojs/endo-but-for-bots/pull/1475) is still open. That is probably what caused this duplicate job to be posted.

**Follow-ups (maintainer)**
- **@kriskowal needs to confirm C1.** The R3 change reverses his tentative "resume plus rekey-cap" decision from #252. He can confirm on #1487 or #1475.
- **Merge #1475 before #1487.**
- **No new gauntlet run is needed.** #1487's body has no `garden-job: build-ocapn-noise-cryptographic-review` marker, so `ensure-pr.sh` would not have found it and would have opened a duplicate.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-noise-cryptographic-review.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (270312 cached reads)
- Output: 2358 tokens
- Cost: $0.4761024
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
