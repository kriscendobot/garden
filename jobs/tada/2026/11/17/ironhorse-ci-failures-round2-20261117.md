orchestration-status: complete-with-failures
failed-children: ironhorse-ci2-1621-drift-20261117 ironhorse-ci2-1359-20261117
recovered-children: ironhorse-ci2-refresh-1298-1534-20261117 ironhorse-ci2-flake-reruns-20261117
# orchestration ironhorse-ci-failures-round2-20261117 — complete

All 5 children reached a terminal state (parallel).
2 child(ren) FAILED: ironhorse-ci2-1621-drift-20261117 ironhorse-ci2-1359-20261117

Child dispositions:
- ironhorse-ci2-1621-drift-20261117: failure detected
- ironhorse-ci2-1359-20261117: failure detected
- ironhorse-ci2-refresh-1298-1534-20261117: recovered after transient failure; clean tada report present
- ironhorse-ci2-flake-reruns-20261117: recovered after transient failure; clean tada report landed after the orchestration finished
- ironhorse-ci2-1346-1299-20261117: tada report present; no machine-readable failure declaration detected

---

RECOVERED 2026-11-17T12:26:02Z: 1 child(ren) reported FAILED above have since reached a
clean tada (no gated-failure declaration); the failure reading was transient
and is superseded:

- ironhorse-ci2-flake-reruns-20261117

Still failed: ironhorse-ci2-1621-drift-20261117 ironhorse-ci2-1359-20261117
