# Fix round 6: endojs/endo-but-for-bots#1362

I applied the panel-6 must-fix items and pushed them, and CI is green: 33 checks, 0 failed, head `62d4024ae3`. The push range is `74d52b50fc..62d4024ae3`, done with `safe-push-pr-head.sh` as fast-forwards. The PR stays in draft.

**Must-fix items:**
- **spec-keeper (tar/pax framing):** `tarFramingDivergence` now refuses two kinds of archive that node-tar and `@endo/tar` read differently. One is a pax header directly after a per-entry `x` header. The other is a global `g` header that overrides `path`, `linkpath` or `size`. Four new tests cover them, including one showing a normal single `x` header is still accepted. (`1fce9f6ee9`)
- **stylist:** renamed `package_meta` to `package_metadata` and the related `meta` identifiers to `metadata`, and renamed the test variable `auth` to `authorizationHeaders`. (`5455c44e7f`)
- **prover:** added `test/errors.test.js`. It checks that a registry error's status and reason can't be changed, and that a look-alike error without the brand isn't treated as one.
- **corner-prober:** added a test for the upstream size limit at exactly the limit and one byte over. It covers a correct, a missing and an understated `content-length`. (This and the prover test are in `3bc0f15761`.)
- **integrator:** rewrote the PR body. It now uses `REGISTRY_STATE_DIRECTORY` and `package_metadata`, and the Verification section matches the current head (87 tests). It calls the PR an early probe of the still-open design endojs/endo-but-for-bots#1361, to stay in draft until that design lands, and notes that other designs call the service `npm-dev-proxy`.

**Should-fix items I also took:**
- Upstream versions anywhere in the `dev` prerelease namespace are now kept out, not just the exact dev-version format this server creates. Before, versions like `1.7.0-dev.99999999999999`, `<dev>.1`, `<dev>+x` and `-DEV.` could outrank or tie a staged build. (`405aeea665`)
- `parseIsoInstant` now requires exactly three millisecond digits, checks every time and offset field's range, and no longer relies on `Date.parse`. (`db25915d50`)
- `deprecated` is stripped from published manifests. (`1bada68b7d`)
- The `TextDecoder` used for tar headers is now created once at module level.

**Reverted:** the orthographer's "acknowledgement" fix in `SECURITY.md` failed CI. `scripts/check-security-md.sh` requires every package's copy to be byte-identical, so I reverted it in `62d4024ae3` and explained why in a PR comment. That spelling can only be fixed repo-wide.

**Deferred and listed in the PR comment:** rewriting SECURITY.md (it matches every other package's copy), renaming to `makeRegistryHttpError`, using `@endo/base64`, making `harden` use consistent, checking the publisher's declared digest, async CAS writes and fewer copies, consolidating the CAS code, and regrouping commits.

**Follow-ups:**
- The companion deployment PR kriscendobot/minion.town#135 still sets `REGISTRY_STATE_DIR`, and the server won't start without the new name. I posted job `minion-town-pr135-registry-state-directory-rename` to fix it.
- To run tests locally I rebuilt `better-sqlite3` for this host's Node 22 inside the job's own project worktree. I copied the package first to break its hardlinks, so the shared warm cache was not changed.

**Local results:** package `ava` 87 passed; eslint 0 errors (11 warnings, the same count as the prior head); both package-uniformity checks pass.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1362-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 154 tokens (7964247 cached reads)
- Output: 32200 tokens
- Cost: $3.2423134
- Wall-clock: 4439s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
