#!/bin/bash

# TinySteps Release Automation Script
# This script automates the release workflow with auto-confirmation options

set -e  # Exit on any error

# Configuration
REPO_OWNER="inkFusionLabs"
REPO_NAME="TinySteps"
AUTO_CONFIRM=${AUTO_CONFIRM:-false}
DRY_RUN=${DRY_RUN:-false}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Auto-confirm function
confirm() {
    if [ "$AUTO_CONFIRM" = "true" ]; then
        log_info "Auto-confirming: $1"
        return 0
    fi
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would ask: $1"
        return 0
    fi
    
    read -p "$1 (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) is not installed. Please install it first."
        exit 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        log_error "Not authenticated with GitHub. Please run 'gh auth login' first."
        exit 1
    fi
    
    # Check if we're in the right repository
    if ! git remote get-url origin | grep -q "$REPO_OWNER/$REPO_NAME"; then
        log_error "Not in the correct repository. Please run this script from the TinySteps directory."
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Get current version
get_current_version() {
    # Try to get version from Xcode project
    if [ -f "TinySteps.xcodeproj/project.pbxproj" ]; then
        CURRENT_VERSION=$(grep -A 1 "MARKETING_VERSION" TinySteps.xcodeproj/project.pbxproj | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
        if [ -n "$CURRENT_VERSION" ]; then
            echo "$CURRENT_VERSION"
            return
        fi
    fi
    
    # Fallback to git tags
    CURRENT_VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0")
    echo "$CURRENT_VERSION"
}

# Calculate next version
calculate_next_version() {
    local current_version=$1
    local release_type=$2
    
    IFS='.' read -ra VERSION_PARTS <<< "$current_version"
    local major=${VERSION_PARTS[0]}
    local minor=${VERSION_PARTS[1]}
    local patch=${VERSION_PARTS[2]}
    
    case $release_type in
        "major")
            echo "$((major + 1)).0.0"
            ;;
        "minor")
            echo "$major.$((minor + 1)).0"
            ;;
        "patch")
            echo "$major.$minor.$((patch + 1))"
            ;;
        *)
            log_error "Invalid release type: $release_type. Use major, minor, or patch."
            exit 1
            ;;
    esac
}

# Update version in Xcode project
update_xcode_version() {
    local new_version=$1
    
    log_info "Updating Xcode project version to $new_version"
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would update Xcode project version to $new_version"
        return
    fi
    
    # Update MARKETING_VERSION in project.pbxproj
    if [ -f "TinySteps.xcodeproj/project.pbxproj" ]; then
        sed -i '' "s/MARKETING_VERSION = [0-9]\+\.[0-9]\+\.[0-9]\+;/MARKETING_VERSION = $new_version;/g" TinySteps.xcodeproj/project.pbxproj
        log_success "Updated Xcode project version"
    else
        log_warning "Xcode project file not found, skipping version update"
    fi
}

# Create release branch
create_release_branch() {
    local version=$1
    local branch_name="release/v$version"
    
    log_info "Creating release branch: $branch_name"
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would create branch $branch_name"
        return
    fi
    
    git checkout -b "$branch_name"
    log_success "Created release branch: $branch_name"
}

# Run tests
run_tests() {
    log_info "Running tests..."
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would run tests"
        return
    fi
    
    # Run Xcode tests if available
    if command -v xcodebuild &> /dev/null; then
        xcodebuild test -project TinySteps.xcodeproj -scheme TinySteps -destination 'platform=iOS Simulator,name=iPhone 15' || {
            log_error "Tests failed"
            exit 1
        }
        log_success "Tests passed"
    else
        log_warning "xcodebuild not available, skipping tests"
    fi
}

# Build the project
build_project() {
    log_info "Building project..."
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would build project"
        return
    fi
    
    # Build for release
    if command -v xcodebuild &> /dev/null; then
        xcodebuild archive -project TinySteps.xcodeproj -scheme TinySteps -archivePath build/TinySteps.xcarchive || {
            log_error "Build failed"
            exit 1
        }
        log_success "Build completed"
    else
        log_warning "xcodebuild not available, skipping build"
    fi
}

# Commit changes
commit_changes() {
    local version=$1
    local commit_message="Release v$version"
    
    log_info "Committing changes..."
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would commit with message: $commit_message"
        return
    fi
    
    git add .
    git commit -m "$commit_message"
    log_success "Changes committed"
}

# Push changes
push_changes() {
    local branch_name=$1
    
    log_info "Pushing changes to $branch_name..."
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would push to $branch_name"
        return
    fi
    
    git push origin "$branch_name"
    log_success "Changes pushed to $branch_name"
}

# Create pull request
create_pull_request() {
    local version=$1
    local branch_name="release/v$version"
    local title="Release v$version"
    local body="## Release v$version

### Changes
- Version bump to $version
- Build and test automation

### Checklist
- [ ] Tests passing
- [ ] Build successful
- [ ] Version updated
- [ ] Ready for review

### Auto-generated by release automation script"

    log_info "Creating pull request for v$version..."
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would create PR with title: $title"
        return
    fi
    
    gh pr create --title "$title" --body "$body" --base main --head "$branch_name" || {
        log_error "Failed to create pull request"
        exit 1
    }
    log_success "Pull request created"
}

# Create GitHub release
create_github_release() {
    local version=$1
    local title="Release v$version"
    local body="## What's New in v$version

### Features
- [Add features here]

### Bug Fixes
- [Add bug fixes here]

### Improvements
- [Add improvements here]

### Technical Changes
- Version bump to $version
- Automated release process

---

*This release was automatically generated by the release automation script.*"

    log_info "Creating GitHub release for v$version..."
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would create GitHub release v$version"
        return
    fi
    
    gh release create "v$version" --title "$title" --body "$body" --target main || {
        log_error "Failed to create GitHub release"
        exit 1
    }
    log_success "GitHub release created"
}

# Merge to main
merge_to_main() {
    local version=$1
    local branch_name="release/v$version"
    
    log_info "Merging $branch_name to main..."
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would merge $branch_name to main"
        return
    fi
    
    git checkout main
    git pull origin main
    git merge "$branch_name" --no-ff -m "Merge release v$version"
    git push origin main
    log_success "Merged to main"
}

# Cleanup
cleanup() {
    local version=$1
    local branch_name="release/v$version"
    
    log_info "Cleaning up release branch..."
    
    if [ "$DRY_RUN" = "true" ]; then
        log_warning "DRY RUN: Would delete branch $branch_name"
        return
    fi
    
    git branch -d "$branch_name" 2>/dev/null || true
    git push origin --delete "$branch_name" 2>/dev/null || true
    log_success "Cleanup completed"
}

# Main release function
release() {
    local release_type=$1
    
    log_info "Starting release process for type: $release_type"
    
    # Check prerequisites
    check_prerequisites
    
    # Get current version
    local current_version=$(get_current_version)
    log_info "Current version: $current_version"
    
    # Calculate next version
    local next_version=$(calculate_next_version "$current_version" "$release_type")
    log_info "Next version: $next_version"
    
    # Confirm release
    if ! confirm "Proceed with release v$next_version?"; then
        log_info "Release cancelled"
        exit 0
    fi
    
    # Create release branch
    local branch_name="release/v$next_version"
    create_release_branch "$next_version"
    
    # Update version
    update_xcode_version "$next_version"
    
    # Run tests
    run_tests
    
    # Build project
    build_project
    
    # Commit changes
    commit_changes "$next_version"
    
    # Push changes
    push_changes "$branch_name"
    
    # Create pull request
    create_pull_request "$next_version"
    
    # Ask if ready to merge and release
    if confirm "Ready to merge to main and create GitHub release?"; then
        # Merge to main
        merge_to_main "$next_version"
        
        # Create GitHub release
        create_github_release "$next_version"
        
        # Cleanup
        cleanup "$next_version"
        
        log_success "Release v$next_version completed successfully!"
    else
        log_info "Release branch created. Manual merge and release required."
        log_info "Branch: $branch_name"
    fi
}

# Show usage
usage() {
    echo "Usage: $0 [OPTIONS] <release_type>"
    echo ""
    echo "Release types:"
    echo "  major    - Increment major version (1.0.0 -> 2.0.0)"
    echo "  minor    - Increment minor version (1.0.0 -> 1.1.0)"
    echo "  patch    - Increment patch version (1.0.0 -> 1.0.1)"
    echo ""
    echo "Options:"
    echo "  --auto-confirm    - Auto-confirm all prompts"
    echo "  --dry-run         - Show what would be done without executing"
    echo "  --help            - Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  AUTO_CONFIRM      - Set to 'true' to auto-confirm (same as --auto-confirm)"
    echo "  DRY_RUN          - Set to 'true' for dry run (same as --dry-run)"
    echo ""
    echo "Examples:"
    echo "  $0 patch                    # Release patch version"
    echo "  $0 minor --auto-confirm     # Release minor version with auto-confirm"
    echo "  $0 major --dry-run          # Show what would be done for major release"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --auto-confirm)
            AUTO_CONFIRM=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        major|minor|patch)
            RELEASE_TYPE=$1
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Check if release type is provided
if [ -z "$RELEASE_TYPE" ]; then
    log_error "Release type is required"
    usage
    exit 1
fi

# Show configuration
log_info "Configuration:"
log_info "  Auto-confirm: $AUTO_CONFIRM"
log_info "  Dry run: $DRY_RUN"
log_info "  Release type: $RELEASE_TYPE"

# Start release process
release "$RELEASE_TYPE" 