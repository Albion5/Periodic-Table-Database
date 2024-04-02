PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

FIND_ELEMENT_BY_NAME() {
  echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
}

FIND_ELEMENT_BY_NUMBER() {
  echo $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
}

GET_ELEMENT_INFO () {
  echo "$($PSQL "SELECT name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$1")"
}

OUTPUT_ELEMENT_INFO() {
  local ATOMIC_NUMBER=$1
  local ELEMENT_INFO="$(GET_ELEMENT_INFO $ATOMIC_NUMBER)"
  IFS='|' read -r NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_INFO"
  echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."  
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
  ATOMIC_NUMBER="$(FIND_ELEMENT "$1")"
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    OUTPUT_ELEMENT_INFO $ATOMIC_NUMBER
  fi

fi