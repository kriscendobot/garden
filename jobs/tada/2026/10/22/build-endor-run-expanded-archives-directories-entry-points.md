---
handed-off: build-endor-run-expanded-archives-directories-entry-points-open-pr
deliverable-complete: false
---
I built and pushed the next `endor run` slice, but the draft PR isn't open yet. This host's bot token gets a 403 when creating PRs on endojs (`createPullRequest`). I posted a successor job, `build-endor-run-expanded-archives-directories-entry-points-open-pr`, pinned to `requires: host=endolin-garden-ece02cb4`, to open the PR. It's on `origin/journal2` under `jobs/todo/`. Until it runs, there is no PR number.

**Picking the slice.** Most of the design is already shipped or in open PRs:
- Phases 1, 2, 4 (no-dependency entry) and 5 (`node_modules` walker plus registry resolver) are on `llm`.
- Phase 3 (directory input) is in #1521, which isn't merged yet.
- The XS-hosted compartment mapper (Option B) is in #1522, on the `endor` branch.

Two items from the design's "CLI changes" section were still missing: the explicit form flags, and a working `--cas-dir` (the parser accepted it and every run ignored it).

**What changed** (crate `rust/endo`; head `feat/endor-run-form-flags-cas-dir` at `14af3028a`, base `llm-f02cd81`):
- **Form flags:** `--zip` and `--dir` override detection by extension and first bytes. A ZIP with a shell stub in front, which detection can't place, now runs with `--zip`.
- **Usage errors:** two different form flags, a form flag with `--cas <hash>`, or a path of the wrong type each exit 2. An existing file that detection can't place now says so and suggests `--zip`, instead of "input not found".
- **`--cas-dir <path>`:** now sets the content store for ZIP, directory, `--cas` and `--node-modules` runs. The default is unchanged.
- **Registry resolver refuses `--cas-dir`:** it exits 2, because its registry table points at hashes in the daemon's store. `--no-cas` with `--cas-dir` also exits 2.
- **Docs:** `endor help run` and the design's Status section describe the flags.

**Branch structure:** the branch includes #1521's directory-input commit and should merge after it.

**Tests:**
- New unit tests cover flag parsing and how an override is applied.
- A new `tests/endor_run_cli.rs` runs the built `endor` binary: the stub-prefixed ZIP, a `--cas-dir` ingest and replay, and each usage error.
- All of these pass locally, against XS bundles I generated and the `c/moddable` submodule. All three binary tests fail against the old `endor.rs`, and the override unit tests fail when the override is ignored.
- Clippy reports nothing in the changed files, and the pre-push gates pass. One non-blocking advisory flagged the registry/`--cas-dir` comment; I kept it because it explains why the registry resolver refuses the flag.
- The `endo` crate isn't in CI, so none of this has run there.

**Left out on purpose: `--entry`.** Every file that detection doesn't already treat as an entry module has an extension both entry resolvers refuse. I tried it, and the flag only changed the error message. It needs a rule for which module language an extension-less entry uses first; that is a possible follow-up.

**Other follow-ups:**
- Once the PR is open it goes through the usual review chain, which will probably hit the same 403 on this host. The memory note says to retry those stages on an endolin host.
- I added this run to the memory note about the token. I also noted that `pre-push-gates.sh` needs a full 40-character commit hash for `--base-ref` when the repo lock is contended.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endor-run-expanded-archives-directories-entry-points.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 132 tokens (8016824 cached reads)
- Output: 44283 tokens
- Cost: $3.8388887999999994
- Wall-clock: 3849s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
