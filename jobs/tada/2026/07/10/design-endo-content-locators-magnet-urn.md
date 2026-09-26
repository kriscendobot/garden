Inbox empty. All deliverables complete and verified.

## Completion report

**Job:** `design-endo-content-locators-magnet-urn` — expand kriskowal's directive (kriskowal/garden#34) into a self-contained design for Endo content locators (magnet URNs).

**What I did**
- Researched the Endo corpus via the garden library and the live `llm` branch: the transport-locator format and its ephemeral-connection-hint discipline (`daemon-locator-reference`), the `@nets`/`NETS` per-agent networks model and `getAllNetworkAddresses` (`daemon-agent-network-identity`, the DANI design — the `@nets` analogue the directive asked me to name), the CAS SHA-256 content addressing (`daemon-cas-management`), `ReadableBlob`/`ReadableTree` (`platform-fs`), in-band CapTP transfer (`daemon-checkin-checkout`, `snapshot`/`storeTree`), the Gateway as socket-vendor (`daemon-web-gateway`, `gateway-package`), and the control-plane-on-CapTP / data-plane-off-CapTP split already drawn for git (`daemon-git-capability`, `daemon-git-remotes`).
- Wrote `designs/endo-content-locators-magnet-urn.md` (Status: Not Started). It defines the content locator as the content-side analogue of the transport locator: a `magnet:` **URN** naming a readable-blob/readable-tree by its SHA-256 hash (`xt`), carrying **configuration-dependent, Gateway-vended data-plane hints** (`ws`/`xs`/`as`/`tr`) resolved fresh at share time. It names **`@planes`** as the content analogue of `@nets`, adds the `contentLocate`/`listContentLocators`/`reverseContentLocate`/`internalizeContentLocator`/`acquire` interface family, an **extensible `ContentDataPlane` registry**, works **HTTP web-seed end to end** (recommended first plane, with rationale) while naming **Git-over-HTTP** and **BitTorrent** as follow-up designs to be filed, situates the Gateway as the hint source, and draws the explicit boundary against in-band CapTP (out-of-band complement, not replacement). Every byte is verified against `xt`, so data planes need to be available, not trusted. Six open questions are surfaced rather than decided.

**What changed**
- New file `designs/endo-content-locators-magnet-urn.md`.
- `designs/README.md`: added the summary-table row and bumped totals (145→146 designs, Not Started 37→38) with a dated changelog note.
- Draft PR **endojs/endo-but-for-bots#662** against `llm` (verified draft, base `llm`, exactly the two files). Pushed the `design/endo-content-locators-magnet-urn` branch directly to `endojs/endo-but-for-bots` (see follow-up below).
- Commented on the originating issue **kriskowal/garden#34** linking the draft PR; **left the issue open** for kriskowal to review and close.
- House-style verified clean (no em-dashes, no Latin shorthand).

**Follow-ups / notes for the liaison**
- **Doc-vs-reality drift:** the project README (`journal/projects/endo-but-for-bots/README.md`) says work happens on the `kriscendobot/endo-but-for-bots` fork, but that fork does not exist and `kriscendobot` has **direct push** to `endojs/endo-but-for-bots` (default branch `llm`). I pushed the `design/` branch directly to `endojs` accordingly (matching the README's "the garden owns the upstream llm branch and frequently pushes directly" note). Worth reconciling the README's Identity/Upstream sections so the next designer does not chase a missing fork. I also created a local bare clone at `worktrees/endojs-endo-but-for-bots.git`-adjacent path only for `endojs` (the failed `kriscendobot` bare-clone attempt created nothing).
- **README milestone incorporation deferred:** I added the summary-table row and total but deferred milestone assignment, dependency-graph edges, and the size/duration estimate to the journalist's next classification cycle (the graph/Gantt/milestone machinery is journalist-owned and calibrated); this is called out in the PR body and the design's Open Questions.
- No library writebacks were needed (I reached every concept through the keyword index, not flat-grep). The new terms (content locator, magnet URN, `@planes`) will enter the library through the scholar's normal ingest of the new `llm` design.

Self-improvement: the project README's "kriscendobot fork" assumption is stale for this instance; flagged above for the liaison to reconcile so future designer jobs on this repo do not stall on a missing fork.
