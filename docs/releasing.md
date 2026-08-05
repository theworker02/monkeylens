# Releasing MonkeyLens

MonkeyLens publishes to RubyGems.org with **Trusted Publishing**. It does not use a long-lived RubyGems API key.

## One-time setup

### 1. Create the GitHub environment

In `theworker02/monkeylens`:

1. Open **Settings**.
2. Select **Environments**.
3. Select **New environment**.
4. Name it exactly `release`.
5. Leave environment secrets empty. Optional deployment protection rules may be added later.

### 2. Configure the pending RubyGems trusted publisher

Sign in to RubyGems.org and open the **Pending trusted publishers** area of your profile. Create a publisher with these exact values:

| Field | Value |
| --- | --- |
| Gem name | `monkey_lens` |
| Repository owner | `theworker02` |
| Repository name | `monkeylens` |
| Workflow filename | `publish-rubygems.yml` |
| Environment | `release` |
| Workflow repository owner | Leave blank |
| Workflow repository name | Leave blank |

After the first successful publication, RubyGems converts the pending publisher into the gem's normal trusted publisher.

Do not create or store `RUBYGEMS_API_KEY`. The workflow requests a short-lived RubyGems token through GitHub's OIDC identity provider.

## Publish an existing tagged version

1. Confirm the semantic tag and GitHub release exist, such as `v0.1.0`.
2. Open **Actions** in the repository.
3. Select **Publish to RubyGems**.
4. Select **Run workflow**.
5. Enter the version without the `v` prefix, such as `0.1.0`.
6. Run the workflow.

The workflow checks out the matching tag, verifies the embedded version, runs the test suite, builds the gem, and publishes with `rubygems/release-gem@v1`.

## Prepare a future version

1. Update `MonkeyLens::VERSION` using semantic versioning.
2. Update `CHANGELOG.md`.
3. Run `bundle exec rake test`, `bundle exec rake build`, and the CLI doctor command.
4. Commit the release source.
5. Create and push the matching semantic tag, such as `v0.2.0`.
6. Confirm the GitHub release and `.gem` asset.
7. Run **Publish to RubyGems** with the same version number.

Never commit `.gem/credentials`, API keys, passwords, recovery codes, or session cookies to the repository or paste them into an issue, pull request, workflow file, or chat transcript.
