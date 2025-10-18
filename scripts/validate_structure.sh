#!/usr/bin/env bash
# Validation script for Django CI/CD template repository
# This script checks that all required files and directories are in place

set -euo pipefail

echo "🔍 Validating Django CI/CD Template Repository Structure..."
echo

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0

# Function to check if file exists
check_file() {
    local file="$1"
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} File exists: $file"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} File missing: $file"
        ((FAILED++))
        return 1
    fi
}

# Function to check if directory exists
check_dir() {
    local dir="$1"
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} Directory exists: $dir"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} Directory missing: $dir"
        ((FAILED++))
        return 1
    fi
}

# Function to check if script is executable
check_executable() {
    local script="$1"
    if [ -x "$script" ]; then
        echo -e "${GREEN}✓${NC} Script is executable: $script"
        ((PASSED++))
        return 0
    else
        echo -e "${YELLOW}⚠${NC} Script not executable: $script"
        ((FAILED++))
        return 1
    fi
}

echo "📁 Checking directory structure..."
check_dir "src"
check_dir "tests"
check_dir ".github"
check_dir ".github/workflows"
check_dir "docs"
check_dir "containers"
check_dir "scripts"
echo

echo "📄 Checking essential files..."
check_file "README.md"
check_file "LICENSE"
check_file "CONTRIBUTING.md"
check_file "INSTALL.md"
check_file ".gitignore"
check_file ".env.example"
echo

echo "📦 Checking dependency files..."
check_file "pyproject.toml"
check_file "requirements.txt"
check_file ".pre-commit-config.yaml"
check_file "pytest.ini"
check_file ".flake8"
echo

echo "🐳 Checking container definitions..."
check_file "containers/Dockerfile"
check_file "containers/Podmanfile"
check_file "containers/lxc-config.yaml"
check_file "docker-compose.yml"
check_file ".dockerignore"
echo

echo "🔧 Checking build and CI files..."
check_file "Makefile"
check_file ".github/workflows/ci.yml"
echo

echo "📜 Checking scripts..."
check_file "scripts/run_all.sh"
check_file "scripts/publish_images.sh"
check_executable "scripts/run_all.sh"
check_executable "scripts/publish_images.sh"
echo

echo "📚 Checking documentation..."
check_file "docs/index.md"
check_file "docs/getting-started.md"
check_file "docs/configuration.md"
check_file "docs/containers.md"
check_file "docs/cicd.md"
echo

echo "🧪 Checking test structure..."
check_file "tests/test_placeholder.py"
check_file "src/__init__.py"
echo

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Validation Results:"
echo -e "${GREEN}✓ Passed: $PASSED${NC}"
echo -e "${RED}✗ Failed: $FAILED${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Repository is properly structured.${NC}"
    exit 0
else
    echo -e "${RED}❌ Some checks failed. Please review the output above.${NC}"
    exit 1
fi
