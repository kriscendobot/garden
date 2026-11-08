**Completion report: improve-correlate-unit-failure-tails**

When the mentor's journalctl scan finds a failed garden unit, the digest now includes a short log tail from that unit. Before, the digest showed only systemd's failure lines, so it could list five exit-code failures without the reason for any of them. The new test and the three existing mentor tests pass, and the change is pushed to `main2` as `49e7e418ff1`.

**What changed in `scripts/jobs/mentor.sh`** (new step 2b, called right after the journalctl section is written to the digest):
- **Which units:** it reads the unit names from systemd's own failure lines ("Failed with result …" and "Main process exited, code=exited|killed|dumped") for `garden-*` service, timer, socket and path units. Each unit is listed once, in the order it first appeared.
- **What gets added:** one `journalctl --user -u <unit> --since $since --until $tick_start -n N` tail per unit. It covers the same time window as the scan and is not filtered by priority, so the program's own messages are included.
- **Limits:** at most 5 units, 40 lines each and 8192 bytes each. These can be changed with `GARDEN_MENTOR_FAILURE_TAIL_UNITS`, `_LINES` and `_BYTES`.
  - When the byte limit is hit, it keeps the newest lines, drops the line the cut split, and adds an "older lines elided" note.
  - Units past the count limit are named in a truncation line.
  - A tail with no lines in the window is labelled as such.
- **Labels:** each tail gets a heading of the form `===== failed-unit tail i/N: <unit> (last L lines, <=B bytes, since S) =====`.
- **No extra noise:** if the scan has no failure lines, nothing is added, so routine digests are unchanged. Each tail read has a 15-second timeout.

**New test: `scripts/jobs/test/mentor-failure-tail-test.sh`.** It uses a stand-in `journalctl` and checks:
- one tail per unit, listed once and in first-seen order;
- the tail is not priority-filtered;
- the line limit keeps the end of the window;
- an empty tail gets its label;
- the unit limit adds the truncation line;
- the byte limit keeps only whole lines;
- warnings with no failure line add no tails.

**Follow-ups:** none required. Hosts only get this once they deploy the new `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-correlate-unit-failure-tails.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (612845 cached reads)
- Output: 8590 tokens
- Cost: $0.785705
- Wall-clock: 120s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
