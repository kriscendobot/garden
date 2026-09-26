CI is green (rc 0). The gauntlet fix stage is complete.

## Completion report

**Stage:** FIX round 5 — endojs/endo-but-for-bots PR #1116 (`design: guest-native invitation and acceptance`), a design-doc PR (head `endojs:design/guest-native-invitations`, base `llm`).

**Panel round-5 must-fix items applied (one pass) to `designs/guest-native-invitations.md`:**

1. **CAS reaches nested path form** (critic, skeptic) — the consume-once compare-and-set no longer assumes a top-level pet store. §5 now resolves the leaf hub with one `await lookup(prefixPath)` *before* a synchronous hub-level `storeLocatorIfMatches`, so `invite(['peers','bob'])` / the retained `invite nests the invitation at a directory path` test is covered instead of degrading to last-writer-wins. §9 pet-store bullet updated to a bare-`name` synchronous method.
2. **Single commit point** (critic) — named the inviter-side CAS as the one commit; the acceptor-side bind is a plain insert-only local write. `acceptInvitation` (§9) and §7 now assign the commit to one daemon and return the outcome as a passable record across CapTP.
3. **`accept` signals by return, not reject; §1/§7 contradiction resolved** (decomplector, ergonomist, novice) — `accept` resolves `{ status }` (`joined`/`already-joined`/`already-consumed`/`peer-conflict`/`name-in-use`) and rejects only for locally-raised `unreachable`/`malformed-locator`. Idempotent re-drive is now an ordinary success path that repairs the acceptor-side bind. §1, §5, §6, §7, §8 made consistent.
4. **Wire-survivable carrier** (ergonomist, skeptic) — terminal states cross as a hardened passable record (survives marshalling) instead of a thrown tag that collapses to `Error`; the `makeTaggedError`/`Registry*ErrorName` precedent cited; status tag constants exported.
5. **Restored dropped `packages/daemon/src/guest.js` bullet head** in §9 (copyeditor, pedant, novice).

Also folded in two low-cost should-fixes: the `name-in-use` acceptor-side insert-only refusal (skeptic finding #4 / ergonomist), and the stale-date/house-form fixes (pedant) — bumped `Updated` to 2026-09-04 and updated the `designs/README.md` entry (added-and-revised form + table date).

**Push:** commit `9d4ae53e56` pushed to PR head `design/guest-native-invitations` (the worktree's default remote was misconfigured to `endojs/endo.git`; added a correct `endojs/endo-but-for-bots.git` remote and pushed through it).

**CI:** all 5 checks COMPLETED SUCCESS (build, lint, test, browser-tests, zizmor); `ci-wait-merge.sh` returned rc 0 (GREEN), no merge.

**Follow-ups (deferred, not must-fix):** the deeper should-fixes remain for a later round — keying the terminal record on the formula id rather than the mutable pet name (decomplector), answering OQ2 (what `@pins/guest-*` protected) before shipping the guest path (critic), and the copyeditor/pedant prose/line-wrap cleanups. Panel-6 (re-posted by the driver) will re-adjudicate.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 94 tokens (4123582 cached reads)
- Output: 39290 tokens
- Cost: $5.00617375
- Wall-clock: 1226s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
