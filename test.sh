#!/bin/sh

if nzodbcsql -q "select 1 from dual" > /dev/null; then
    echo "Connection successful!"
else
    echo "Connection unsuccessful"
    exit 1
fi
