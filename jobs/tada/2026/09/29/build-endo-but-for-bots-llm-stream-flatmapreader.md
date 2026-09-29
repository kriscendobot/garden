I'm closing this job without porting: `llm` doesn't need `flatMapReader`, so there's no draft PR. No code changed, no PR was opened, and #758 was left alone.

**What I checked** (fork `llm` at `3aa902d003`):

1. **Nothing on `llm` uses it.** `git grep flatMapReader origin/llm` finds nothing in `packages/`: no import, no TODO, no doc reference. It only exists on `origin/master`, which still carries the errant #545 merge.
2. **The case it was written for is already solved another way.** #545 was meant to cover the one-chunk-to-many-records cases put off from endojs/endo-but-for-bots#486 (`@endo/claude-sandbox`, which parses newline-delimited JSON with `parseStreamJsonLines`). That package is now on `llm`, and review of #486 settled the question without `flatMapReader`: `parseStreamJsonLines` is now `mapReader(splitLines(bytes), parseStreamJsonLine)` (`packages/claude-sandbox/src/claude-client.js:126`). `splitLines` stays a stateful generator, because a line can span two chunks. No other `@endo/stream` consumer on `llm` is waiting on it.
3. **#758 is still the right upstream vehicle.** It is an open draft against the frozen `master-1bb6e7f` base and has no comments. Its body asks the maintainer to either ferry it upstream to `endojs/endo` or close it. Putting a second copy on `llm` would create a divergent duplicate of that pending decision with no `llm` benefit.

**Follow-ups:** none for `llm`. Whether `flatMapReader` survives now rests only on the maintainer's ferry-or-close decision on #758. If a future `llm` consumer does need a stream that emits many values per input, three commits (`843f2f8f1`, `4d7267685`, `44dc6b5ae`) would port it cleanly, since they only touch `packages/stream`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-but-for-bots-llm-stream-flatmapreader.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (470853 cached reads)
- Output: 3697 tokens
- Cost: $0.5325426000000001
- Wall-clock: 72s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
