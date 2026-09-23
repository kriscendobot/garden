The job is complete and verified. Summary of board state:
- `jobs/tada/scholar-ingest-source-erights-elang-primaries.md` — present (completed ✓)
- `jobs/doin/scholar-ingest-source-erights-elang-remainder.md` — my follow-on was already claimed by another gardener within the minute (the pool is active ✓)

Scratch cleaned up; no worktree was created.

---

## Completion report

**Job:** `scholar-ingest-source-erights-elang-primaries` (gardener 68, endolinbot) — **done.**

**What I did.** Continued the maintainer-directed re-ingestion of erights.org E-language primaries through the GitHub Pages mirror. Fetched the candidate pages with `fetch-source.sh` (all served `source_fetched_via=mirror`), read each body before treating it as a source, and ingested the three substantive tutorial body chapters that the already-ingested index/intro pages only listed.

**Sources ingested** (`source_kind: web`, mirror, 1 section each; anchor = `source_content_sha256`):
- `erights--elang-intro-finding-text` (`elang/intro/finding-text.html`) — first hands-on E walkthrough; the message-call-as-primitive framing. → capability-theory
- `erights--elang-intro-standalone` (`elang/intro/standalone.html`) — packaging an E program as a `rune`-runnable shell script. → capability-theory
- `erights--elang-concurrency-introducer` (`elang/concurrency/introducer.html`) — secure distributed E: introducer, live/sturdy references, capability URIs, eventual-send `<-`; the CapTP/locator ancestor. → capability-security, capability-theory, eventual-send, captp

**Skipped (with reason, recorded in the follow-on so it isn't rediscovered):**
- `elang/intro/object-lambda.html` — a literal "***to be written" stub on the mirror (200 OK but no content).
- `elib/.../ode-capabilities.html` (the tutorial's money example) — already covered at higher fidelity by the FC2000 paper `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000`; verified document identity before skipping, per the job's explicit instruction.

**Indexes updated:** `sources/README.md` (3 rows), `sections/README.md` (3 sorted blocks), and topic pages `capability-theory` (3), `capability-security`, `eventual-send`, `captp` (1 each). All landed via `land-journal-edit.sh` with tip-content-plus-rows for the shared indexes.

**Integrity gate:** `library-link-check.sh --source-slug` run for all three new clusters against the synced producer-clone tip — **all OK**.

**Follow-up:** Posted `scholar-ingest-source-erights-elang-remainder` (now already claimed) naming the precise remainder — `starting-e.html`, `quickE.html`, the ode-objects/ode-protocol subpages to evaluate against FC2000, CapDesk/Polaris primaries to locate, and the HPL-2004-116/HPL-2006-116 PDFs via the Wayback fallback.

**Self-improvement noted in the result:** the mirror serves stub pages at HTTP 200, so reachability ≠ ingestable content — read the fetched body before counting a page as a source, and record discovered stubs in the follow-on.
