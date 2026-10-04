## Fixed the § 4 app-compatibility check on kriscendobot/minion.town#147

I pushed the fix as one commit, **`190916636e6`**, to `design/mcp-resources-getting-started` through `safe-push-pr-head.sh`. It moved the head forward from `c340df22f8a` without force-pushing. The only file changed is `designs/mcp-resources-getting-started.md`, in the § 4 "App compatibility" paragraph (+18/−11).

**The defect:** the check compared the app commit A with R, the newest `main` commit that touched `resources/`. The paragraph said a forward `deploy-app.sh` always has R = A, but that's false when an app release changes `src/` and not `resources/`. In that case every ordinary forward deploy would log a false skew warning.

**The fix:** the check is now keyed on S, the commit each deployed copy was cut from, instead of R.
- **Both deploy scripts** write S into the copy as a `SOURCE_COMMIT` file. `deploy-app.sh` writes the app commit A it ships. `deploy-resources.sh` writes the `main` commit it builds its tarball from.
- **The rule** is now `git diff --quiet A S -- src/`.
- **A forward app deploy** has S = A, so it passes by construction whether or not that release touched `resources/`.
- **R stays** as the copy's name and still decides swap order through the ancestry check. The paragraph now says R tells you nothing about `src/`.
- **App rollback under a newer guide** is still the one allowed skew. `deploy-app.sh` checks the rule against the live copy's S after the swap step and logs a warning, the same as before. The skew still ends at the next forward app deploy or when the guide change is reverted.

I didn't touch the § 9 open questions, and I didn't stage a new gauntlet. Nothing else is outstanding: per the maintainer's instruction, merging #147 waits on their approval.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `8bed1aa498706c307f5804ca712a5a33fb2f5dff`; this job presented `190916636e601b61f6941b448838f8d71094d879`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr147-s4-key-fix-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (275598 cached reads)
- Output: 2848 tokens
- Cost: $0.4831356
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
