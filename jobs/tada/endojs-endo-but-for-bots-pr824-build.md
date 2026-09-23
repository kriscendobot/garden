Built `@endo/sha256` from the approved platform-neutral hash design and carried it through the gauntlet to a green, un-drafted PR.

**Implementation PR: https://github.com/endojs/endo-but-for-bots/pull/903** (head `80521b46c`, ready for review, 25/25 CI checks green)

## What changed

- **`packages/sha256`** — new publishable package. `sha256(bytes) -> Uint8Array(32)` and `sha256Into(out, bytes, offset)`, synchronous, raw digest bytes, `TypeError`/`RangeError` rather than coercion. Conditional exports: `node` -> `node:crypto`; `xs` -> the Endor Rust host's `hostSha256Init`/`UpdateBytes`/`Finish` triple (no new Rust, prefers a future `hostSha256Bytes`, falls back to pure JS under a non-Endor XS engine); `browser`+`default` -> pure-JS sync SHA-256.
- **`@endo/platform`** — `blob-ref.js` hashes through `@endo/sha256`; hash bytes unchanged.
- **`packages/chat`** — the shim's duplicate 100-line SHA-256 deleted; it re-exports the package's pure-JS build.
- **Beyond the design, and required to actually unblock the bundle:** `@endo/exo-git` now deep-imports the two `fs/extended` modules it uses instead of the index (which dragged in `node:fs`), and `@endo/git`/`@endo/host-spawner` are injected as `DaemonicPowers.hostTools` rather than statically imported, mirroring the injected `better-sqlite3` `Database`. The design deferred the git leg as a parallel workstream; measurement showed it was a prerequisite.
- Design doc updated, three changesets, CI now generates the daemon bundle.

## Verification (all run, all observed)

- **The acceptance criterion:** `node packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs` went from a 16-failure `TypeError` to `Wrote rust/endo/xsnap/src/daemon_bootstrap.js`. `node --check` passes on the output; the `hostSha256Init` count rises 3 -> 6, showing the `xs` arm bound to the Rust host rather than the pure-JS `default`.
- `@endo/sha256` 72 tests; `@endo/platform` 309; `@endo/chat` 800; `@endo/exo-git` 3; eslint 0 errors, `tsc` and prettier clean, root typedoc exit 0.
- `@endo/daemon` does not run clean in this sandbox, so it was compared against a **baseline of the same tree with the changes stashed**: identical failures before and after (host git config, `/tmp noexec`), with the passing git and shell tests exercising the new injected path.

## The gauntlet found real defects

Two panel rounds, both blocking, all fixed and tested: a wrong-sized or non-buffer one-shot XS host return became a **silent wrong content address**; `assertBytes` used `instanceof`, so a `Proxy` answering different lengths returned the empty-input digest for eight bytes of content while the node build threw; a detached buffer diverged the same way; a host handle leaked on a throwing update. CI then caught a type error the daemon package's own `tsc` misses (`checkJs: false`) — a local/CI parity gap I closed by reproducing the typedoc gate locally.

## Follow-up PR #600 needs

**Rebase on `llm` and re-run `yarn --cwd packages/daemon test:rust`.** Nothing else. `daemon_bootstrap.js` is gitignored and generated, so no artifact moves between branches, and no source change is required in #600 for the crypto blocker.

Not verified: `test:rust` itself (needs a built `target/release/endor`) and the full repository suite locally — CI covers the latter.

Deferred per the design and parked as garden job `endojs-endo-but-for-bots-sha256-consistency-followups`: migrating `native-git-backend.js`'s two `createHash` sites, and the Rust `host_sha256_bytes` one-shot (the XS build already prefers it, branch tested).

Self-improvement: the reusable lesson is that a design's "separate, parallel leg" claim should be measured before it is believed — running the bundler first would have shown in one command that the git exclusion was a prerequisite, not a parallel workstream, and that the named blocker was 1 of 16.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr824-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 13 on 1 host(s)
- Input: 382 tokens (72293211 cached reads)
- Output: 98234 tokens
- Cost: $43.693695500000004
- Wall-clock: 1891s

<!-- garden-usage-end -->
