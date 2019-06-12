#!/bin/bash
export IOC_EXEC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export VAR_DIR="/var"
export BASE_VER="7.0.2"
export REQUIRE_VER="3.1.0"
export E3_BIN_DIR="/epics7/base-$BASE_VER/require/$REQUIRE_VER/bin"
export IOC_ST_CMD=st.ral-evr-01.cmd
source "$E3_BIN_DIR/setE3Env.bash"
$E3_BIN_DIR/iocsh.bash $IOC_EXEC_DIR/$IOC_ST_CMD &
