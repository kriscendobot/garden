once: 2026-09-12T02:55:00Z
job_basename_prefix: rebrake-foreman-before-reset
---
Re-engage the foreman brake before the weekly quota reset (Friday 8pm Pacific / 2026-09-12T03:00:00Z), per the maintainer's directive (kriskowal, 2026-09-11): the brake was released at 2026-09-11T22:46:21Z and should be pulled again before this deadline.

Run:
```
scripts/jobs/brake-foreman.sh on 'maintainer: re-engage before Friday 8pm Pacific weekly reset (scheduled 2026-09-11)'
```

Confirm the brake is actually set afterward (`scripts/jobs/brake-foreman.sh status`) and report the result.
