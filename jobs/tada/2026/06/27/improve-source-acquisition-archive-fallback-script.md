Both scripts are mode `100755` (executable) and the scholar reference is present. Work complete.

---

## Completion report

**Job:** `improve-source-acquisition-archive-fallback-script` — move source acquisition off the agent into a deterministic helper.

**What I did**

1. **Added `scripts/jobs/fetch-source.sh`** (origin/main2, commit `c043b4ba0`). Given a URL it:
   - tries a direct `curl`;
   - on any direct-fetch failure (the recurring case being connection-refused/timeout from the bot sandbox for `erights.org` and its `caplet.com` mirror) queries the Wayback availability API, then fetches the **original-bytes** form `http://web.archive.org/web/<ts>id_/<url>` — the `id_` capture that returns unmodified bytes via plain curl (the WebFetch tool refuses `web.archive.org`); falls back to the bare `…/2id_/…` redirect form when no capture timestamp is known;
   - writes the bytes (to a given path or a temp file) and prints a `key=value` manifest whose anchor field is **`source_content_sha256=<64-hex>`** (plus `source_effective_url`, `source_fetched_via=direct|wayback`, byte count, and `source_wayback_timestamp`). Bytes never hit stdout, so it composes in a pipeline. Sources `common.sh` for `require_tools curl sha256sum jq` / logging, consistent with the other job scripts.

2. **Added a hermetic test** `scripts/jobs/test/fetch-source-test.sh` — stubs `curl` via `FETCH_SOURCE_CURL` and pins the direct-success, archive-fallback (asserting the `id_` form + sha), no-timestamp redirect, double-failure (exit 1, no stray output), usage, and default-temp-path paths. **18/18 assertions pass.** No network touched.

3. **Referenced the script from the scholar's ingest procedure** (`roles/scholar/AGENT.md` step 4, same commit) and from **`library/conventions.md` § PDF/source acquisition** (origin/journal2, commit `aec5ac4ba`, landed through `land-journal-edit.sh`'s producer-clone CAS path), in both cases replacing the hand-derived prose with a pointer to the deterministic helper.

**Verification** — both files are mode `100755` on `origin/main2`; the conventions.md change is a clean single-paragraph addition on the current tip (no peer clobber). All work was done in an isolated worktree off `origin/main2` (per the garden-infra-job convention), committed with explicit pathspecs under the `endolinbot` identity, then torn down; scratch cleaned; inbox empty.

**Follow-ups / notes**
- The script discriminates fall-back on *direct-fetch failure* generally (not only connection-class curl codes); the recurring real case is connection refusal, but this also covers DNS/timeout. If a stricter "connection-class only" trigger is ever wanted, it's a one-line exit-code filter.
- `land-journal-edit.sh` (the lander I used) is currently an **untracked WIP** in the shared `/home/kris` tree from a peer job; it works (its own test is 18/18 green) but isn't yet committed to `origin/main2`. Worth confirming that peer job lands it.
