#!/usr/bin/env bash
set -euo pipefail

# Design-Kit Installation Script
# Installs command templates and helper scripts to ~/.claude/

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Design-Kit Installer"
echo "  Test-Driven Parallel Development Framework"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check prerequisites
if ! command -v git &> /dev/null; then
    echo "❌ ERROR: git is not installed. Please install git first."
    exit 1
fi

echo "📦 Installing Design-Kit..."
echo ""

# Create directories if needed
echo "  → Creating directories in ~/.claude/"
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/design-kit

# Copy command templates (always overwrite for updates)
echo "  → Installing command templates..."
cp -f templates/commands/*.md ~/.claude/commands/
echo "     ✓ /norm-plan"
echo "     ✓ /norm-research"
echo "     ✓ /norm-integrate"

# Copy auto-connect-design.sh to design-kit directory
echo "  → Installing helper scripts..."
cp -f scripts/auto-connect-design.sh ~/.claude/design-kit/
echo "     ✓ auto-connect-design.sh"

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
echo "     ✓ init.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Design-Kit Successfully Installed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Available Commands:"
echo "  /norm-plan      - Create master plan with phases"
echo "  /norm-research  - Generate Phase 1 parallel proof tasks"
echo "  /norm-integrate - Generate Phase 2 integration tasks"
echo ""
echo "💡 Quick Start:"
echo "  1. Navigate to your project directory"
echo "  2. Create a feature branch: git checkout -b feature/my-feature"
echo "  3. Start planning: /norm-plan \"Your project description\""
echo ""
echo "🎯 Core Philosophy:"
echo "  • Test-driven: Run 100+ tests before writing docs"
echo "  • Parallel execution: Independent component validation"
echo "  • Contract-based: Black-box integration via CONTRACT.md"
echo ""
echo "📚 Documentation:"
echo "  README: https://github.com/Piotr1215/design-kit"
echo "  Philosophy: design-driven.md"
echo ""
echo "🚀 Happy building with Design-Kit!"
echo ""