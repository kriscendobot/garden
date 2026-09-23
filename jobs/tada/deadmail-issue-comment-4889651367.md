The job is already claimed by a gardener (it moved to `jobs/doin/`), and my inbox is clear. Work complete.

---

## Completion report: `deadmail-issue-comment-4889651367`

**Intent carried forward:** A dead-lettered message (addressed to the completed `issue-kriskowal-garden-25`) asked kriscendobot to dispatch a designer for a Google Sheets connector, `@endo/exo-google-sheets` (possibly backed by `@endo/google-sheets`), and to check the endo-but-for-bots roadmap for related or planned designs, then reply on issue #25.

### What I did

1. **Checked the roadmap** (`designs/README.md` and the `designs/` tree on `origin/llm` of `endojs/endo-but-for-bots`). Confirmed **no existing Google Sheets or spreadsheet design** exists, so this is genuinely new. Found and read the relevant prior art: `endoclaw-oauth` (the credential-capability / OAuth-proxy pattern, whose own example is `E(gmail).fetch('/messages')`), `endoclaw-network-fetch` (the `HttpClient` allowlist substrate), `exo-zip-package` (`@endo/exo-zip` wrapping `@endo/zip`, the direct naming/shape precedent for `@endo/exo-<thing>` backed by a plain library), `daemon-mount-capabilities` (facet attenuation), and **Milestone 7 (Weblets and Integrations)**, whose goal is "OAuth-based external service integrations" (the likely home milestone). Also flagged the distinct-but-adjacent `endopi-provider-registry-and-oauth` and `gateway-oauth-bonding` gap so they are not conflated.

2. **Posted the designer job** to the board: `design-exo-google-sheets` (frontmatter `role: designer` so it resolves to the Fable model per the role→model policy), with directive identity `kriskowal/garden#25:comment:4889651367` for dedup. The body names the repo/roadmap branch (`llm`, draft PR), the design questions to settle (capability shape, read/write facets, credential handling built on `endoclaw-oauth`, milestone placement, change notification, rate limiting), a `## Library and project references` floor citing the prior art above, the ISSUE NOTE block verbatim, and an instruction to reply on issue #25 with the slug and PR number. **Verified on the board:** it was claimed and is now in `jobs/doin/design-exo-google-sheets.md`.

3. **Replied on the issue thread** as kriscendobot (via the identity-pinned `gh` wrapper): https://github.com/kriskowal/garden/issues/25#issuecomment-4892409302 — acknowledged the dispatch, summarized the roadmap check and prior art, and noted the designer will follow up with the slug and PR number. Did not close the issue (submitter's prerogative). Comment written in garden prose style (no em-dashes, no Latin shorthand).

### What changed
- New board job `design-exo-google-sheets` (now `doin/`, claimed by a peer gardener wearing the designer role).
- One new comment on `kriskowal/garden#25`.
- No `main2` garden-source changes; no project-repo mutations by this job.

### Follow-ups
- The designer (already running) will draft `designs/exo-google-sheets.md`, open a draft PR against `llm`, and reply on issue #25 with the slug and PR number.
- Whether to un-draft, and any upstream ferry, remain maintainer decisions.
