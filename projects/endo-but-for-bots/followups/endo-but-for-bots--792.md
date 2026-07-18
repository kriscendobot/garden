---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 792
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-07-18T12:45:00Z
last_appended_at: 2026-07-18T12:45:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#792

Created from the code-panel verdict on `feat(daemon): serve content through HTTP
web seeds` (branch `build/endo-content-locators-magnet-urn-phase4-http-web-seed`,
base `llm-b43e801`), Phase 4 of the magnet-URN content-locator design. The
in-scope must-fix (empty-directory tar round-trip) and a bundle of cheap
should-fix items (octal size-field overflow guard, Gateway mid-stream
double-header, digest-only-for-blob cleanup, changeset patch→minor) were fixed in
the gauntlet's fixer pass (head `7d25f7ff2f4`). The items below were
dispositioned `follow-up` (useful, not blocking un-draft) and warrant revisit
when the PR (or an upstream mirror, if ferried) merges.

## Items

- [ ] Bound an untrusted web-seed fetch: cap the response body size (cross-check
  the design's `xl` content-length parameter) and apply a request timeout before
  buffering. `makeHttpContentDataPlane.fetch` currently does
  `new Uint8Array(await response.arrayBuffer())` with no cap, so a malicious or
  attacker-advertised `ws` seed can OOM the daemon before verification runs.
  Fails safe on integrity (mismatched bytes are still rejected) but is a
  remotely-triggerable DoS.
  **Source seat(s)**: saboteur, breaker
  **Recommended action**: follow-up PR adding a size cap + timeout to the HTTP
  content plane; thread the locator's length hint through when the grammar adds
  `xl`.

- [ ] SSRF hardening: `loadContent` (exposed on both host and guest agent
  interfaces) fetches any attacker-supplied `http:`/`https:` URL from a content
  locator, including link-local (`169.254.169.254`) and loopback targets, and the
  request status/statusText is echoed back in the aggregated failure message —
  an SSRF probe oracle. Blocked targets should fail closed and opaquely.
  **Source seat(s)**: warden/locksmith
  **Recommended action**: follow-up PR adding a link-local/loopback/private-range
  guard for daemon-side fetches driven by untrusted locators; decide policy with
  the maintainer (this is arguably a Phase-5 verification/fallback concern).

- [ ] In-band CapTP fallback leaves a stray unverified formula on hash mismatch:
  the blob and tree in-band branches formulate first (`formulateReadableBlob` /
  `checkinTree`) and verify after; on mismatch they push a failure but the
  created formula (and, for trees, already-written blobs) persists unnamed and
  un-GC'd. Never returned, so not an integrity bypass — a storage-leak concern.
  **Source seat(s)**: saboteur
  **Recommended action**: clean up (revoke/GC) the formula on the mismatch path,
  or verify before formulating as the web-seed path now does.

- [ ] Host a tar *writer* in `@endo/tar` beside `reader.js`, sharing the field
  offsets / block-size / octal-encoding constants, and reuse it from the daemon's
  `fetchContent`. The hand-rolled writer re-encodes ustar format knowledge that
  the reader already owns and has now diverged from it (the writer originally
  omitted directory entries the reader handles).
  **Source seat(s)**: decomplector, pruner, corner-prober
  **Recommended action**: follow-up PR extracting `@endo/tar/writer.js`.

- [ ] Factor the four near-duplicate formulate+verify arms in `loadContent`
  (web-seed blob/tree, in-band blob/tree) into the generalized verification
  wrapper the code comments already flag as the Phase-5 seam.
  **Source seat(s)**: decomplector
  **Recommended action**: land as part of Phase 5 (verification gate and
  fallback) per the design's implementation phases.

- [ ] Coverage gaps on error/fallback branches: the in-band CapTP fallback *tree*
  branch, the terminal "Unable to load content..." all-sources-fail throw, the
  plane's `!response.ok` branch, the Gateway 404 branch, and `getPlaneForSource`
  returning undefined are untested. `cover` CI passes (thresholds met), so these
  are non-blocking, but a few cheap unit/integration tests would pin them.
  **Source seat(s)**: coverage-auditor
  **Recommended action**: add targeted tests; can ride the Phase-5 PR.
