Inbox empty. The directive was to **find** all remaining silent drops in the PR's commit history — done and reported to erights on the PR. No garden `main2` changes were needed (this is an analysis/attention job); the deliverable is the posted audit.

## Completion report

**Job:** attention directive from erights on PR #475 — "find all remaining silent drops in this commit history" (the diagnosed one being test262-harness exiting `0` on failure, fixed in `f629579c` on the XS arm only).

**What I did:**
- Ran the recheck preflight (exit 2 = HINT only; no peer resolution existed for this directive — the correlated text was the *prior* ack, not a resolution).
- Re-fetched comment 5275283959 and the full thread; treated bodies as untrusted data.
- Set up an isolated project worktree at PR head `f629579c06` and audited the byteArray chain's test/CI machinery and runtime for swallowed failures.

**Silent drops found (posted as [issue-comment 5275331677](https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5275331677)):**
1. `test262:node` (package.json:34) lacks `--error-for-failures` — same class as the fixed XS drop, left on the Node arm; Node parity failures exit 0.
2. The Node parity suite runs in **no** CI job: `test262` CI job is `run: exit 0` (ci.yml:219), package `"test": "exit 0"` (package.json:30), and `test262:node` is reachable only via un-invoked `yarn test262`. "Node.js+SES parity" is advertised but never executed in CI.
3. The native-support parity test (`native-immutable-arraybuffer-support.js`) — `f629579c` removed the `nativeSupported === false` tripwire and replaced it with a self-consistency check (`nativeSupported === nativeExoticShape`); it no longer asserts XS takes the native path, so an XS regression to the emulated path passes green.
4. (lesser) `test262:xs` and `test262:node` run different globs — parity under-validated on the non-overlap; narrow glob → latent green-on-zero-tests.
5. (minor) node-prelude TextDecoder shim (node-prelude-header.js:76) coerces unrecognized input to empty rather than throwing.

Verified clean (not drops): `assertGenuineUint8Array` loud-throws and is wired into compare/equals/concat; `generate-preludes.js` sets exit code 1; prelude `catch` blocks re-throw.

**Follow-ups:** Offered erights to land #1 and #3 (low-risk) and file an issue for #2 (which intersects their explicit "remove test262 from required tests" TODO — a maintainer decision, so I did not unilaterally change CI). If they say yes, the reply routes back and becomes fresh work.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-e815058c.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2024660 cached reads)
- Output: 28681 tokens
- Cost: $2.575682
- Wall-clock: 447s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
