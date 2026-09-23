Inbox empty. The job is complete.

## Completion report

**Deliverable:** `designs/mirror-operator-messages-to-maintainer-inbox.md` — a design for mirroring operator-directed host state into the maintainer inbox.

**What I did**
- Researched the actual mechanics before designing: the `watchdog-notice.sh` coalescing path and `alert_maintainer`/`alert_maintainer_edge`/`_clear` (`common.sh`), the host-local drain marker and its `source`/`set_by`/`reason` fields (`drain-fleet.sh`, `845b1895e2`), `publish_fleet_health` and the `fleet/health/<GARDEN>` record, the sysop's mutation-only closed vocabulary, and the adjacent `designs/sysop-attested-exec.md`.
- Wrote the design addressing all four required points:
  1. **Scope boundary** — a principled test (standing + remotely-actionable + not-already-surfaced) with the key insight that most host *faults* already push via `alert_maintainer`; the genuine gap is operator-*initiated* posture (the drain), which no fault-detector fires on. Included a disposition table for every candidate condition.
  2. **Mirror, don't flood** — reuses the existing `alert_maintainer_edge` → `watchdog-notice.sh` coalescing (one keyed entry per condition, `notice_count`/`first_seen`/`last_seen`, `--recovered` close), fingerprinted so a 13-hour drain yields one entry.
  3. **Race semantics** — idempotent `drain off`, one journal-shared notice keyed on the condition so either party's fix closes it for both, two stand-down signals, plus a proposed `lifted_by` breadcrumb for local-lift attribution.
  4. **Publish the drain reason** — extend `fleet/health` with `drain_*` fields; safe because the answering fields are self-derived enums/identifiers (unlike the deliberately host-local, targeting-sensitive capability cache), with the one free-text `reason` public-by-contract plus an opt-out.
- Explained composition with the attested-`exec` design (pull vs push, complementary).
- Included a non-empty `## Open questions` section (5 real maintainer decisions), so per the garden carve-out I landed it on `main2` **and** opened it as a review answer-surface PR.

**What changed**
- `main2` advanced to `06bf63bad2` with the design file (landed bare per the carve-out; content lives on `main2`).
- Frozen base `main2-611da01` and head branch `design-mirror-operator-messages-to-maintainer-inbox` pushed.
- Draft answer-surface **PR kriscendobot/garden#100** opened via `ensure-pr.sh` against the frozen base, marked `<!-- garden-design-open-questions -->`; verified diff is exactly the one design file.

**Note / minor process slip (no harm):** I first wrote the file to an absolute path in the deployed garden root instead of my worktree; I moved it into the worktree and removed the stray file. No git command ever ran in the deployed root, so journal sync was never at risk.

**Follow-ups:** none required from me — the design is implementable in the two increments it specifies once the maintainer answers the open questions on #100. Implementation was explicitly out of scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-mirror-operator-messages-to-maintainer-inbox-20260917.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3768272 cached reads)
- Output: 35181 tokens
- Cost: $6.108100999999999
- Wall-clock: 562s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
