# Fix round 2 for endojs/endo-but-for-bots PR #1362: complete, CI green

I applied the round-2 panel's fixable must-fix items and the cheap security should-fixes. That is four commits on `build/npm-dev-registry-serving`, taking the head from `c6972f7f27` to `e7efe19990`. The final CI tally was 33 checks with 0 failures (`ci-wait-merge` rc 0). One must-fix item, the integrator's objection to the architecture, can't be fixed in a fix round and is waiting on the maintainer.

## What changed
- **Must-fix items fixed:**
  - **Test type annotations (typist):** the five inline `import()` types in the tests are now top-of-file `@import` tags, and `test/registry.test.js` gained `// @ts-check`.
  - **Dead design link (archivist, integrator #2):** the README and three source comments cited `designs/npm-dev-registry-serving.md`, which isn't on the base branch. They now say the design is proposed and not yet landed, and link design PR https://github.com/endojs/endo-but-for-bots/pull/1361.
  - **Wrong README claim (integrator #3):** the README said the design permits this adapter. It now says the package does not yet follow the design.
- **Security and correctness fixes (should-fix):**
  - **Token rotation and forged grants:** the publish-time grant re-check now matches on the token's hash, not just the grant id. A token rotated mid-publish, or a hand-built grant record, can no longer finish a publish.
  - **Grant allowlist:** entries are validated, so `/*` can no longer match every package. The admin tool also trims whitespace from entries.
  - **Conflict message:** a publish that collides with a version fetched from the upstream registry no longer claims "different content".
  - **HTTP errors:** dist-tag names like `__proto__` or `constructor` now return 404 instead of 200 or 500. Malformed percent-escapes in the URL return 400.
  - **Hardening:** the request handler and the upstream fetch function are now hardened.
  - **Upstream timeouts:** a response body that stalls after the headers arrive is now a 504.
  - **Durable storage writes:** the content store retries short writes and syncs the directory after the rename.
  - **Tarball integrity:** checks compare only the strongest hash algorithm listed, as npm does.
- **New tests:**
  - New files `test/cas.test.js` and `test/tarball.test.js` cover the content-store round trip and the archive limits at their exact boundaries.
  - Other new tests cover token rotation, forged grants, and allowlist validation. They also cover the dist-tag and malformed-escape responses, and the timeout after headers.
- **Local results:** `yarn lint` has 0 errors, and 48 of 48 tests pass under Node 24.21. The shell's default Node 22 can't load the `better-sqlite3` native module from the warm cache, which was built for Node 24.

## CI
The `cover (24.x, ubuntu-latest)` job failed once: `yarn install` timed out on the network before any test ran. The same job passed on the previous head, so I re-ran it, and CI then finished green.

## Maintainer decision needed
- **Integrator must-fix #1:** the PR builds its own content store and SQLite database. The design (https://github.com/endojs/endo-but-for-bots/pull/1361, itself still an unreviewed draft) asks it to reuse the existing `@endo/exo-npm` machinery. I sent the maintainer three options: rehome the package on top of `@endo/exo-npm`, park the PR until the design and its directory-tree adapter land, or keep the separate store and amend the design. Round 3 of the panel will probably flag this again until that's decided.
- **Summary comment:** posted on the PR (issuecomment-5883725160). It maps each fix to its commit and lists what was deferred:
  - making the stored manifest come from the tarball's `package.json`
  - the upstream `time` field and a `Vary: Accept` header
  - async decompression and streamed tarball reads
  - error-branding cleanup
  - squashing commits
- **`SECURITY.md` left unchanged:** two reviewers asked to edit this package's `SECURITY.md`. The file is byte-identical to 130 sibling packages' copies, so editing it here would fork the shared template.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1362-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 126 tokens (7227110 cached reads)
- Output: 34612 tokens
- Cost: $3.2816140000000003
- Wall-clock: 3413s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
