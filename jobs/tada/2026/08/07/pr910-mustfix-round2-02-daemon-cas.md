All three blockers are addressed, pushed, and the summary is posted. Inbox is empty and the PR remains draft as required.

## Completion report

**Job:** PR #910 fix round 2, child 02/06 — daemon mount / CAS hardening (`endojs/endo-but-for-bots`, branch `feat-readableblob-range-attenuation`). Pushed head: `82438dd4f` (3 atomic commits over `2aa00f72b`, no force-push). PR left **draft**.

**Blocker 1 — EOF-loop windowed reads** (`07e56ffad`): The daemon `manager-node-powers.readFileRange` and `content-store-powers.readFileRange` derived the count from `stat().size` and stopped on the first short read — a procfs/sysfs/FIFO source (stale/zero size, short reads) could mint a false empty content address. Mirrored round-1's PLAT-02 count-or-EOF loop, factored into a shared injectable helper `@endo/platform/fs/node/read-file-window` used by both sites. Regression test drives a fake short-reading source.

**Blocker 2 — fixed frame bound + verified CAS insert** (`5ee78cc22`): The content-addressed read cache set the per-frame `stringLengthLimit` from the sender-advertised size and stored bytes under the sender's `(algorithm, hash)` key unverified — a remote could enlarge the accepted allocation and poison the store under a forged key. Now drains under a fixed `MAX_FRAME_BASE64_LENGTH` (never size-derived), bounds the total by the advertised size, and verifies size + SHA-256 digest before inserting in both `cas.js` (`cacheBackedRead`) and `cached-fs.js` (`withCachedReads`). Tests cover an oversized frame, size lie (both directions), and digest lie.

**Blocker 3 — exo-tag parent-SHA leak** (`82438dd4f`): The derived `EndoBlob` range cap tag embedded `sha256.slice(0,8)`, leaking 32 bits of the parent content address over CapTP to a holder of the attenuated cap. Retagged `EndoBlob range`.

**Verification:** `@endo/platform` tsc/eslint/prettier clean, 57 ava tests green (incl. 6 new). `@endo/daemon` tsc/eslint clean, `mount.test.js` range tests green (exercise the daemon `readFileRange` end-to-end). The full `endo.test.js` daemon-boot suite could not run in this sandbox — an unrelated `endo.sock` bind failure that also fails baseline tests — left to CI. Appended a hardening note to the existing `readableblob-range-attenuation.md` changeset (bump levels already correct).

**Follow-up surfaced (out of scope):** digest verification recomputes SHA-256 only; a `git-sha1` blob reaching this consumer cache is size-verified but not digest-verified, since portable SHA-1 is unavailable (the browser `node:crypto` shim is SHA-256-only). Closing it needs a SHA-1 primitive in the shim — noted in the PR summary.

**No reasoned declines reopened.** Top-level summary comment posted (#issuecomment-5212232470). No un-draft / merge / panel re-run (later children own those).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr910-mustfix-round2-02-daemon-cas.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 168 tokens (12496449 cached reads)
- Output: 91691 tokens
- Cost: $10.5432205
- Wall-clock: 1415s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
