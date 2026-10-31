Implemented and pushed [PR #1589](https://github.com/endojs/endo-but-for-bots/pull/1589) at `a7eb50d6f8`.

- Added confined Git workspace tools for Lal and centralized reader/writer attenuation in `@endo/agent-tools`.
- Reused the shared provisioner in Fae and removed the unconfined `FAE_CWD`/`setup-fs-tools` route.
- Documented that Genie was already retired; no runtime adapter was recreated.
- Updated exports, types, changesets, documentation, design status, and regression tests.
- Pre-push gates and affected Agent Tools, Fae, and Lal suites passed; mutation testing confirmed the Lal writer regression test detects lost writer authority.
- CI reached 33/36 green within the one-hour bound; three platform test jobs remain pending, with no failures.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `deaf3d9e2ecccb10f68904dc5fbbeb194c01a76b`; this job presented `a7eb50d6f8f99bd6d5c455c43a69c6a255dc534f`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-capability-lal-genie-agent-adapters.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 7145s

<!-- garden-usage-end -->
