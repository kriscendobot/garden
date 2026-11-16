orchestration-status: complete-with-failures
failed-children: ironhorse-ci-1-oracle-fix-20261116 ironhorse-ci-2-test-legs-20261116 ironhorse-ci-3-ironhorse-lanes-20261116
recovered-children: ironhorse-ci-4-remaining-20261116
# orchestration ironhorse-ci-failures-20261116 — complete

All 4 children reached a terminal state (serial).
3 child(ren) FAILED: ironhorse-ci-1-oracle-fix-20261116 ironhorse-ci-2-test-legs-20261116 ironhorse-ci-3-ironhorse-lanes-20261116

Child dispositions:
- ironhorse-ci-1-oracle-fix-20261116: failure detected
- ironhorse-ci-2-test-legs-20261116: failure detected
- ironhorse-ci-3-ironhorse-lanes-20261116: failure detected
- ironhorse-ci-4-remaining-20261116: recovered after transient failure; clean tada report landed after the orchestration finished

---

RECOVERED 2026-11-16T19:02:14Z: 1 child(ren) reported FAILED above have since reached a
clean tada (no gated-failure declaration); the failure reading was transient
and is superseded:

- ironhorse-ci-4-remaining-20261116

Still failed: ironhorse-ci-1-oracle-fix-20261116 ironhorse-ci-2-test-legs-20261116 ironhorse-ci-3-ironhorse-lanes-20261116
