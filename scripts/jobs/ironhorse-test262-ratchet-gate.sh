#!/bin/bash
# ironhorse-test262-ratchet-gate.sh — deterministic pinned-baseline comparator for the
# Ironhorse test262 coverage ratchet. `pin` freezes a floor (pin.json + covered.txt,
# with a classifier fingerprint); `check` compares a whole-corpus report.json against it
# and prints one machine-readable gate record. Exit: 0 pass, 1 fail (a pinned covered
# path lost, or no growth under --require-growth), 2 incompatible (classifier, corpus,
# oracle, run parameters, vocabulary, or case count differ from the pin), 3 unreadable
# or inconsistent input. Logic and full usage: ironhorse-test262-ratchet-gate.py --help.
set -euo pipefail
exec python3 "$(dirname "${BASH_SOURCE[0]}")/ironhorse-test262-ratchet-gate.py" "$@"
