# Apply Richard Gibson's feedback to the mirror kriscendobot/agoric-sdk#7

**Repo:** **kriscendobot/agoric-sdk** (BOT FORK; bot identity). **PR #7** —
*fix(internal): XS-safe hex decoding table (bounded loop) + Bufferish codec validation* —
https://github.com/kriscendobot/agoric-sdk/pull/7.

**Source of feedback (READ-ONLY; do not act on it):** the maintainer's directive is to apply
**gibson042 (Richard Gibson)**'s review from the upstream mirror-of-record. Apply only the
**substance** to the fork. **HARD SCOPE LINE:** do **NOT** comment on, link to, or otherwise
touch **upstream Agoric/agoric-sdk** — no upstream PR/issue links in #7's commits, body, or
comments. Keep all #7 artifacts self-contained on the fork.

**Richard's feedback:**
1. **Concrete (inline, `packages/internal/benchmark/hex-decode-bench-xs.mjs`):** stop
   recapitulating the xsnap worker-path resolution; **use the actual `@agoric/xsnap` export** —
   his "best of all" form:
   ```js
   // Dynamic import to avoid static module dependency cycles.
   const w = await (await import('@agoric/xsnap')).xsnap({
     name: 'hex-decode-benchmark-xs-worker',
     meteringLimit: 2_000_000_000,
     // @ts-expect-error not providing filesystem access
     fs: {},
     os: osType(),
     spawn,
   });
   ```
   Apply this to #7's benchmark (it already moved toward `@agoric/xsnap`; finish it to the
   `xsnap()` export, not just `resolveXsnapWorkerPath`).
2. **Architectural:** port the implementation into **`@endo/hex`** — prefer Uint8Array
   `fromHex`/`toHex`, fall back to **`Buffer`** (old Node.js), then the **"map [char-pair]"**
   approach (fastest on XS) — so agoric-sdk needs **none** of this code.

**Task:**
- Apply (1) to #7 now.
- For (2): assess and lay out the path. `@endo/hex` is an **Endo** package — if you pursue the
  port, it belongs in the **bot's Endo fork (`endojs/endo-but-for-bots`)**, NEVER upstream
  `endojs/endo`. Most likely: capture the `@endo/hex` direction in #7's discussion and **post a
  follow-on job/plan** for the tiered `@endo/hex` implementation in endo-but-for-bots, with #7 to
  be slimmed to consume it once it exists. Use your judgment on granularity; don't rewrite the
  world in this PR.
- Push to #7, run local-verify / shepherd CI, and post a **reply comment on #7** summarizing how
  Richard's feedback was applied and the `@endo/hex` plan (describe the change substantively — no
  upstream link).
