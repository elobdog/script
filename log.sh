#!/bin/bash


################################################################################
# Description :
## - Writes logs into logfile defined by argument $2.
## - This function should ideally be made a part of some common code which can
## be imported in some other shell script source code.
## for instance:
## . /opt/MyProdRoot/DummyProd/common/common_functions.sh
## - As stated above, LOG() can be put into common_functions.sh

# Arguments   :
## $1: timestamp-flag
## 0: doesn't write timestamp.
## 1: writes timestamp.
## $2: logfile.
## $3: Log message.
## $4: Caller name. Optional. Passed iff $1 is 1.
## $5: Line number in the caller. Optional. Passed iff $1 is 1.

# Return Value: 0: succcess, 1: failure

# Additional note:
## Examples of how to invoke:
## 1>  LOG 1 "$LOG_FILE" "ERR: Source file $src_file does not exist." "$FUNCNAME" "$LINENO"
## 2>  LOG 0 "$LOG_FILE" "#########################################." "$FUNCNAME"
## $FUNCNAME is shell variable and caller of LOG() have these variables set
## in the context of the calling function.
## $LINENO is also a shell variable. Scope of this variable is across the entire script.
################################################################################
LOG() {
	local timestamp_flag="$1"
	local log_current_timestamp="$(date "+%d-%b-%Y-%H%M%S:%3N-%Z")"
	local log_file="$2"
	local log_message="$3"
	local function_name="na"
	local lineno=0

	if [ $# -ne 3 ] && [ $# -ne 5 ] ; then
		log_usage
		exit "$EV_FAIL"
	fi

	let "timestamp_flag += 0"

	if [ -z "$log_message" ] ; then
		echo >> "$log_file"
		return 0
	fi

	if [ "$timestamp_flag" -eq 1 ] && [ $# -ne 5 ] ; then
		log_usage
		exit 1
	fi

	if [ "$timestamp_flag" -eq 0 ] ; then
		echo "$log_message" >> "$log_file"
		return "$STATUS_OK"
	fi

	function_name="$4"
	lineno="$5"
	let "lineno += 0"

	echo "["$log_current_timestamp"]["$function_name":"$lineno"]::  $log_message" >> "$log_file"

	return 0
}
