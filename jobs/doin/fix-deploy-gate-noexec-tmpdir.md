---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 7200
dispatch: automatic
---
# deploy-garden.sh: unpack the candidate gate somewhere EXEC-CAPABLE

`deploy-garden.sh`'s candidate test gate cannot pass on a host whose `/tmp` is
mounted `noexec`. Every deploy on such a host fails its own gate, permanently,
for reasons that have nothing to do with the candidate.

## Reproduction (2026-09-01, endolin-garden2-5bcdff64)

A deploy of `19913bbc70` was rejected:

    ERROR: candidate test gate rejected 19913bbc70…; failing suites:
      scripts/jobs/test/policy-refusal-quarantine-test.sh(rc=1)
      scripts/jobs/test/codex-policy-refusal-resume-test.sh(rc=1)

Both suites PASS in an ordinary worktree. The gate runs them differently
(`run_candidate_gate`, around line 216):

    gate_root="$(mktemp -d "${TMPDIR:-/tmp}/garden-deploy-gate.XXXXXXXX")"
    git -C "$GARDEN_ROOT" archive "$candidate" | tar -x -C "$gate_root"
    …
    timeout … env GARDEN_TEST=1 bash "$gate_root/$suite"

On this host `findmnt /tmp` reports `rw,nosuid,nodev,noexec,relatime` and
`TMPDIR` is unset, so the candidate is unpacked onto noexec storage. Any suite
that EXECUTES a script from that tree gets `Permission denied` / rc=126 — the
codex suite says so verbatim:

    FAIL: failed resume diagnostic was lost: …/handlers/cleric-codex.sh: Permission denied
    FAIL: terminal resume refusal exited 126

Proof it is the mount and not the code: an executable probe written into
`/tmp` is refused, the identical probe on the garden filesystem runs, and
re-running ALL FOUR gate suites from an exec-capable unpack gives
**43 assertions, 0 failures**:

    policy-refusal-quarantine-test.sh    rc=0   5 passed, 0 failed
    codex-policy-refusal-resume-test.sh  rc=0   7 passed, 0 failed
    empty-output-classifier-test.sh      rc=0  14 passed, 0 failed
    signal-kill-classifier-test.sh       rc=0  17 passed, 0 failed

The deploy only succeeded after a by-hand `TMPDIR=…/scratch/tmpexec` override.

## Why this is worse than one blocked deploy

The failure MASQUERADES as a code regression. It names two suites and a
candidate sha, so the natural reading is "main2 is broken" — and the deploy
correctly refuses. A host in this state simply stops deploying, with the reason
buried in a mount option.

That is very likely what the `root-repo-deploy-stalled-endolin-garden-ece02cb4`
watchdog was reporting on 2026-08-20: 18 commits behind, "has not advanced",
"investigate why none has landed". Check that hypothesis and say whether it
holds — if it does, that host has been undeployable for weeks and both hosts
need this fix.

## The fix, with an in-repo precedent

`ensure-project-worktree.sh` already solves exactly this, for exactly this
reason:

    # yarn 4's portable shell writes exec shims to $TMPDIR; a noexec /tmp makes
    # every yarn-run bin die with "permission denied" (agoric-sdk-local-build-env).
    # Point TMPDIR at an exec-capable scratch dir defensively.
    local tmpexec="$GARDEN_SCRATCH/tmpexec"

Give the deploy gate the same defence: unpack the candidate under an
exec-capable directory (`$GARDEN_SCRATCH` is on the garden filesystem and is
already proven exec-capable) rather than `${TMPDIR:-/tmp}`.

Do NOT simply set `TMPDIR` globally for the whole deploy — scope it to the gate
root, and keep the existing cleanup (`rm -rf "$gate_root"`) correct on every
exit path including the failure paths.

**Detect rather than assume.** Do not hardcode "always use scratch": probe
whether the chosen gate root is exec-capable (write a tiny script, chmod +x, run
it) and FAIL LOUDLY with a diagnostic naming noexec if no exec-capable location
can be found. A gate that silently cannot execute is the whole defect here; a
gate that says "my unpack directory is noexec" is a one-line diagnosis for the
next person.

## Definition of done

Landed on `main2`. A test in `tests/checks/` or `scripts/jobs/test/` pinning
that the gate root is exec-capable and that a noexec location is detected and
reported rather than producing bogus suite failures. Prove the test can fail
(mutate the guard, show it caught) and record that in the test header. Then
demonstrate a real `deploy-garden.sh` run passing its gate with NO `TMPDIR`
override, and cite the output.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-01T17:19:44Z
