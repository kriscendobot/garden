## Report — endojs/endo-but-for-bots #655 (attention directive)

**Directive:** kriskowal, "Please close if subsumed entirely by #713."

**Preflight:** `pr-feedback-preflight.sh` exit 0 (no peer resolution) → proceeded.

### Verdict: subsumed — #655 closed

Compared #655 against #713's head `feat/mount-glorp-delegated` @ `454b2b97d` (full CI matrix green). Every #655 artifact has a counterpart in #713: the `grep` method in `mount.js` (re-implemented against the delegated `@endo/platform/fs/search` surface), the `MountInterface` guard entry, the `EndoMount` type declaration (#713's head commit is literally *"declare glob/grep/glorp on the EndoMount type"*), the conformance allowlist pin, the changeset, and both test artifacts in larger form (`mount-grep-cases.json` 214 vs 97 lines; `mount-grep.test.js` 225 vs 152).

Two independent reasons #655 could not have gone forward anyway:
- Its base `feat/mount-glob` (#653) is closed, as is B′ #679; C′ #680 is merged into the delegated line. #655 was the last live piece of the retired pre-decoupling stack.
- Its API is the pre-decoupling `grep(pattern, { glob })`; #713 ships the decoupled `grep(pattern, paths?, options?)` that design #675 directed.

**Actions:** posted the subsumption rationale as [#655 comment 5112827563](https://github.com/endojs/endo-but-for-bots/pull/655#issuecomment-5112827563) (carrying the `garden-reply:5111081574` marker) and closed #655. The directive comment already carried the 👀 ack.

### Defect found in #713 and filed there

The one #655 artifact not carried over is its `help.md` prose — and chasing that surfaced a real bug in #713. #713 adds the `glob`/`grep`/`glorp` entries to `packages/daemon/src/help-text-data.js`, whose header says *"AUTO-GENERATED … do not edit"*, but leaves its generator source `packages/daemon/src/help.md` untouched. Verified on that head:

```
$ node packages/daemon/scripts/generate-help-text-data.mjs
Wrote .../help-text-data.js (9 entities)
$ grep -c -E 'glob|grep|glorp' packages/daemon/src/help-text-data.js
0
```

The next regeneration silently deletes all three help entries and `mount.help('grep')` goes empty. Nothing catches it — the generator is not wired into CI as a drift check. Filed as [#713 comment 5112830585](https://github.com/endojs/endo-but-for-bots/pull/713#issuecomment-5112830585) rather than pushing to #713's head branch (a peer may be working it). #655's help.md diff is a useful template but not portable verbatim, since it documents the retired `{ glob }` option shape.

### Follow-ups for someone else
1. **#713:** move the three help entries into `help.md` and re-run the generator so the committed file is reproducible.
2. **#713 (broader):** a bare regenerate on that head also reflows ~150/275 lines elsewhere — `help-text-data.js` may be stale beyond these three entries.
3. **Repo-wide:** no CI drift check exists for `help-text-data.js`; adding one would have caught this.

No garden-library changes were needed, so nothing was committed to `main2`. Project worktree left clean (the generator run was reverted).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr655-0cb1a0bc.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 57 tokens (1534279 cached reads)
- Output: 11992 tokens
- Cost: $1.5780595
- Wall-clock: 211s

<!-- garden-usage-end -->
