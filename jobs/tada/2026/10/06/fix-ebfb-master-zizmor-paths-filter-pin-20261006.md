I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1427 to fix `master`'s red zizmor check, and zizmor passes on it. It isn't merged yet: it needs review and a maintainer merge, and the #1425 gauntlet re-run is parked until then.

**Cause.** `.github/workflows/ci.yml:270` pins `dorny/paths-filter@d1c1ffe0248fe513906c8e24db8ea791d46f8590 # v3`. I checked the tags on GitHub (`repos/dorny/paths-filter/git/matching-refs/tags`):
- `d1c1ffe…` is exactly `refs/tags/v3.0.3`.
- The floating `v3` tag now points to `0e4a8c6…`, which is v3.0.4.

zizmor's `ref-version-mismatch` check flagged the stale `# v3` comment and exited with code 13.

**Fix.** The pinned commit stays the same; I changed only the comment, from `# v3` to `# v3.0.3`. That matches the repo's full-version pin comments (e.g. `# v6.5.0`). It's a one-line diff in one commit, `1b1ead43c8`, on branch `fix/zizmor-paths-filter-pin-comment`.

**Verification:**
- **Locally:** zizmor 1.25.2, with the same settings the CI gate uses (`--persona pedantic --min-severity low .github/`), exited 13 on unmodified master and 0 with no findings after the change. `node scripts/update-action-pins.mjs --check-pins` also passes.
- **On #1427:** the `zizmor` check passed (run https://github.com/endojs/endo-but-for-bots/actions/runs/37397587754). The other CI legs were still running when I stopped watching.

**PR setup.** #1427 targets the frozen base `master-6ee3fda`, which is identical to `master`'s current tip (`ensure-pr.sh` won't open a PR against a bare `master`). The merge step moves it onto the live `master` before merging. The PR body follows the repo's template and carries the job marker.

**Follow-ups posted:**
- **Gauntlet for #1427:** `endojs-endo-but-for-bots-pr1427-gauntlet-20261006`, which takes it through review to un-draft. The merge itself still needs the maintainer.
- **#1425 re-run:** `regauntlet-ebfb-pr1425-after-zizmor-fix-20261006` is parked until #1427 leaves the board. It first checks that #1427 merged and that `master` now has `# v3.0.3`. If so, it runs `scripts/jobs/post-gauntlet.sh endojs-endo-but-for-bots-pr1425-gauntlet-<date> https://github.com/endojs/endo-but-for-bots/pull/1425`. If #1427 was closed without merging, it reports that the fix is still outstanding instead. #1425's own diff needs no change.

I made no changes to the garden repo.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-ebfb-master-zizmor-paths-filter-pin-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1077824 cached reads)
- Output: 8126 tokens
- Cost: $0.8328848000000001
- Wall-clock: 166s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
