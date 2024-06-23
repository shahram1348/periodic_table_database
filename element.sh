#!/bin/bash
# Define variable to access database:
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function for doing all the work
INTRODUCE_ELEMENTS() {
  # get input argument from terminal:
  ELEMENT="$1"
  # Check if input is empty:
  if [[ -z $ELEMENT ]] 
  then 
    echo "Please provide an element as an argument."
    	else # If input is not empty, read data from join of two tables elements and properties:
        ELEMENT_DATA=$($PSQL "select * from types join (SELECT * FROM elements inner join properties using(atomic_number)) as subquery on types.type_id=subquery.type_id;")
        
        NOT_FOUND=true # Boolean veriable for checking of existance of element in the database
        while IFS='|' read TYPE_ID TYPE ATOMIC_NUMBER  SYMBOL  NAME   ATOMIC_MASS  MELTING_POINT  BOILING_POINT BAR
        do

        if [[ $ELEMENT == "$ATOMIC_NUMBER" ]] || [[ $ELEMENT == $SYMBOL ]] || [[ $ELEMENT == $NAME ]]
        then
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
          NOT_FOUND=false
        fi
        done <<< "$ELEMENT_DATA"
	  unset IFS
    # Show message if element is not in database:
    if $NOT_FOUND; then 
	    echo I could not find that element in the database.
	  fi
  fi
}
# Calling the main function of code:
INTRODUCE_ELEMENTS "$@"
