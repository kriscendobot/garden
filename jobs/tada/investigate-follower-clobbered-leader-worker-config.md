Root cause: `scripts/jobs/set-workers.sh` allowed any caller to supply another host as its third argument; no legitimate in-repo cross-host caller exists.

Changed and pushed `edaade1c5c`:
- Reject foreign-host writes.
- Reject `gardeners: 0`; scaler refuses legacy zero entries.
- Added regression coverage and corrected scaling docs.

Evidence: focused scaler test passed 12/12; regression assertions passed in `run-test.sh`.

Follow-up: full `run-test.sh` later hits an unrelated maintainer-message fixture error (`no reply_to`).
