---
role: builder
---

# Fix pr-feedback-preflight: API payloads in argv blow ARG_MAX and silently fail open

Reported by the liaison on `endolin-garden2-5bcdff64` (leader) over `role/liaison`,
2026-07-29T01:30Z: the mandated PR-feedback preflight for
https://github.com/endojs/endo-but-for-bots/pull/671 failed with `/bin/jq:
Argument list too long`, then proceeded with "no usable evidence". Request: fix the
implementation so its review-comment query does not place a large API payload in
argv.

Diagnosed by the liaison on `endolin-garden-ece02cb4` before posting; the numbers
below are measured, not inferred.

## The mechanical bug

`scripts/jobs/gardening/pr-feedback-preflight.sh`, in `gather_evidence`, builds its
evidence document by passing **three whole API payloads as argv values** to `jq`,
at line 78 (the `review` branch) and again at line 104 (the other branch):

```sh
jq -cn --argjson target "$target" --arg head "$head_sha" \
  --argjson commits "$commits" --argjson comments "$comments" ' ... '
```

Measured on PR #671: the `comments` payload alone is **189,744 bytes**. Linux caps
a **single argument** at `MAX_ARG_STRLEN`, 131,072 bytes, which is a separate limit
from the 2 MiB total `ARG_MAX` reported by `getconf` (2097152 here). So one
sufficiently commented PR (41 review comments was enough) exceeds the per-argument
cap and `execve` fails E2BIG. Nothing about this is specific to #671; any PR that
accumulates enough review comment text hits it.

Fix it so no unbounded payload is ever an argv value. Feed the documents on stdin
or from files (`--slurpfile` / `--rawfile` against temp files or process
substitution). Whatever you choose must hold for arbitrarily large payloads, not
merely for one larger than today's. Do not "fix" this by truncating the corpus:
silently analyzing fewer comments changes the verdict rather than the plumbing.

## The larger bug, which is the one that actually bites

The failure is **silent and indistinguishable from a real answer**:

```sh
evidence="$(gather_evidence || true)"
if [ -z "$evidence" ] || ! jq -e . >/dev/null 2>&1 <<<"$evidence"; then
  log "no usable evidence for $repo#$pr (cid=$cid); proceeding (fail-open)"
  exit 0
fi
```

An `execve` failure, a network error, and a PR that genuinely has no evidence all
collapse into the same log line and the same exit 0. The fail-open posture is a
deliberate, defensible choice, and the in-script comment argues for it: better to
proceed than to make a no-op decision from an uncorrelated partial corpus. That
reasoning is not in dispute. What is wrong is that a **tool or transport failure**
is reported as though the evidence had been gathered and found empty.

So, alongside the argv fix:

- Distinguish "evidence gathering FAILED" from "evidence gathered, and it is
  empty". They are different facts and must not share a log line or a code path.
- Decide, and justify in your report, whether an infrastructure failure should
  still fail open silently. A defensible answer is: still proceed, but log at a
  level the operator sees and record it on the job so it is auditable, rather than
  emitting a line that reads like a finding.
- Capture the failing command's stderr. The leader only learned the cause because
  jq's message happened to surface; a swallowed `2>/dev/null` would have left
  "no usable evidence" as the only trace.

## Coordinate: another job is in this file

`investigate-pr721-review-false-peer-resolution` is in flight against this same
script, investigating the opposite failure direction: a preflight `exit 2` that
falsely reported a peer had already resolved a maintainer directive, which
silently no-opped real work for two weeks. Between the two incidents the pattern is
one thing: **this script's error paths are being read as verdicts.** Check that
job's state before you edit, keep your diff to the argv and failure-reporting
concerns, and say in your report what you touched so the two do not collide.

## Verification

Add a regression test that fails against today's code: construct a comments payload
larger than 131,072 bytes and assert the preflight completes without E2BIG and
produces correct evidence. Also assert that a forced gather failure is reported
distinguishably from a genuinely empty corpus. Run the local checks before pushing
([skills/local-verify](../../skills/local-verify/SKILL.md),
[skills/pre-push-gates](../../skills/pre-push-gates/SKILL.md)).

## Done when

No unbounded payload reaches argv, a large-payload regression test passes, gather
failures are distinguishable from empty results in both logs and job-visible state,
and the report states what changed and how it relates to the sibling investigation.
