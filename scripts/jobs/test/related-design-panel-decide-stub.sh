#!/bin/bash
# related-design-panel-decide-stub.sh — a GARDEN_PANEL_DECIDE fixture for
# related-design-sensing-test.sh. panel.sh calls it as `<aggregate-file> <pr>` and
# reads the LAST token as the disposition. This stub always answers `pass` so the
# single-round panel terminates deterministically; the test asserts the pre-pass
# wiring (integrator forced, evidence delivered), not the disposition rubric.
# Committed because /tmp is noexec.
set -euo pipefail
echo pass
