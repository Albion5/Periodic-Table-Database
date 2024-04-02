PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

FIND_ELEMENT_BY_NAME() {
  echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
}

FIND_ELEMENT_BY_NUMBER() {
  echo $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
}

FIND_ELEMENT() {
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    echo $(FIND_ELEMENT_BY_NUMBER $1)
  else
    echo $(FIND_ELEMENT_BY_NAME "$1")
  fi
}
if [[ $# -eq 0 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT_INFO="$(FIND_ELEMENT "$1")"
  echo $ELEMENT_INFO
fi