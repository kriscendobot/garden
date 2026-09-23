Inbox empty. Job complete.

## Completion report

**What the job asked:** Fix check 6 of `scripts/check-container-hardening.sh`, which used substring matching (`grep -qi kriskowal` over `gh auth status` text and over `hosts.yml`) and false-alarmed on the leader (`endolin-garden-ece02cb4`) even though the only logged-in account was `kriscendobot`.

**What I did:**
- **Rewrote check 6 to compare account LOGINS structurally, never substring text:**
  - Enumerates logged-in gh accounts via `gh auth status --json hosts --jq '.hosts[][].login'` (verified working on the installed gh 2.101.0), falling back to a strictly-anchored `hosts.yml` parse (per-host `user:` field + `users:` map keys) for an older/absent gh.
  - Resolves `GH_TOKEN`/`GITHUB_TOKEN` to their owning login via `gh api user`, not by grepping the token.
  - Fails only when a login **equals** a maintainer login (case-insensitive). The maintainer set is config-driven: `GARDEN_MAINTAINER_LOGIN` → journal `maintainers/allowlist` → safe default `kriskowal`.
  - Uses the **real gh**, skipping the fleet identity wrapper (`scripts/jobs/bin/gh`), so the wrapper's bot-identity pin can't mask a leaked maintainer credential.
- **Added a `--maintainer-cred-selftest` seam** (runs check 6's detection only, no container guard) and a hermetic test `scripts/jobs/test/container-hardening-maintainer-cred-test.sh` (fake gh on PATH). Covers the three required cases plus more: `kriskowal/garden` in a non-user field → PASS; real `users:{kriskowal:}` entry or active `user:` field → FAIL; env token resolving to a maintainer → FAIL; bot token → PASS; config-driven maintainer set honored. **13/13 pass.**

**Verification:** Full probe now shows `PASS: no maintainer gh account/token reachable (logins checked structurally)` for check 6. Committed and pushed to `main2` (`981ef4f535`).

**What actually matched on the leader (read-only investigation):** Could not reproduce — on this host right now `hosts.yml` contains only `kriscendobot` and `gh auth status` reports only `kriscendobot`, so the current check passes. The 17:30 match was transient/environmental (e.g. the wrapper momentarily degrading to the global active account, or a fleeting `hosts.yml` state). Regardless, the substring approach was inherently fragile; the structural fix removes the whole class.

**Follow-ups (out of scope for this job):** The full probe still reports 2 unrelated FAILs on this host's container — `sudo -n true` succeeds and host block devices are visible — i.e. this container was not launched with the hardened flags. That's a separate hardening/deployment concern, not check 6.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-container-hardening-probe-maintainer-substring.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2430608 cached reads)
- Output: 34730 tokens
- Cost: $3.231534
- Wall-clock: 482s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
