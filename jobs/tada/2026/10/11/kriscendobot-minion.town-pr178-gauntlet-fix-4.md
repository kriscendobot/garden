Fix round 4 for kriscendobot/minion.town#178 is pushed and CI is green.

**Panel-4 must-fix items and how I handled them**

1. **Simultaneous pushes could over-grant (corner-prober), and the reservation ledger was extra machinery (decomplector #1).** I fixed both by running pushes to one partition one at a time, as decomplector suggested. In `git-http.ts`:
   - I removed the `reservedBytes`/`reserve`/`release` ledger.
   - A new per-partition queue (`holdPushSlot`) holds each push from the size walk until the CGI exits.
   - The slot is released by `onComplete` or by any refusal before the CGI starts. A push whose client hangs up while queued is skipped.
   - `headroom` is now just the cap minus `directorySize`, and the grant is `max(1, min(maxPushBytes, room))`.
2. **Unexplained second byte counter (decomplector #2).** I rewrote the comment on the body counter in `git-backend.ts`. It now says why the counter exists alongside `receive.maxInputSize`: it is the only bound on wire bytes, with a 413, for a body that has no `Content-Length`. `receive.maxInputSize` is still what keeps an over-cap pack from moving a ref.
3. **Missing `@throws` (archivist #1).** Added to `positiveInteger` in `config.ts`.

I also took three cheap should-fix items: a JSDoc for `failClosed`, rewording the "Full mechanism…" sentence in `DEPLOYMENT.md`, and a line in the `limits.ts` header and in `DEPLOYMENT.md` saying that pushes to one partition wait for each other.

**Tests:** In `git-remote-limits.test.ts`, the two tests that assumed concurrent reservations are replaced by three:
- a second push waits until the first ends, then completes;
- two pushes sent with `Promise.all` both complete;
- a push abandoned while queued doesn't block the queue.

Locally, tsc is clean and `test/git-remote/` passes 90 of 91. The one failure is `capability.test.ts › projectPartition propagates a git failure`, which fails the same way on the unmodified head, so this change didn't cause it.

**Commits:** `b990379` (fix) and `c5294c5` (docs), pushed with `safe-push-pr-head.sh` (3de6adc → c5294c5). `ci-wait-merge.sh` returned rc 0 with 3 of 3 checks green.

**Follow-ups**
- Git's own `receive-pack --advertise-refs` takes about 10s to answer while another push is held open. I saw it while testing, it isn't caused by this change, and I didn't dig into why.
- A client that stalls mid-push now holds up that partition's queue, much as it used to tie up the headroom. There is still no idle timeout on a push.
- I didn't add corner-prober's lower-priority boundary tests (findings 2–6).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2628307 cached reads)
- Output: 20291 tokens
- Cost: $1.6756813999999995
- Wall-clock: 1135s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
