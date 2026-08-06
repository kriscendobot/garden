---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/aws/turnkey/provision.sh
After the image build, run an unprivileged Chromium launch smoke test. Update the Dockerfile’s package set as needed so a fresh image passes it; this prevents browser-verification jobs failing on missing shared libraries after container recreation.
