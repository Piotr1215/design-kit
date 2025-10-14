#!/usr/bin/env bash
set -euo pipefail

# Minimal install - just copy command templates
# Always overwrites to get latest version

echo "Installing Design-Kit Commands..."

# Create directories if needed
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/design-kit

# Copy command templates (always overwrite for updates)
cp -f templates/commands/*.md ~/.claude/commands/

# Copy auto-connect-design.sh to design-kit directory
cp -f scripts/auto-connect-design.sh ~/.claude/design-kit/

# Create init.sh script (branch-based, norm approach)
cat > ~/.claude/design-kit/init.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Initialize .claude directory for design-kit workflow (branch-based, norm approach)

CLAUDE_DIR=".claude"

# Create base structure if needed
if [[ ! -d "$CLAUDE_DIR" ]]; then
    mkdir -p "$CLAUDE_DIR/specs"

    # Add to .gitignore
    if [[ -f .gitignore ]] && ! grep -q "^\.claude/" .gitignore; then
        echo -e "\n# Claude design-kit artifacts\n.claude/" >> .gitignore
    fi
fi

# Get current branch name for directory
BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")

# Sanitize branch name for directory (replace / and other special chars with -)
SAFE_BRANCH=$(echo "$BRANCH" | sed 's/[^a-zA-Z0-9._-]/-/g')

# Create branch directory with norm structure
BRANCH_DIR="$CLAUDE_DIR/specs/${SAFE_BRANCH}"
mkdir -p "$BRANCH_DIR/proofs"
mkdir -p "$BRANCH_DIR/tasks"

# Create symlink for current PLAN
ln -sfn "specs/${SAFE_BRANCH}/PLAN.md" "$CLAUDE_DIR/current-plan.md"

echo "✓ Created branch directory: $BRANCH_DIR"
echo "✓ Symlinked current-plan.md for easy access"
echo ""
echo "Structure:"
echo "  .claude/"
echo "  ├── specs/"
echo "  │   ├── main/"
echo "  │   │   ├── PLAN.md"
echo "  │   │   ├── proofs/"
echo "  │   │   └── tasks/"
echo "  │   └── ${SAFE_BRANCH}/ (current)"
echo "  │       ├── PLAN.md"
echo "  │       ├── proofs/"
echo "  │       └── tasks/"
echo "  └── current-plan.md → specs/${SAFE_BRANCH}/PLAN.md"
echo ""
echo "Ready for:"
echo "  /norm-plan     - Create master plan with phases"
echo "  /norm-research - Generate Phase 1 parallel proof tasks"
echo "  /norm-integrate - Generate Phase 2 integration tasks"
EOF

# Make init.sh executable
chmod +x ~/.claude/design-kit/init.sh

echo "✅ Installed Design-Kit!"
echo ""
echo "Commands available:"
echo "  /norm-plan     - Create master plan with phases"
echo "  /norm-research - Generate Phase 1 parallel proof tasks"
echo "  /norm-integrate - Generate Phase 2 integration tasks"
echo ""
echo "Philosophy:"
echo "  • Test-driven: 100+ tests before docs"
echo "  • Parallel execution: Independent proofs"
echo "  • Contract-based: Black-box integration"
echo ""
echo "Manual tools in design-kit/scripts/:"
echo "  __list_specs.sh        - List all branch specs"
echo "  auto-connect-design.sh - Used by commands (automatic)"