# Velocity

Observed PR-merge velocity inputs and the S/M/L/XL → day mapping the roadmap
projection uses. Recalibrated weekly by the Sunday-evening recalibration job
(`skills/velocity-recalibration`); `scripts/jobs/plan/render.sh` reads the day
mapping below for the per-milestone "remaining days" rollup.

**Review-queue latency is a single garden-wide timeline input** — one figure feeds
every milestone projection regardless of which repository its designs target.

## Day mapping

The day mapping carried from the endo v1 calibration (recalibrated 2026-03-02 from
observed one-developer velocity; S left at 1 day, M at the 1.2× bump, L relaxed to
1.3×, XL at 1.3×). Format: `<SIZE>: <days>` (read by the renderer).

```
S: 1
M: 3
L: 8
XL: 15
```

## Size categories (reference)

| Size | LOC impact | Duration (1 dev) | Description |
|------|------------|------------------|-------------|
| S  | < 500      | ~1 day      | Localized changes, single subsystem |
| M  | 500–1500   | 2–3 days    | Multiple files, moderate complexity |
| L  | 1500–3000  | 1–1.5 weeks | Architectural changes, new subsystems |
| XL | > 3000     | 2–3 weeks   | Cross-cutting, platform-specific, or research-heavy |

## Latency

```
review-queue-latency-days: 2
```

A single garden-wide figure (not per-repository). The weekly job recalibrates it
from the week's merged-PR cadence.
