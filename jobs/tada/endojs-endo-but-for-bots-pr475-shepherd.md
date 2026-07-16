I've reached a hard escalation point. The failures are not fixable within PR #475's scope. Writing my report.

---

## Shepherd report — endojs/endo-but-for-bots#475

**Verdict: escalate. Red CI is inherited from a broken `master`, not PR-attributable. Nothing pushed to the PR.**

### What I found
Live check state on head `d6149e72` (feat/narrow-bytearray-to-uint8): 6 red checks — `lint`, `test (22.x/24.x × ubuntu/macos)`, `zizmor`. I pulled the failed logs for each and traced root cause:

- **lint** (`check-package-uniformity`): `packages/cbor` missing `LICENSE` + `SECURITY.md`, and its `package.json` is missing `.author`, `.repository.*`, `.bugs.url`, `.publishConfig.access`.
- **test** (all matrices): `test/cbor.test.js` → `ERR_MODULE_NOT_FOUND: Cannot find package '@endo/eventual-send'` from cbor's ses-ava-generated `import-from-project.mjs` (cbor's declared deps/install don't resolve it).
- **zizmor**: workflow action-pin version-comment mismatch (`points to commit 249970729cb0`) across `ci.yml` et al.

### Why it's not PR #475's fault
- PR #475's diff touches **none** of the implicated surfaces — no `packages/cbor`, no `.github/workflows/*` pins, no `scripts/check-package-uniformity.mjs`. It changes `bytes`/`marshal`/`pass-style`/`ascii` byteArray handling.
- `packages/cbor` **does not exist on the head branch** — it lives only on `master`. CI runs the `pull_request` merge ref (master ⊕ head), which pulls in master's cbor.
- I checked `master` directly: its own latest CI is **red on the identical set** — `lint`, `test x4`, `zizmor` (plus `build`/`Release`, which #475 passes). PR #475's red checks are a strict **subset** of master's. Master shipped an **incomplete `packages/cbor` landing**.
- Branch is **52 ahead / 5 behind** master.

### Why I stopped (impasse, per shepherd guardrails)
The fix belongs on **master** (complete the `packages/cbor` package: LICENSE, SECURITY.md, package.json uniformity fields, and its `@endo/eventual-send` resolution/yarn.lock), plus the master-wide zizmor pin-comment update. Pushing any of that onto #475's head branch would be an out-of-scope change to a package the PR doesn't own, in the wrong home, and wouldn't fix the shared root cause. That trips the "never push outside the PR's scope" guardrail.

### Handoff
- **`next: liaison`** — needs coordination/decision: fix broken `master` (a separate cbor-package fix job on master), then **rebase/weave #475 onto master** to clear the inherited red and re-run CI. There is likely a cohort of other open PRs red for the same reason.
- Surfaced to the maintainer via the message bus (`inbox/maintainer`, msg `20260716T184058Z-404cd3`) with the full failure inventory.
- No board job for the cbor/master fix exists yet; I left that for the liaison to route rather than self-posting a master-mutating job.

**Changed / pushed:** nothing (garden repo or PR). No commits — this run's work product is the diagnosis + escalation.
