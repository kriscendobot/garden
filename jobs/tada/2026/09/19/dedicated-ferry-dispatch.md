Inbox empty. All work is committed and pushed to `main2`.

## Completion report

Built the dedicated ferry dispatch mechanism (job `dedicated-ferry-dispatch`), moving the boatman's ferry off the generic job board and locking it out mechanically. Committed as `024f3a012a` and pushed to `origin/main2` (clean fast-forward).

### What I built

**1. `scripts/ferry.sh` — host-native loop (new).** Modeled on the repo-root `garden` launcher: a script the maintainer runs directly on the host, outside the container, with their own ambient git/gh session (no bot-identity pin, no `GARDEN_GH_IDENTITY`, never the fleet `gh` wrapper). It syncs its own throwaway journal clone (never touching the deployed root/`journal` repo — reads their remote read-only), watches `jobs/ferry/`, and for each pending directive: claims it (→ `doing/`, CAS push = double-dispatch guard, plus a `mkdir` host lock), dispatches `claude -p --dangerously-skip-permissions` (the flag shape from `monk-claude.sh`) wearing the boatman role, then archives to `done/` on genuine completion or records the failure in `doing/`. The prompt tells the agent to READ and WEAR `roles/boatman/AGENT.md` rather than re-inlining its safety steps, so every invariant (host preconditions, human-author/trailer-strip, per-commit `git -c` override, cross-link + `record-mirror.sh`, convention discovery) is re-triggered, not rewritten.

**2. Board lifecycle `jobs/ferry/`.** `<name>.md` (pending) → `doing/<name>.md` (claim stamp) → `done/<name>.md` (completion stamp, durable audit). A non-completing ferry stays in `doing/` for inspection — never silently retried or lost.

**Example directive** (`jobs/ferry/ebfb-387.md`):
```
---
downstream: kriscendobot/endo-but-for-bots#387
downstream_branch: feat-frozen-abc1234
upstream: endojs/endo
upstream_base: master
upstream_pr:
human: Kris Kowal <kris@example.com>
identity_switch_authorized: true
convention:
---
Ferry endojs/endo-but-for-bots#387 upstream to endojs/endo (base master).
```

**3. Mechanical lockout (deterministic guards, not doc-only):** `post-job.sh` refuses a `role: boatman` post; `claim-job.sh` refuses to claim one (alerts, leaves it visibly in todo, never silent-drops); `gardener.sh` refuses to run a claimed one (defense in depth). 

**4. Docs:** `roles/boatman/AGENT.md` (§ Dispatch + Job-inputs new home), `roles/liaison/AGENT.md` (ferry is staged to `journal/jobs/ferry/`, liaison can only queue not run), `CLAUDE.md` § The ferry + vocabulary row, `README.md` § The ferry, and `designs/dedicated-ferry-dispatch.md` (Status: Implemented, no open questions → lands bare) + index entry.

### Verification (real execution, not just review)

- **bash-3.2/BSD portability of `scripts/ferry.sh`:** `bash -n` and **`bash --posix -n`** both pass; an explicit grep confirms none of the forbidden constructs (associative arrays, `mapfile`/`readarray`, `${var,,}`, `date -d`, in-place `sed -i`, `readlink -f`) appear in code. I do **not** have a real Mac in the container, so this is static verification against the named 3.2/BSD constraints plus a full runtime exercise under the container's bash. End-to-end smoke tests (throwaway journal + fake `claude`) proved claim→doing→done with the audit trail, idempotent re-run (no double-dispatch), and the failure path (no marker → left in `doing/`).
- **Claim-path guard test:** `scripts/jobs/test/boatman-board-lockout-test.sh` (new, modeled on `project-pause-enforcement-test.sh`), 6/6 green — post refusal via `--role` and via body frontmatter, narrow guard lets non-boatman through, `claim-job.sh` skips the boatman board job while claiming a sibling, and with only the boatman candidate left the claim finds nothing (exit 3, job stays in todo). Note: the fleet's tests require `TMPDIR` outside the garden root and `GIT_CEILING_DIRECTORIES` unset (the existing baseline `project-pause-enforcement-test.sh` fails identically without that) — run with `env -u GIT_CEILING_DIRECTORIES TMPDIR=/tmp`.

### Notes / follow-ups

- **No in-flight ferry to migrate:** `grep -rl 'role: boatman' journal/jobs/` and `ferry` across todo/doin/plan returned nothing.
- The `garden-*` systemd units and `install-units.sh` were **not** touched: `scripts/ferry.sh` is intentionally host-run by the maintainer, not a fleet daemon. A follower/cron wrapper could be added later if desired (`--once` supports cron), but that's out of scope here.
- Pre-existing CLAUDE.md inventory drift (deslopper, american-english-normalization, etc.) is unrelated and identical to the origin/main2 baseline — my change introduced none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dedicated-ferry-dispatch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 114 tokens (9851940 cached reads)
- Output: 69052 tokens
- Cost: $8.78152
- Wall-clock: 1030s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
