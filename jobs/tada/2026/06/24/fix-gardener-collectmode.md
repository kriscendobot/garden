I'm blocked: every write path to `/home/kris/scripts/systemd/garden-gardener@.service` (Edit, Write, and a Bash/python in-place edit) is being gated by the permission system and not granted, so I cannot apply the edit, commit, re-render, reload, or restart the unit. I'll report the diagnosis and the exact, ready-to-apply fix faithfully rather than claim completion.

----- COMPLETION REPORT: fix-gardener-collectmode -----

**Status: BLOCKED — fix identified and verified by inspection, but not applied (write permission denied).**

**Diagnosis (confirmed):**
- `scripts/systemd/garden-gardener@.service` line 9 has `CollectMode=inactive-or-failed` inside the `[Service]` section. `CollectMode=` is a `[Unit]` directive, so systemd ignores it and logs the warning quoted in the job.
- Grepped all 12 `scripts/systemd/*.service` files for `CollectMode`. **Only `garden-gardener@.service` contains it** — no other unit templates have the same misplacement. (The other `@`-templated units — `garden-driver@`, `garden-triager@`, `garden-watcher@` — do not set `CollectMode` at all.)

**Exact fix needed (one file, move one line):**
```
 [Unit]
 Description=Garden gardener worker %i
 # A consumer in the worker pool. Scale by enabling instances @1..@N.
 After=default.target
+CollectMode=inactive-or-failed

 [Service]
 Type=exec
 Slice=background.slice
-CollectMode=inactive-or-failed
 Environment=GARDEN_ROOT=@GARDEN_ROOT@
```

**Could not complete:**
- File edit — Edit, Write, and a Bash python in-place edit all returned "requires approval / haven't granted it yet"; no grant arrived after retries.
- Therefore the remaining steps were not run: `scripts/jobs/install-units.sh install`, `systemctl --user daemon-reload`, `systemctl --user restart garden-gardener@1.service`, journal verification, and the main2 commit (bot identity). No shellcheck was needed since no shell script was modified (the change is confined to a `.service` template).

**Follow-up to finish the job once write access is available:**
1. Apply the one-line move above to `scripts/systemd/garden-gardener@.service`.
2. `scripts/jobs/install-units.sh install && systemctl --user daemon-reload && systemctl --user restart garden-gardener@1.service`, then confirm `journalctl --user -u garden-gardener@1.service` no longer logs `Unknown key name 'CollectMode'`.
3. Commit to `main2` under the bot identity and record the SHA.

No deliverable SHA or daemon-reload confirmation can be reported because the write was blocked.
