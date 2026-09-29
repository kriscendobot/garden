#!/usr/bin/env python3
"""Container-safe tests. No OpenShell/Podman install or process is permitted."""
import contextlib
import hashlib
import io
import json
import os
from pathlib import Path
import subprocess
import tarfile
import tempfile
import unittest
from unittest.mock import patch

import pilot
import stages


class PilotTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="openshell-pilot-mock-")
        self.home = Path(self.temporary.name)
        self.environment = patch.dict(os.environ, {"XDG_STATE_HOME": str(self.home / ".local/state")})
        self.environment.start()
        self.home_patch = patch("pathlib.Path.home", return_value=self.home)
        self.home_patch.start()
        self.pilot = pilot.Pilot()
        self.pilot.initialize()
        self.output = contextlib.redirect_stdout(io.StringIO())
        self.output.__enter__()

    def tearDown(self):
        self.output.__exit__(None, None, None)
        self.home_patch.stop()
        self.environment.stop()
        self.temporary.cleanup()

    def test_container_refuses_every_live_command_before_state_or_process(self):
        for command in ("preflight", "install", "up", "test", "report", "down", "uninstall"):
            with self.subTest(command=command), patch("sys.argv", ["pilot", command]), \
                    patch.object(pilot, "in_container", return_value=True), \
                    patch.object(pilot.Pilot, "initialize") as initialize, patch("subprocess.run") as run:
                with self.assertRaisesRegex(pilot.PilotError, "HOST ONLY"):
                    pilot.main()
                initialize.assert_not_called()
                run.assert_not_called()

    def test_dry_run_cannot_install_start_or_write_state(self):
        for command in ("preflight", "install", "up", "test", "report", "down", "uninstall"):
            with patch("sys.argv", ["pilot", command, "--dry-run"]), \
                    patch.object(pilot.Pilot, "initialize") as initialize, patch("subprocess.run") as run:
                pilot.main()
                initialize.assert_not_called()
                run.assert_not_called()

    def test_real_container_entrypoint_refuses_all_live_actions(self):
        if not pilot.in_container():
            self.skipTest("actual container guard is exercised only in a container")
        entrypoint = Path(__file__).resolve().parents[1] / "openshell-pilot.sh"
        for command in ("preflight", "install", "up", "test", "report", "down", "uninstall"):
            result = subprocess.run([str(entrypoint), command], capture_output=True, text=True,
                                    env=dict(os.environ, PYTHONDONTWRITEBYTECODE="1"), check=False)
            self.assertEqual(result.returncode, 1)
            self.assertIn("HOST ONLY", result.stderr)

    def test_host_and_root_guards(self):
        with patch.object(pilot, "in_container", return_value=False), patch("os.getuid", return_value=0):
            with self.assertRaisesRegex(pilot.PilotError, "never root"):
                pilot.host_guard()
        with patch.object(pilot, "in_container", return_value=False), patch("platform.node", return_value="different-host"), patch("os.getuid", return_value=1000):
            with self.assertRaisesRegex(pilot.PilotError, "endolin-garden2"):
                pilot.host_guard()

    def test_all_credential_flags_need_explicit_gates(self):
        invalid = [
            ["test", "--github"], ["test", "--github-token-file", "/tmp/token"],
            ["test", "--aws"], ["test", "--aws-credentials-file", "/tmp/token"],
            ["up", "--github"],
            ["test", "--github", "--github-token-file", "/tmp/token", "--github-login", "tester", "--github-repository", "tester/disposable"],
        ]
        for arguments in invalid:
            with self.subTest(arguments=arguments), self.assertRaises(pilot.PilotError):
                pilot.validate_arguments(pilot.arguments(arguments))

    def test_prohibited_authentication_paths_and_links(self):
        for suffix in (".claude/.credentials.json", ".codex/auth.json", ".ssh/key", ".aws/credentials",
                       ".config/gh/hosts.yml", "ferry/token", "maintainer/token"):
            with self.subTest(suffix=suffix), self.assertRaises(pilot.PilotError):
                pilot.safe_path(self.home / suffix)
        target = self.home / "secret"
        target.write_text("do not read")
        link = self.home / "alias"
        link.symlink_to(target)
        with self.assertRaises(pilot.PilotError):
            stages.credential_file(link)
        hardlink = self.home / "hardlink"
        os.link(target, hardlink)
        target.chmod(0o600)
        with self.assertRaises(pilot.PilotError):
            stages.credential_file(hardlink)

    def test_credential_permissions_and_ownership(self):
        target = self.home / "throwaway"
        target.write_text("github_pat_fixture")
        target.chmod(0o644)
        with self.assertRaises(pilot.PilotError):
            stages.credential_file(target)
        target.chmod(0o600)
        self.assertEqual(stages.credential_file(target), "github_pat_fixture")

    def test_refuses_unowned_state_and_external_state(self):
        directory = self.home / "unrelated"
        directory.mkdir()
        with self.assertRaises(pilot.PilotError):
            pilot.owned_directory(directory)
        with patch.dict(os.environ, {"XDG_STATE_HOME": "/tmp/outside-home"}):
            with self.assertRaises(pilot.PilotError):
                pilot.Pilot()

    def test_subprocesses_get_no_ambient_credentials(self):
        with patch.dict(os.environ, {"GH_TOKEN": "ambient", "AWS_SECRET_ACCESS_KEY": "ambient",
                                    "ANTHROPIC_API_KEY": "ambient", "SSH_AUTH_SOCK": "socket"}):
            environment = pilot.Pilot().environment
        self.assertNotIn("GH_TOKEN", environment)
        self.assertNotIn("AWS_SECRET_ACCESS_KEY", environment)
        self.assertNotIn("ANTHROPIC_API_KEY", environment)
        self.assertNotIn("SSH_AUTH_SOCK", environment)
        self.assertEqual(environment["OPENSHELL_TELEMETRY_ENABLED"], "false")
        self.assertNotEqual(environment["HOME"], str(self.home))

    def test_command_errors_do_not_echo_secret_output(self):
        with patch("subprocess.run", return_value=subprocess.CompletedProcess([], 1, "secret", "secret")):
            with self.assertRaises(pilot.PilotError) as raised:
                self.pilot.run(["openshell", "provider", "create"])
        self.assertNotIn("secret", str(raised.exception).replace("credentials", ""))

    def mock_archive(self, path, binary):
        content = b"mock inert fixture, never an executable"
        with tarfile.open(path, "w:gz") as archive:
            member = tarfile.TarInfo("release/" + binary)
            member.size = len(content)
            archive.addfile(member, io.BytesIO(content))
        return hashlib.sha256(path.read_bytes()).hexdigest()

    def test_checksum_verification_and_idempotent_install(self):
        archives = {}
        digests = {}
        for binary in ("openshell", "openshell-gateway"):
            path = self.home / (binary + ".tgz")
            digests[binary] = self.mock_archive(path, binary)
            archives[binary] = path.read_bytes()
        calls = []

        def download(command, **_options):
            self.assertEqual(command[0], "curl")
            calls.append(command)
            destination = Path(command[command.index("--output") + 1])
            destination.write_bytes(archives[destination.name.removesuffix(".tar.gz")])
            return subprocess.CompletedProcess(command, 0, "", "")

        with patch.object(self.pilot, "preflight"), patch.object(self.pilot, "run", side_effect=download), \
                patch("platform.machine", return_value="x86_64"), patch.dict(pilot.CHECKSUMS, {"x86_64": digests}):
            self.pilot.install()
            self.pilot.install()
        self.assertEqual(len(calls), 2)
        self.assertTrue((self.pilot.prefix / "bin/openshell").is_file())

    def test_corrupt_archive_is_never_extracted_or_executed(self):
        def corrupt(command, **_options):
            Path(command[command.index("--output") + 1]).write_bytes(b"bad checksum")
            return subprocess.CompletedProcess(command, 0, "", "")
        with patch.object(self.pilot, "preflight"), patch.object(self.pilot, "run", side_effect=corrupt):
            with self.assertRaisesRegex(pilot.PilotError, "checksum mismatch"):
                self.pilot.install()
        self.assertFalse((self.pilot.prefix / "bin/openshell").exists())

    def test_units_gateway_configuration_and_down_order(self):
        self.pilot.render_units()
        gateway_unit = (self.pilot.units / pilot.UNITS[1]).read_text()
        self.assertIn("Requires=" + pilot.UNITS[0], gateway_unit)
        self.assertIn("ExecStartPre=", gateway_unit)
        self.assertIn('"-i"', gateway_unit)
        self.assertNotIn("docker.sock", gateway_unit)
        self.assertIn("Delegate=yes", gateway_unit)
        with patch.object(self.pilot, "run"):
            self.pilot.configure_gateway({"runtime": "sha256:runtime", "workload": "sha256:workload", "supervisor": "sha256:supervisor"})
        content = (self.pilot.state / "gateway.toml").read_text()
        self.assertIn('compute_driver = "podman"', content)
        self.assertIn("enable_bind_mounts = false", content)
        self.assertIn("gateway_jwt", content)
        self.assertIn('bind_address = "127.0.0.1:17670"', content)
        self.assertNotIn("disable_tls", content)
        (self.pilot.state / "containers").mkdir()
        calls = []
        with patch.object(self.pilot, "systemctl", side_effect=lambda *a, **_k: calls.append(a)), \
                patch.object(self.pilot, "podman", side_effect=lambda *a, **_k: calls.append(a)):
            self.pilot.down()
        self.assertEqual(calls[0], ("disable", "--now", pilot.UNITS[1]))
        self.assertEqual(calls[1][:2], ("stop", "--all"))
        self.assertEqual(calls[2], ("disable", "--now", pilot.UNITS[0]))

    def test_uninstall_only_removes_marked_dedicated_paths(self):
        pilot.owned_directory(self.pilot.prefix)
        self.pilot.render_units()
        keep = self.home / "keep"
        keep.write_text("unrelated")
        with patch.object(self.pilot, "systemctl"), patch.object(self.pilot, "podman"):
            self.pilot.uninstall()
        self.assertTrue(keep.exists())
        self.assertFalse(self.pilot.prefix.exists())
        self.assertFalse(self.pilot.state.exists())
        self.assertFalse((self.pilot.units / pilot.UNITS[0]).exists())

    def test_synthetic_failure_blocks_both_real_credential_readers_and_persists_report(self):
        options = pilot.arguments(["test", "--github", "--aws"])
        with patch.object(self.pilot, "installed"), patch.object(self.pilot, "health", return_value=True), \
                patch.object(stages, "Echo") as echo, \
                patch.object(stages, "resources", return_value=("{}", False)), \
                patch.object(stages, "github_stage") as github, patch.object(stages, "aws_stage") as aws:
            echo.return_value.__enter__.return_value.events = []
            with self.assertRaisesRegex(pilot.PilotError, "Synthetic qualification failed"):
                stages.test(self.pilot, options)
            github.assert_not_called()
            aws.assert_not_called()
        results = json.loads((self.pilot.state / "test-results.json").read_text())
        self.assertTrue(any(c["status"] == "FAIL" for c in results["checks"]))
        self.assertTrue(list(self.pilot.state.glob("openshell-pilot-results-*.md")))

    def test_resource_failure_still_attempts_cleanup(self):
        commands = []

        def cli(*arguments, **options):
            commands.append((arguments, options))
            if arguments[:2] == ("sandbox", "create"):
                raise pilot.PilotError("fixture create failure")
            return subprocess.CompletedProcess([], 0, "", "")

        profile = stages.bearer_profile("fixture", "PILOT_TOKEN", [], [])
        with patch.object(self.pilot, "cli", side_effect=cli), \
                patch.object(self.pilot, "podman", return_value=subprocess.CompletedProcess([], 0, "", "")):
            with self.assertRaisesRegex(pilot.PilotError, "fixture create failure"):
                stages.resources(self.pilot, "fixture", profile, {"PILOT_TOKEN": "secret-fixture"}, "synthetic", [])
        command_lists = [call[0] for call in commands]
        self.assertIn(("provider", "delete", "fixture"), command_lists)
        self.assertIn(("sandbox", "delete", "fixture"), command_lists)
        self.assertNotIn("secret-fixture", str(command_lists))
        creation = next(c for c in commands if c[0][:2] == ("provider", "create"))
        self.assertEqual(creation[1]["environment"]["PILOT_TOKEN"], "secret-fixture")
        sandbox = next(c[0] for c in commands if c[0][:2] == ("sandbox", "create"))
        self.assertIn("--no-auto-providers", sandbox)
        self.assertIn("--driver-config-json", sandbox)

    def test_policy_has_only_explicit_host_method_path_and_no_uninspected_credentials(self):
        endpoint = stages.endpoint("api.github.com", 443, [("GET", "/user")])
        self.assertEqual(endpoint["rules"], [{"allow": {"method": "GET", "path": "/user"}}])
        self.assertEqual(endpoint["tls"], "terminate")
        self.assertNotIn("allow_uninspected_credentials", endpoint)
        self.assertEqual(stages.POLICY["network_policies"], {})
        self.assertEqual(stages.POLICY["landlock"]["compatibility"], "hard_requirement")

    def test_report_never_calls_unrun_checks_pass(self):
        self.pilot.report()
        report = next(self.pilot.state.glob("openshell-pilot-results-*.md")).read_text()
        self.assertIn("test: NOT RUN", report)
        self.assertNotIn("PASS", report)

    def test_unhealthy_run_replaces_old_success(self):
        self.pilot.record("test completion", True, "previous run")
        self.pilot.save("test")
        with patch.object(self.pilot, "installed"), patch.object(self.pilot, "health", return_value=False):
            with self.assertRaises(pilot.PilotError):
                stages.test(self.pilot, pilot.arguments(["test"]))
        results = json.loads((self.pilot.state / "test-results.json").read_text())
        completion = [c for c in results["checks"] if c["check"] == "test completion"]
        self.assertEqual(completion[0]["status"], "FAIL")

    def test_github_scope_and_secret_scan_are_enforced(self):
        token = "github_pat_throwaway_fixture"
        source = self.home / "github-token"
        source.write_text(token)
        source.chmod(0o600)
        options = pilot.arguments(["test", "--github", "--attest-throwaway-read-only", "--github-token-file", str(source),
                                   "--github-login", "tester", "--github-repository", "tester/disposable"])
        with patch.object(stages, "resources", return_value=(token, True)) as resources:
            stages.github_stage(self.pilot, options)
        profile = resources.call_args.args[2]
        self.assertEqual(profile["endpoints"][0]["rules"], [{"allow": {"method": "GET", "path": "/user"}}])
        self.assertNotIn("git-receive-pack", json.dumps(profile))
        self.assertEqual(self.pilot.checks[-1]["status"], "FAIL")

    def test_aws_rejects_permanent_keys_before_creating_provider(self):
        source = self.home / "aws-session.json"
        source.write_text(json.dumps({"AccessKeyId": "AKIAlonglived", "SecretAccessKey": "fixture", "SessionToken": "fixture", "Expiration": "2030-01-01T00:00:00Z"}))
        source.chmod(0o600)
        options = pilot.arguments(["test", "--aws", "--attest-throwaway-read-only", "--aws-credentials-file", str(source),
                                   "--aws-role-arn", "arn:aws:iam::123456789012:role/test", "--aws-region", "us-west-2", "--aws-bucket", "disposable-test"])
        with patch.object(stages, "resources") as resources:
            with self.assertRaisesRegex(pilot.PilotError, "Long-lived"):
                stages.aws_stage(self.pilot, options)
        resources.assert_not_called()


if __name__ == "__main__":
    unittest.main()
