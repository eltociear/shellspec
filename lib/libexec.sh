#shellcheck shell=sh

# shellcheck source=lib/general.sh
. "${SHELLSPEC_LIB:-./lib}/general.sh"

use() {
  while [ $# -gt 0 ]; do
    case $1 in
      unixtime) shellspec_import posix ;;
    esac
    case $1 in
      constants) shellspec_constants ;;
      reset_params)
        reset_params() {
          shellspec_reset_params "$@"
          eval 'RESET_PARAMS=$SHELLSPEC_RESET_PARAMS'
        }
        ;;
      *) shellspec_proxy "$1" "shellspec_$1" ;;
    esac
    shift
  done
}

load() {
  while [ "$#" -gt 0 ]; do
    . "${SHELLSPEC_LIB:-./lib}/libexec/$1.sh"
    shift
  done
}

is_specfile() {
  case $1 in (*_spec.sh) return 0; esac
  return 1
}

find_specfiles() {
  eval "find_specfiles_() { if is_specfile \"\$1\"; then \"$1\" \"\$@\"; fi; }"
  shellspec_find_files find_specfiles_ "$@"
}

use puts putsn