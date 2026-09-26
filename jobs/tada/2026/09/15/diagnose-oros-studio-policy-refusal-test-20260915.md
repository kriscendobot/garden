# Diagnostic report: `policy-refusal-quarantine-test.sh` failure on `oros-studio-garden-ce242c49`

## Root cause (one line)
The test hardcodes its temp-dir base as `$(dirname "$HOME")`. On this host `$HOME=/Users/dom/garden`, so that resolves to **`/Users/dom`**, which is **root-owned (`drwxr-xr-x root:root`) and not writable** by the bot user (`dom`, uid 501). `mktemp -d` fails and the script aborts `rc=1` before the substantive subtests run. It is a **platform/portability bug in the test's temp-base assumption**, not a defect in the quarantine logic.

## 1. Complete test output (deployed root, both runs identical)
```
SUBTEST 1 — CLASSIFIER: is_provider_policy_refusal_text
  PASS: classifier matches provider refusal envelopes, rejects benign prose and quota caps
  PASS: file classifier finds a refusal across a multi-megabyte transcript after the compact tail loses it
mktemp: failed to create directory via template ‘/Users/dom/.garden-policy-refusal-test.XXXXXX’: Permission denied
=== EXIT RC=1 ===
```
The two classifier assertions (SUBTEST 1) pass; the script then dies at line 88 (`TR="$(mktemp -d "$(dirname "$HOME")/…")"`) — the bare-journal reaper fixture — so SUBTESTs 2 (GARDENER), 3 (QUARANTINE) and 4 (NOTICE) never execute.

**Proof the logic is otherwise green here:** I ran a patched copy (identical, only the temp base pointed at a writable dir, reading the deployed fixtures read-only) → **`5 passed, 0 failed`, rc=0**. All four subtests pass on Linux/aarch64; the sole failure is the unwritable temp base.

## 2. `uname -a`
```
Linux oros-studio-garden-ce242c49 7.0.12-linuxkit #1 SMP PREEMPT Thu Aug 27 14:02:21 UTC 2026 aarch64 aarch64 aarch64 GNU/Linux
```
Note the nuance vs. the job's expectation: the **container** is **Linux/aarch64** (Docker Desktop `linuxkit` VM), running on an Apple-Silicon **macOS host**. The bug is not macOS syscalls — it's the container's home layout: home is relocated to `/Users/dom/garden` to mirror the host path, and its parent `/Users/dom` is root-owned/unwritable, unlike a stock Linux fleet host where `$HOME=/home/<bot>` and `dirname=/home` is writable+exec.

## 3. Hand-patches on this host: **none found**
The deployed root is a **clean detached checkout at `1110195c4fd1`** (behind main2 tip `c4bc9694`). I diffed the deployed tree against a clean worktree — every differing file is the **pending-upgrade delta** (e.g. `gh-credential-guard.sh`, `no-nul-bytes.sh` are new-in-main2, not-yet-deployed), not a local edit. Nothing was hand-patched to get the gardener pool running; the pool is running from an unmodified older checkout.

## 4. Reproducibility: **fully reproducible, not a flake**
Two consecutive runs produced byte-identical output and `rc=1`. It is a deterministic platform issue.

## What needs upstreaming into main2
- The bug is present **at main2 tip**, not just the deployed commit (`git log` shows no commit touched this file in `1110195..c4bc9694`).
- **7 tests** share the `$(dirname "$HOME")` antipattern and will all fail on this host: `policy-refusal-quarantine-test.sh`, `comment-watcher-test.sh`, `detect-quota-resets-test.sh`, `inbox-coalesce-test.sh`, `provider-quota-backoff-test.sh`, `triager-test.sh`, `watchdog-notice-dedup-test.sh`. Of the six-test deploy gate (`deploy-garden.sh:102` `GARDEN_DEPLOY_TEST_SUITES`), only `policy-refusal-quarantine-test.sh` uses it — hence the single gate failure — but the other six would fail if ever run here.
- The deploy gate (`deploy-garden.sh:345`) invokes each suite **directly** (`bash "$gate_root/$suite"`), bypassing `run-test.sh`, which is why they don't inherit a safe base.

**Recommended fix:** replace the hardcoded `$(dirname "$HOME")` base with the exec-capable, writable-base probe that `run-test.sh` (lines 50–58) already implements — candidates `GARDEN_TEST_TMPDIR`→`TMPDIR`→`/var/tmp`→`/tmp`→`$HOME`, taking the first that is writable **and** exec-capable, falling back to `$HOME`. Best factored into a small shared helper the standalone tests source. Do **not** just switch to `/tmp`: several of these siblings write executable fixtures and this container's `/tmp` is `noexec` (documented in `run-test.sh`); `$HOME` (`/Users/dom/garden`) *is* writable here and is the correct fallback.

No repository changes were made (diagnostic-only job). A follow-up `fix` job applying the `run-test.sh`-style base probe to those 7 tests would unblock the deploy gate on this and future macOS/ARM hosts.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/diagnose-oros-studio-policy-refusal-test-20260915.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (812690 cached reads)
- Output: 18134 tokens
- Cost: $1.428655
- Wall-clock: 246s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
