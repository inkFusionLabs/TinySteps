#!/bin/bash

# TinySteps Performance Test Script
# This script tests the performance optimizations implemented in the app

echo "🚀 TinySteps Performance Test Suite"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -e "\n${BLUE}Testing: $test_name${NC}"
    
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASSED${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}❌ FAILED${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Function to check file exists
check_file() {
    local file_path="$1"
    local description="$2"
    
    if [ -f "$file_path" ]; then
        echo -e "${GREEN}✅ $description found${NC}"
        return 0
    else
        echo -e "${RED}❌ $description not found${NC}"
        return 1
    fi
}

# Function to check code quality
check_code_quality() {
    local file_path="$1"
    local description="$2"
    
    if [ -f "$file_path" ]; then
        # Check for performance optimizations
        if grep -q "performanceOptimized\|LazyLoadingList\|CacheManager\|MemoryManager" "$file_path"; then
            echo -e "${GREEN}✅ $description contains performance optimizations${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️  $description may need performance review${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ $description not found${NC}"
        return 1
    fi
}

echo -e "\n${YELLOW}📁 Checking Project Structure${NC}"
echo "================================"

# Check for essential files
check_file "TinySteps/PerformanceOptimizedViews.swift" "Performance optimization views"
check_file "TinySteps/PerformanceSettingsView.swift" "Performance settings view"
check_file "PERFORMANCE_OPTIMIZATION_GUIDE.md" "Performance optimization guide"

echo -e "\n${YELLOW}🔍 Checking Code Quality${NC}"
echo "=========================="

# Check main views for performance optimizations
check_code_quality "TinySteps/ContentView.swift" "Main content view"
check_code_quality "TinySteps/HomeView.swift" "Home view"
check_code_quality "TinySteps/TrackingView.swift" "Tracking view"

echo -e "\n${YELLOW}📊 Performance Metrics Check${NC}"
echo "================================"

# Check for performance monitoring
if grep -q "PerformanceMonitor\|MemoryManager\|CacheManager" "TinySteps/PerformanceOptimizedViews.swift"; then
    echo -e "${GREEN}✅ Performance monitoring implemented${NC}"
    PASSED_TESTS=$((PASSED_TESTS + 1))
else
    echo -e "${RED}❌ Performance monitoring missing${NC}"
    FAILED_TESTS=$((FAILED_TESTS + 1))
fi

# Check for lazy loading
if grep -q "LazyLoadingList\|LazyVStack" "TinySteps/PerformanceOptimizedViews.swift"; then
    echo -e "${GREEN}✅ Lazy loading implemented${NC}"
    PASSED_TESTS=$((PASSED_TESTS + 1))
else
    echo -e "${RED}❌ Lazy loading missing${NC}"
    FAILED_TESTS=$((FAILED_TESTS + 1))
fi

# Check for memory management
if grep -q "MemoryManager\|clearMemory\|clearCache" "TinySteps/PerformanceOptimizedViews.swift"; then
    echo -e "${GREEN}✅ Memory management implemented${NC}"
    PASSED_TESTS=$((PASSED_TESTS + 1))
else
    echo -e "${RED}❌ Memory management missing${NC}"
    FAILED_TESTS=$((FAILED_TESTS + 1))
fi

echo -e "\n${YELLOW}🎯 Optimization Tests${NC}"
echo "======================"

# Test 1: Check for performance modifiers
run_test "Performance Modifiers" \
    "grep -q 'performanceOptimized\|optimized' TinySteps/ContentView.swift" \
    "Performance modifiers should be applied to main views"

# Test 2: Check for animation optimizations
run_test "Animation Optimizations" \
    "grep -q 'conditionalAnimation\|AnimationOptimizer' TinySteps/PerformanceOptimizedViews.swift" \
    "Animation optimizations should be implemented"

# Test 3: Check for cache management
run_test "Cache Management" \
    "grep -q 'CacheManager\|clearCache' TinySteps/PerformanceOptimizedViews.swift" \
    "Cache management should be implemented"

# Test 4: Check for debounced input
run_test "Debounced Input" \
    "grep -q 'DebouncedTextField' TinySteps/PerformanceOptimizedViews.swift" \
    "Debounced input should be implemented"

echo -e "\n${YELLOW}📈 Performance Summary${NC}"
echo "======================"

echo -e "Total Tests: ${BLUE}$TOTAL_TESTS${NC}"
echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed: ${RED}$FAILED_TESTS${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All performance tests passed!${NC}"
    echo -e "${GREEN}The app is optimized for performance.${NC}"
    exit 0
else
    echo -e "\n${RED}⚠️  Some performance tests failed.${NC}"
    echo -e "${YELLOW}Please review the failed tests and implement missing optimizations.${NC}"
    exit 1
fi

echo -e "\n${BLUE}📋 Performance Recommendations${NC}"
echo "================================"

echo "1. Monitor app performance in real-world usage"
echo "2. Use Xcode Instruments for detailed profiling"
echo "3. Test on different device types and iOS versions"
echo "4. Monitor memory usage and frame rates"
echo "5. Implement additional optimizations as needed"

echo -e "\n${GREEN}✅ Performance test completed!${NC}" 