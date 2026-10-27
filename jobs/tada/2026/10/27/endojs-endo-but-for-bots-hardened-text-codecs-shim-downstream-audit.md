I finished the Phase 3 downstream audit for the hardened text codecs design on `llm` (`844ce3df7b`). None of the `Buffer` text-codec calls runs inside a SES compartment, so no code needed to move to `TextEncoder`/`TextDecoder`. I recorded the result in the design and opened draft PR **endojs/endo-but-for-bots#1576**.

**What the audit found**
- **Scope:** `Buffer.from(` and `.toString('utf…')` calls in `packages/*/src`, not counting comments. There are 22 call sites in 13 files.
- **Classification:** every site is in a module that runs on the Node host, where `Buffer` is a host global. These are the daemon's Node powers, the CLI, `git`, `claude`, `hosted-agent`, `npm-registry-server`, `opencode-sandbox`, `platform/http-node` and the `sandbox` drivers.
- **9p server:** this was the one package that needed a closer look, because its source files use `Buffer` without importing anything from Node. It is only loaded by an unconfined caplet (`mount-caplet.js`), which the daemon worker loads with a plain native `import()`. So it runs on the host too.
- **Other matches:** the hits in `pass-style/src/byteArray.js` and `immutable-arraybuffer/src/lib.js` are only comments.

**What changed** (`designs/hardened-text-codecs-shim.md`, documentation only)
- The Phase 3 bullet in § Status now says the audit was done and points to the results. It previously cited an older commit (`7ff30afbce`) and an out-of-date count of 16 sites.
- A new "Phase 3 audit result" subsection has a table listing each file, its number of call sites, and why it runs on the host.
- The "Updated" date is now 2026-10-27.
- The PR's base is the snapshot branch `llm-844ce3d`. The pre-push checks and prettier passed. Open draft PR #1431 edits the same design file but not these sections.

**Follow-ups**
- The automatic panel review chain for #1576 should be staged from this completion.
- Moving the host-side modules off `Buffer` would only be a style cleanup; the design doesn't require it. I posted no job for it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-hardened-text-codecs-shim-downstream-audit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2144925 cached reads)
- Output: 10705 tokens
- Cost: $1.3227250000000004
- Wall-clock: 246s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
