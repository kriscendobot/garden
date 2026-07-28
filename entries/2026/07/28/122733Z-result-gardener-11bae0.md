---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T12:27:35Z
---
---
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/870
verdict: MERGE-NOW
---

# Dependabotany verdict on PR 870: openai 4.104.0 to 6.48.0, MERGE-NOW, held at the approval gate

Head reviewed `587225ef6adb8fb282f97ed9d602a9b7a34f91c2`, base `llm`. Verdict
**MERGE-NOW**, executed through `scripts/jobs/gardening/ci-wait-merge.sh`, which
confirmed CI green (`total=22 failed=0`) and then stopped at the maintainer
approval gate (`reviewDecision=none`, exit 1). The pull request is cleared to
land and waits on one approving review. Verdict comment:
https://github.com/endojs/endo-but-for-bots/pull/870#issuecomment-5104126992

Ledger consequence: **no embargo row and no deferred recheck**, because the
verdict is terminal rather than deferred. No one-shot recheck placed; the daily
`dependabotany-recheck-endo-but-for-bots` heartbeat already exists and is
untouched.

## Why MERGE-NOW, all four legs

1. **CI green.** 22 of 22 checks `completed`/`success` at the reviewed head,
   cross-checked via the per-commit check-runs API against the pull request
   rollup (identical name sets, 22 = 22, zero pending). Local verification
   beyond CI: `tsc` clean, `ava` 38 passed / 1 skipped.
2. **Maturity satisfied.** `openai@6.48.0` published 2026-07-17T02:44:58Z,
   more than 11 days before review, past the 2026-07-24T02:44:58Z floor.
   Nothing in the diff is 24-hour fresh.
3. **Source read surfaced nothing.** Zero runtime dependencies (against 7 in
   4.104.0), no `preinstall`/`install`/`postinstall`/`prepare` hook, `bin`
   dropped and unused here, no `eval`/`new Function`, no global or prototype
   mutation, license unchanged Apache-2.0. Installed with scripts disabled by
   construction: the repo sets `enableScripts: false` in `.yarnrc.yml`.
4. **Transitive set benign.** One version enters (`openai@6.48.0`, OSV clean and
   absent from the GitHub advisory database), 21 leave, 4 are rekeyed with
   byte-identical version and checksum, nothing new is introduced.

## Two findings worth carrying forward

**The "new releaser" notice decodes as a supply-chain improvement, not a risk.**
Dependabot flags that GitHub Actions published 6.48.0. Registry metadata shows
4.104.0 was published by a human npm account (`dschnurr-openai`, so a long-lived
token) while 6.48.0 came through npm trusted publishing over GitHub Actions OIDC
(`_npmUser.trustedPublisher.id = "github"`) and carries a SLSA provenance
attestation. A botanist meeting this notice should decode the publisher change
rather than reflexively treat it as a maturity signal against the release.

**Two greps that look like malware and are not.** `http://169.254.169.254` and
`http://metadata.google.internal` appear in `auth/subject-token-providers`; they
belong to three exported workload-identity federation providers, and the client
only constructs `WorkloadIdentityAuth` inside `if (workloadIdentity)`, a
constructor option this workspace never passes. `child_process.spawn` of
`ffplay`/`ffmpeg` lives in `helpers/audio`, an opt-in subpath nothing imports.
Both are unreachable here. Naming them explicitly so the next reviewer who runs
the same scan does not re-litigate them from scratch.

## Method note: differential execution beat reading on a two-major jump

The 4 to 6 jump crosses two majors, and the interesting question was whether
`packages/lal`'s single call-site survives. Rather than reason from the
changelog, a probe drove the real `makeLlamaCppProvider` against a local fake
OpenAI-compatible HTTP server and asserted on the request the wire actually saw
plus the parsed response, then **the same probe ran against `openai@4.104.0`**
installed separately. Both: 11 of 11 assertions pass, byte-equivalent wire
behavior (path, bearer, `max_tokens`, `model`, `tools`, `tool_calls` with
`type: "function"`, stringified arguments, response parse-back). That is
evidence, where a changelog read would have been an argument. The v6.0.0
breaking change is real but scoped to the Responses API, which `lal` does not
use; the v5.0.0 `node-fetch` to builtin `fetch` migration is what removes the
21 packages.

## Security posture change

The upgrade **removes** `form-data@4.0.5` (GHSA-hmw2-7cc7-3qxx, HIGH), which
openai v4 pulled in through `@types/node-fetch`. Calibrated honestly: that copy
had no runtime importer, so this is hygiene rather than repair of live exposure,
and the MERGE-NOW does not lean on it.

The separate `form-data@4.0.0` residue on `llm` (via `lerna` to `nx` to
`axios`, carrying GHSA-fjxv-7rqg-78g4 CRITICAL and GHSA-hmw2-7cc7-3qxx HIGH) is
untouched by this pull request and already tracked as its own job
`endojs-endo-but-for-bots-form-data-advisory`. Not re-raised.

## Version currency

`openai`'s `latest` dist-tag is now 7.0.0 (published 2026-07-27T21:56:56Z, less
than 24 hours before review), and 6.49.0 exists. This pull request targets
6.48.0 and `^6.48.0` will not float into 7.x. That is the correct outcome: 7.0.0
is exactly the hours-old major the maturity window exists to keep out. Expect a
7.0.0 Dependabot pull request later; it gets its own review.

## Supersession context

The peer botanist working https://github.com/endojs/endo-but-for-bots/pull/560
closed that pull request as a literal duplicate of this one and deferred the
deep work (scripts-disabled install, source read across the major boundary,
call-site compatibility) here. That deferral is now discharged.
