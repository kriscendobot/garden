---
role: shepherd
---

Shepherd endojs/endo-but-for-bots PR #655 ("feat(daemon): mount grep, PR C of #127", branch `feat/mount-grep`, stacked on green #653) to CI green: the four `test` jobs (22.x/24.x × ubuntu/macos-15) are failing while its base is passing, so drive the grep feature's own test failures to resolution — the next unblocked step of the M3 daemon-mount stack.
