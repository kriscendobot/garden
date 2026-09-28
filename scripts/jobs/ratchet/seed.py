#!/usr/bin/env python3
"""Seed only the specific September 28 delegation; never overwrite a revocation."""
import datetime
import json
import os
import subprocess
import sys
from pathlib import Path

from policy import AUTHORIZATION, CONFIGURATION, MARKER, REPOSITORY, STATE, digest, require

journal = Path(sys.argv[1])
configuration = journal / CONFIGURATION
require(not (journal / f'{CONFIGURATION}.revoked').exists(), 'delegation revoked')
if configuration.exists():
    require((journal / STATE).is_file(), 'existing delegation has no state')
    sys.exit(0)
authorization = (journal / AUTHORIZATION).read_bytes()
branch_point = '47f6965d882b9c1c3eaaa836dd8d75971a924bb4'
floor_path = 'rust/engine/ironhorse-262/baseline/refresh-20260904/covered.txt'
floor = subprocess.check_output([os.environ.get('GARDEN_GH', 'gh'), 'api',
                                '-H', 'Accept: application/vnd.github.raw+json',
                                f'repos/{REPOSITORY}/contents/{floor_path}?ref={branch_point}'])
require(len(floor.splitlines()) == 30233, 'unexpected seed floor')
record = dict(schema=1, status='active', authorized_by='kriskowal', authorization=AUTHORIZATION,
              authorization_sha256=digest(authorization), repository=REPOSITORY,
              base='llm', author='kriscendobot', marker=MARKER)
state = dict(schema=1, crank=3, crank_date='20260928', corpus='be13516fb6441b950ba8a3df97eb34062c186972', builder='ironhorse-test262-ratchet-round3-20260928',
             branch_point=branch_point, floor=dict(revision=branch_point, path=floor_path, sha256=digest(floor)),
             queue=[], actions={}, last_progress=datetime.datetime.now(datetime.timezone.utc).isoformat())
for path, value in ((configuration, record), (journal / STATE, state)):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')
