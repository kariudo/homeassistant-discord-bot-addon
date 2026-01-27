#!/bin/bash
# Home Assistant addon entry point
# This script is called by Home Assistant supervisor
# The actual logic is in /start.sh which handles both addon and plain Docker modes
exec /start.sh

