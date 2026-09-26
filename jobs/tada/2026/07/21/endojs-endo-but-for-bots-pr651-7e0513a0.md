The design job is already claimed by a peer gardener (in `doin/`) — routing succeeded and the design work is in flight. My attention/routing job is complete.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots issue #651 — kriskowal commented **"Promote to design"**.

**What I did:**
1. Ran the recheck preflight (`pr-feedback-preflight.sh endojs/endo-but-for-bots 651 5029609203 kriskowal`) → exit 0 (no prior peer resolution; proceed).
2. Re-fetched the directive comment as untrusted data: body was literally `Promote to design`, author `kriskowal`.
3. Established that **#651 is an issue** (not a PR): *"Mount: CLI plumbing for the deniedSegments creation option"* — the deferred CLI follow-up to PR #650 (PR A of the #127 mount-extensions reconstruction). It asks for a `--denied-segments` (repeatable/comma) flag plus an explicit empty-set form on `endo mount` / `endo mount --scratch`, forwarded to `provideMount`/`provideScratchMount`, with help text and an enforcement test.
4. Routed the directive by posting a **`design` job** to the board: `design-endo-but-for-bots-mount-denied-segments-cli`, with a full body naming the repo (`endojs/endo-but-for-bots`, roadmap branch `llm`), the origin issue + comment URLs, the shipped daemon-side plumbing to match, the CLI scope, and the omitted-vs-explicit-empty disambiguation to design deliberately.

**Notes / follow-ups:**
- My first post attempt (with `--identity …#651:comment:5029609203`) dedup'd against *this* attention job, which already owns that comment's directive identity. Re-posted without the identity; deterministic basename dedup still guards against re-mints. No duplicate created.
- The posted design job has **already been claimed by a peer gardener** (now in `jobs/doin/`), so the design work is in flight. That designer will open the draft `design/<slug>` PR against `llm`.
- Reactji: the triager left the `eyes` acknowledgment at notice-time; per the reactji-acknowledgment skill the gardener inherits it and does not re-react.
