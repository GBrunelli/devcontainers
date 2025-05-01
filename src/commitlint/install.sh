#!/usr/bin/env bash
set -e

# Install commitlint dependencies
npm install -g @commitlint/cli @commitlint/config-conventional

# Create commitlint configuration
cat > /tmp/commitlint.config.js <<EOL
module.exports = {
  extends: ['@commitlint/config-conventional']
};
EOL

# Copy the config file to the right location
mkdir -p "${_REMOTE_USER_HOME}"
cp /tmp/commitlint.config.js "${_REMOTE_USER_HOME}/commitlint.config.js"

# Create central hooks directory
hooks_dir="/etc/git-hooks"
mkdir -p $hooks_dir

# Create commit-msg hook
cat > $hooks_dir/commit-msg <<EOL
#!/bin/sh
npx --no -- commitlint --edit "\$1"
EOL

# Make the hook executable
chmod +x $hooks_dir/commit-msg

# Configure git to use centralized hooks path (Git 2.9+)
git config --system core.hooksPath $hooks_dir

echo "Conventional commits git hook has been installed successfully as a centralized hook!"
echo "Note: This will disable all local repository hooks."