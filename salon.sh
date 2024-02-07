#! /bin/bash

PSQL="psql -U freecodecamp -d salon -t -c"

SERVICE_MENU()
{
  if [[ -n $1 ]]
  then
    echo $1
  else 
    echo Welcome
  fi

  GET_SERVICES=$($PSQL "SELECT * FROM services;")
  echo "$GET_SERVICES" | while read ID bar SERVICE
  do
    echo "$ID) $SERVICE"
  done

  read SERVICE_ID_SELECTED
  
  VALIDATE_SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -n $VALIDATE_SERVICE ]]
  then
    MAKE_APPOINTMENT $SERVICE_ID_SELECTED
    else
    SERVICE_MENU "you fucked up"
  fi


}

MAKE_APPOINTMENT()
{
  SERVICE_ID_SELECTED=$1
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL " SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nWhat is your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
  else
    CUSTOMER_NAME=$($PSQL " SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
  fi

  CUSTOMER_ID=$($PSQL " SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  echo -e "\nEnter a time for your appointment"
  read SERVICE_TIME

  APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  SERVICE_NAME=$($PSQL " SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED';")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICE_MENU