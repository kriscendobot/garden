---
created: 2026-09-28
updated: 2026-09-28
author: gardener
---

# The Ironhorse test262 ratchet gate

`scripts/jobs/ironhorse-test262-ratchet-gate.sh` decides, deterministically and
without a model, whether a whole-corpus Ironhorse test262 sweep
(endojs/endo-but-for-bots, `rust/engine/ironhorse-262`) keeps the coverage floor.
A ratchet watcher consumes its JSON verdict; a person can run it by hand.
It exists because a 2026-09-28 comparison against `baseline/refresh-20260904`
reported 906 lost paths that were mostly a stricter runner classifier, not engine
regressions. A raw path diff cannot tell those apart, so the gate refuses to
compare measurements that were not classified the same way.

## Pin a floor

```sh
G=scripts/jobs/ironhorse-test262-ratchet-gate.sh
$G pin --from-report <sweep>/report.json --project-git <ebfb checkout> --out <pin-dir>
$G pin --from-baseline rust/engine/ironhorse-262/baseline/refresh-<date> \
  --project-git <ebfb checkout> --out <pin-dir>
```

A pin is `pin.json` plus a byte-sorted `covered.txt`. It records what a later
sweep must share to be comparable:

- test262 and oracle pins, runner, oracle and SES modes, and scope;
- every `run_id` parameter except `endo`, so `case-timeout` and the batch cap
  are included;
- the category vocabulary and the total case count;
- a classifier fingerprint: the git blob ids of the runner's verdict sources
  (`full-run.sh`, `endot_ih.rs`, `report.rs`, `xst.rs` by default; override
  with `--classifier-path`) at the measured `endo_sha`.

Only a complete, `corpus_verified`, whole-corpus sweep can be pinned.

To move the floor deliberately (for example after a classifier change), pin the
new measurement with `--supersedes <old-pin-dir> --note "<decision, who
authorized it>"`. The new `pin.json` then lists every old covered path the new
floor drops, with its new category and reason, so the dropped paths stay on
record for follow-up. The gate does not decide whether a reconciliation is
authorized; the maintainer does, and the watcher's configuration names the
enforced pin.

## Check a sweep

```sh
$G check --pin <pin-dir> --report <head>/report.json --project-git <ebfb checkout> \
  [--require-growth] [--record <file>]
```

It prints one `ironhorse-test262-ratchet-gate/1` record:

| verdict | exit | meaning |
| --- | ---: | --- |
| `pass` | 0 | comparable, zero pinned covered paths lost (and at least one gained with `--require-growth`) |
| `fail` | 1 | comparable, but a pinned path was lost, or nothing grew |
| `incompatible` | 2 | the classifier, corpus, oracle, run parameters, vocabulary, or case count differ; the path diff appears only as `informational_diff` |
| `error` | 3 | an input is missing, unreadable, or internally inconsistent (for example a tampered pin or a summary that disagrees with its cases) |

Consumers must act on `verdict == "pass"` only. The record also carries the
measurement's `endo_sha`, report sha256, covered count and sha256, and every
lost path with its new category, outcome, and reason.

## Reading an incompatible verdict

The 2026-09-28 round-3 data gives an example. The historical `refresh-20260904`
floor against the `llm@47f6965d88` branch-point sweep is `incompatible` for three
reasons: the new `case-timeout=60` run parameter, the new `refused` category, and
changes to all four classifier sources. The informational diff still shows the
906 paths (443 `ironhorse-aborted-limit`, 397 `shared-positive-test-failure`, and
66 others). A branch-point pin gives the post-fix head `9df05366b3` a `pass`
(+74 gained, 0 lost). Crank PRs that change only the engine keep the fingerprint.
A crank that edits a verdict source comes back `incompatible`, and a maintainer
has to re-pin it.

Tests: `scripts/jobs/test/ironhorse-test262-ratchet-gate-test.sh`.
