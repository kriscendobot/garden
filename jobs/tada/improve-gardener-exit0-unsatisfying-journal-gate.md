## Completion report

**Job:** improve-gardener-exit0-unsatisfying-journal-gate

**What I did.** In `scripts/jobs/gardener.sh`, the exit-0-unsatisfying requeue branch now gates the SHARED-journal `kind:progress` emission on `cycle >= 2` (a repeat) instead of firing on the earliest requeue cycles. The local `log "..."` line stays **unconditional** so operators keep full journalctl/systemd visibility on every cycle, including cycle 1. I rewrote the adjacent comment block to record the new "silent-until-repeat" rule and explicitly that **cycle-1 transients log locally only** (benign quota/API/clean-but-unfinished blips the reaper requeues silently and only escalates to POISON after `GARDEN_REAP_POISON_THRESHOLD` cycles).

**What changed.** One commit (`26c24009d`), pushed to `main2` via a rebase-CAS loop. `bash -n` passes.

**Non-trivial context — concurrent peer overlap.** A peer commit (`8728deb3a`) landed on this *exact* branch ~2 minutes before I claimed, restructuring the same emission to gate on `cycle >= poison_threshold-1` (near-poison only) — **stricter** than this job's requested `cycle >= 2`. The job spec was written against the older unconditional-emission code and predates that landing. I implemented the job as specified (honoring its explicit "keep diagnostic behavior for repeats" intent — a deterministic repeat at cycle 2 is worth an early note, distinct from a one-off blip) and **preserved** the peer's "ABOUT TO ESCALATE as poison" wording as a sub-flag when `cycle >= threshold-1`. Net effect vs the prior HEAD: journal notes for cycles 2..threshold-2 (e.g. 2–3 at the default threshold 5) are reintroduced, which the peer had suppressed. The reaper remains the authoritative poison-escalation signal in all cases.

**Follow-up.** I messaged the maintainer flagging this overlap: this change is looser than `8728deb3a`'s silent-until-poison stance, and if they prefer the stricter near-poison-only gate I offered to revert. No action is required unless they want the stricter policy — their reply will route back as a fresh job.
