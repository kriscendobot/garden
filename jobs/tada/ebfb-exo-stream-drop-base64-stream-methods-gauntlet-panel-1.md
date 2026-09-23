Done. The panel decided cleanly (exit 0), disposition **must-fix**, verdict posted as a review comment plus the full per-seat aggregate. This stage runs exactly one round and stops — no fix, no un-draft, no loop.

---

**Completion report — gauntlet stage PANEL round 1, endojs/endo-but-for-bots PR #1100**

**What I did**
- Resolved the PR head (`endojs:kriscendobot-exo-stream-drop-base64`, base `llm`, still draft) and took an isolated project worktree keyed to this job's base.
- Ran the jury panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the head `09d59c7459` diffed over `origin/llm` (30 seats). It exited 0 with terminal disposition **must-fix** (`panel #1100: code-panel single-round — must-fix`).
- Posted the verdict on PR #1100 as a `gh pr review`. GitHub forbids the bot (PR author `kriscendobot`) from formally *requesting changes* on its own PR, so it went as a **review comment** carrying a synthesized, de-duplicated must-fix set; the gauntlet driver keys the transition off the `gauntlet-stage-result` marker in this report, not the review state, so a fix round is still owed correctly.
- Attached the complete per-seat aggregate (~122 KB) as three follow-up PR comments so no seat detail is lost.

**Resilience note (two prior reaper requeues)**: earlier attempts had the panel backgrounded and the session torn down mid-run. This attempt launched the panel fully detached (`setsid`) so it survived, and I blocked in the foreground polling to keep the claim alive to completion.

**The must-fix cluster (what the fix stage will apply)**
1. Bytes-writer responder has no `writePattern`; `thawedBytes` silently coerces a wrong wire value (e.g. a base64 string → empty `Uint8Array`) into a zero-byte write with a success ack. Add `writePattern: M.byteArray()`.
2. `methodNames.includes('stream')` no longer discriminates a `ReadableBlob` from generic `PassableReader`/`PassableWriter`/`HttpResponse` (`mount.js`, `host.js`, `from-mount-backend.js`, `file-explorer-fs.js`); `assertReadableBlobSource` asserts a type it no longer proves. Add a second discriminator.
3. `daemon/src/types.d.ts` still declares `StreamNode<string, undefined>` on the renamed `stream`, propagating a false base64-string contract into generated agent-facing declarations. Set `Uint8Array` and regenerate.
4. `platform/src/blob.js` multi-chunk chunker rewrite (the only new arithmetic, only non-zero-`byteOffset` view into `frozenBytes`) has zero coverage — add a `@fast-check/ava` round-trip property.
5. Rename left false base64 prose in shipped changesets/docs and a silent `stringLengthLimit`→`byteLengthLimit` option rename undocumented; name `streamBase64` and the option rename in the changeset, fix the prose, and cover the missing packages.

**Follow-ups**: none for this stage. The driver will post the fix round (`panel=must-fix`); the fixer reads the posted verdict for these items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 100 tokens (3190105 cached reads)
- Output: 31718 tokens
- Cost: $5.320242500000001
- Wall-clock: 2796s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
