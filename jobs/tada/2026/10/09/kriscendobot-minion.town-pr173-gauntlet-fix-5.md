I applied the round-5 panel's must-fix items to the design, pushed them to PR #173, and CI came back green (3 of 3 checks passed).

**What changed:** one review-feedback commit, `4cca051`, on `design/ocap-site-crawler-leak-rotation`, editing only `designs/ocap-site-crawler-leak-rotation.md`. It went up with `safe-push-pr-head.sh` as a fast-forward from `2d0f286`. The committed scope is now units 1–3, which only alert:
- **Rotation left out of the committed sections:**
  - The opening summary, § 1 and § 2 no longer present rotation as shipping. The § 2 rotate tier is marked deferred.
  - § 4.2 and § 4.3 are now short deferred stubs.
  - § 7 no longer claims the rotation saga.
- **Committed types:**
  - `LeakState` is `"quiet" | "observed" | "alerted" | "public"`.
  - `Status` is `{ label, state, lastSignal? }`.
  - The rotation fields and `rotate()` are marked deferred.
- **Per-method error table:** `GONE` is the only error code in units 1–3. Every method returns it on an unpublished site, including `pinPublic`. `acknowledge` outside `alerted` returns without error and changes nothing. `pinPublic` and `unpinPublic` are idempotent.
- **Gate 5 vendor coverage:** a new § 2.1 names the vendors in the range snapshot: Google, Bing, DuckDuckGo and Apple. Baidu and Yandex are listed as not covered.
  - A daily warden timer refreshes the snapshot. Data older than 7 days counts as stale and never as verified.
  - The gate 5 report lists vendor coverage. If coverage is narrow or stale, the gate reads "inconclusive", not zero.
- **Spool removed:** the spool, the new writable `StateDirectory` and the group shared with `minion-mcp` are gone. The gateway now writes one structured event line to journald, and the warden reads it from there. The precondition now checks only that `GATEWAY_ENDO_SOCK` is armed and that event lines reach journald.

**Not checked:** a subagent made the edits. I grepped for leftover spool and `StateDirectory` references and found only the new prose saying they were removed, but I did not re-read the whole document. The follow-up file (`designs/ocap-site-link-rotation-followup.md`) is unchanged.

**Still open:** the should-fix and comment-only findings were not addressed. That includes the critic's points on rejected alternatives and on citing a commit in the follow-up file's status line. The panel's next round (panel-6) is where to catch any of these.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 26 tokens (806069 cached reads)
- Output: 5074 tokens
- Cost: $2.4408914000000004
- Wall-clock: 885s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
