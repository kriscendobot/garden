---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/gardening/pre-push-gates/probes/spell-out-identifiers.sh`
runs `set -uo pipefail` (line 63). Its `is_exempt` function (line
179-186) checks the per-file escape hatch as:

    printf '%s\n' "$content" | head -5 | grep -q 'spell-out-exempt'

Under pipefail, `head -5` and `grep -q` can both exit early once they've
read/matched enough, sending SIGPIPE back up to `printf` for a long file
— the classic head|grep -q SIGPIPE pipefail gotcha. The practical effect:
`is_exempt` can spuriously return false even when the `spell-out-exempt`
marker genuinely sits within the first 5 lines, meaning the probe fails a
file that legitimately opted out.

Grounding: found on the `endojs/endo-but-for-bots` PR #1014 fix round;
reproduce with `packages/cli/test/http-mk-command.test.js`.

Fix `is_exempt` to not depend on a head|grep pipeline that can SIGPIPE its
upstream under pipefail — e.g. read the first 5 lines directly (`head -5
<<<"$content" | grep -q ...` avoids the printf-into-pipe SIGPIPE path
since here-string doesn't have a writer process to kill, or mask the
expected SIGPIPE exit explicitly, or use a pure-bash line-count loop).
Add a regression test with a long file whose exempt marker sits in the
first 5 lines, matching the PR #1014 repro shape, so this can't silently
regress. Check the other probes in that same directory
(`no-inline-import-jsdoc.sh`, `typedefs-belong-in-dts.sh`,
`prefer-endo-primitives.sh`, `typist-friendly-code-points.sh`) for the
same pipeline shape — if any share this exact escape-hatch pattern, fix
them too rather than leaving a known-bad pattern in sibling probes.
