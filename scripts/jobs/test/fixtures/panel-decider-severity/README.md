Seat blocks for `panel-decider-severity-test.sh`. Each file is ONE seat's verdict
block, deliberately labeled `request-changes` so the fixture tests the decider's own
severity classification rather than the seat's label. The filename prefix is the
expected disposition: `nit-*` must pass, `defect-*` must stay must-fix. Rubric:
`decider_rubric` in `scripts/jobs/gardening/panel.sh`, documented in
`skills/panel/SKILL.md` § Finding severity.
