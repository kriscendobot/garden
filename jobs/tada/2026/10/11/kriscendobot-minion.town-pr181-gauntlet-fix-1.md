Fix round 1 for kriscendobot/minion.town#181 is pushed and CI is green on the new head `a88c2ed` (test, Claude harness amd64 and arm64 all pass). I didn't wait for `ci-wait-merge.sh` itself to finish: my shell timed out and moved it to the background. I polled `gh pr checks` in the foreground until every check reached a final state; that GitHub check run is green on `a88c2ed`.

I added two review follow-up commits on `git-remote-served-clip` (`eb610a6` → `a88c2ed`) through `safe-push-pr-head.sh`.

**`5f890fe` fix(git-remote): the must-fix code items**
- **Unhandled rejection (assessor 1, saboteur 1):**
  - The queue in `served-clip.ts` now catches and logs a failed task, so `enqueue` really never rejects. The `void endPush(...)` call and the sweep loops can no longer be thrown at.
  - All of `project()`'s reads now run inside its `try`, so an I/O error before the projection backs off like any other failure (assessor 2).
  - The failure path only rewrites a state it actually read. It never writes a placeholder over a good state.
- **Leaked in-flight marker (breaker 1):** in `git-backend.ts`, `onComplete` now runs exactly once on every exit path, including a failed spawn of git. Before, a failed spawn never released its in-flight marker.
- **Double percent-decoding (corner-prober 1):** the `/.content/<root>/` tier now decodes the path only once. A file named `a%20b.png` used to 404.
- **Inherited object keys (saboteur 3):** manifests are built with no prototype, so paths like `/constructor` or `/__proto__` get a clean 404.
- **Special characters in document paths (corner-prober 2):** `rootQualify` now encodes each segment of the document path, so a `#`, `?` or `%` in a directory name stays part of the path.
- **Abbreviated names (stylist 1–2):** `BLOB_ID_RE` → `BLOB_ID_PATTERN`, `MARKER_RE` → `MARKER_PATTERN`, `n` → `name`.
- **New tests:**
  - Serving round trips for file names with `%`, spaces, `#` and non-ASCII.
  - The inherited-key 404s.
  - A failing read that neither rejects nor aborts a sweep.
  - `rootQualify` per-segment encoding.
  - A new `test/git-remote/git-backend.test.ts` for the spawn failure; it fails without the fix.

**`a88c2ed` docs**
- **`DEPLOYMENT.md`** has a new "Served clip" section (integrator 4, migrator 1–3):
  - a table of the six new environment variables;
  - deploy order — `parse5` ships inside the app artifact, which `deploy-app.sh` installs with `npm ci --omit=dev`, so no separate install step is needed;
  - a note that rolling back loses each partition's content-root record (the git data is safe);
  - the change to `destroy`.
- **`git-remote-partition.sh`:** the `status` usage text now lists every field it prints (archivist 1).
- **Primer:** the section on references not pinned to a deployment is cut down to a summary that points to the design (pruner 4).
- **Design § 12:** a build-status note says the build takes each recommendation, pending the maintainer's review (integrator 2).

**PR body (integrator 1 and 3, pruner 1–3):** it now states plainly that this PR depends on #177 and stays draft behind it. It marks the PR as `deliverable` except for the missing headless-browser test, and the Choices, What changed and Tests sections are much shorter.

**Testing:** `tsc --noEmit` passes, and `npm test` has 1 failure out of 1039. That one is `capability.test.ts`, "propagates a git failure rather than reporting the ref absent". It fails the same way on the unmodified head, in a separate worktree with `TMPDIR=/tmp`, so it comes from this host's environment, not the change; it passes in CI.

**Not done, deliberately:**
- Stylist 3 (`req`/`res`): left as is to match the surrounding Express code, as the stylist itself suggested.
- Pruner 5: I kept the primer's "run exactly one process" line, because the operator is the one who has to enforce it.
- Several items marked comment-only by the jurors.
- The headless-browser coherence test: still an open gap, now stated in the PR body.

Follow-up: the panel-2 stage, which the driver posts.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4573601 cached reads)
- Output: 22520 tokens
- Cost: $2.356352199999999
- Wall-clock: 1048s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
