The work is complete. Let me summarize.

## Completion report

**Job:** endo-but-for-bots PR #1125 — harden the guest-facing read-only directory hub from a bare `Far` to a guarded `makeExo`.

**What I did**

Fixed `packages/daemon/src/directory.js` `readOnlyDirectorySource`. The guest-facing read-only view (returned by `EndoDirectory.readOnly()`, handed across a worker/vat boundary to a less-trusted holder) was minted as a bare `Far('ReadableNameHub', {...})` — passable and hardened but with **no InterfaceGuard**, so malformed/wrong-typed arguments were only caught downstream at the backing directory.

**Approach chosen — Option 1 (endow into the eval compartment), with zero new endowments.** I verified in `worker.js` that the eval compartment is *already* endowed with `makeExo` and `M` (alongside `E`/`Far`). So I rebuilt the view as `makeExo('ReadableNameHub', ReadableNameHubInterface, {...})`, reconstructing the interface guard inline from `M` (mirroring `ReadableNameHubInterface` in `interfaces.js` method-for-method). Because no new eval endowment was added, `formulateEval`'s `names`/`values` plumbing and the `isReadOnlyDirectoryFormula` recognizer (`names === ['hub']`, `values.length === 1`, `source === readOnlyDirectorySource`) stay intact automatically.

- `help` became a synchronous self-description: I empirically confirmed the exo's `.returns(M.string())` sync guard rejects a promise, so the old remote-forwarding `help` could not keep the exact `ReadableNameHubInterface` contract. `has`/`list`/`lookup`/`maybeLookup` still forward (their `M.promise()`/`M.any()` returns accept the forwarded promise).
- **Durable-identity check:** the read-only-as-eval formula is brand-new in this very PR (commit `42bad92360`, unreleased), so the source-string change to its durable identity affects no persisted formula. The restart/incarnation test confirms re-incarnation from the new source.

**Verification**
- `yarn lint:types` (tsc) clean; `yarn lint:eslint` 0 errors (only pre-existing warnings).
- Extended the `EndoDirectory.readOnly()` test with a behavioural proof: `lookup(42)`/`has(42)` are now rejected at the exo boundary (`/ReadableNameHub/`). Test passes.
- Ran all 35 read-only/incarnation daemon tests green, including `provideGuest preserves a read-only networks attenuation` (exercises daemon restart + eval-formula endowment diagnostics). Note: the deep scratch-worktree path exceeds the AF_UNIX 107-char socket limit, so I ran with a temporarily-shortened `sockPath` (reverted before commit; verified diff is only the two intended files).

**Landed & closed the loop**
- Pushed `9fad002ba8` to PR head `kriscendobot/endo-but-for-bots:bot/build/endo-guest-invite-primitive` (fetch+rebase CAS, fast-forward).
- Replied on review thread `r4040218737` (comment `r4040987283`) citing the SHA and the one-line note that the guest-facing view now carries `ReadableNameHubInterface` via `makeExo`. Verified the posted body rendered un-mangled.

**Follow-ups (maintainer's call — not fixed, per job spec):** the two secondary findings remain notes only — (1) the read-only view is a *shallow* attenuation (`lookup`/`maybeLookup` return live, writable nested directories; documented in-code), and (2) a guest inviter can drive root-level `addPeerInfo` via the internal broker. Both are deliberate surface-expansion questions the maintainer already flagged; no scope change made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-fix-readonly-hub-makeexo-guard.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 132 tokens (6184829 cached reads)
- Output: 37655 tokens
- Cost: $5.248099500000001
- Wall-clock: 837s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
