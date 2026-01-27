#!/bin/bash

# Ensure we are in the root of the project
PROJECT_ROOT=$(pwd)

echo "Running melos test-coverage..."
melos run test-coverage

# Create a combined coverage directory
COMBINED_COVERAGE_DIR="$PROJECT_ROOT/coverage"
mkdir -p "$COMBINED_COVERAGE_DIR"
LCOV_COMBINED_FILE="$COMBINED_COVERAGE_DIR/lcov.info"

# Clear existing combined lcov if it exists
> "$LCOV_COMBINED_FILE"

# Find all packages that have a coverage/lcov.info file
echo "Discovering packages..."
LCOV_INPUTS=""

# Use while read to handle potential spaces correctly
while IFS=: read -r PKG_NAME PKG_PATH; do
    # Relative path from root for logging
    REL_PATH=${PKG_PATH#"$PROJECT_ROOT/"}
    
    LCOV_FILE="$PKG_PATH/coverage/lcov.info"
    
    if [ -f "$LCOV_FILE" ]; then
        echo "Processing $PKG_NAME at $REL_PATH..."
        
        # Temporary file for adjusted lcov
        TMP_LCOV="$COMBINED_COVERAGE_DIR/${PKG_NAME}_lcov.info"
        
        # Adjust paths to be absolute: SF:lib/ -> SF:/absolute/path/to/pkg/lib/
        # Using absolute paths ensures genhtml can always find the source files
        # then we use --prefix to strip the project root from the final report
        sed "s|SF:lib/|SF:$PKG_PATH/lib/|g" "$LCOV_FILE" > "$TMP_LCOV"
        
        LCOV_INPUTS="$LCOV_INPUTS -a $TMP_LCOV"
    else
        echo "No coverage found for $PKG_NAME at $LCOV_FILE"
    fi
done < <(melos list --json | jq -r '.[] | .name + ":" + .location')

if [ -n "$LCOV_INPUTS" ]; then
    echo "Combining lcov files..."
    lcov $LCOV_INPUTS -o "$LCOV_COMBINED_FILE"
    
    echo "Generating HTML report..."
    # Use --prefix to ensure the report shows paths relative to the project root
    # Use --no-prefix to avoid genhtml stripping too much
    genhtml "$LCOV_COMBINED_FILE" \
        -o "$COMBINED_COVERAGE_DIR/html" \
        --prefix "$PROJECT_ROOT" \
        --ignore-errors source
    
    echo "-------------------------------------------------------"
    echo "Coverage report generated at: $COMBINED_COVERAGE_DIR/html/index.html"
    echo "-------------------------------------------------------"
else
    echo "Error: No lcov.info files were found in any package."
    exit 1
fi
