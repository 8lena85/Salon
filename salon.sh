#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

echo "Choose a service you would like to get!"
echo -e "\n1) Manicure\n2) Pedicure\n3) Hair\n4) Make-up"

read SERVICE_ID_SELECTED

# if selected input not a number between 1 and 4
if [[ ! $SERVICE_ID_SELECTED =~ ^[1-4]+$ ]]
then
  echo -e "Please enter id of a service!"
  echo -e "\n1) Manicure\n2) Pedicure\n3) Hair\n4) Make-up"
  read SERVICE_ID_SELECTED
else
  echo -e "\nEnter your phone:"
  read CUSTOMER_PHONE
  CHECK_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE';")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  SERVICE_NAME=$(echo "$SERVICE_NAME" | sed -n '3p' | tr -d '[:space:]')

  # if phone doesn't exist
  if [[ ! $CHECK_PHONE =~ $CUSTOMER_PHONE ]]
  then
    echo -e "\nEnter your name:"
    read CUSTOMER_NAME

    # insert new customer and a phone into database
    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    CUSTOMER_ID=$(echo "$CUSTOMER_ID" | sed -n '3p' | tr -d '[:space:]')

    # prompt for a time 
    echo -e "\nWhat time do you prefer?"
    read SERVICE_TIME
    
    # add a row in appointments
    APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/^ *//g') at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    CUSTOMER_ID=$(echo "$CUSTOMER_ID" | sed -n '3p' | tr -d '[:space:]')
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    CUSTOMER_NAME=$(echo "$CUSTOMER_NAME" | sed -n '3p' | tr -d '[:space:]')
    echo -e "\nWhat time do you prefer?"
    read SERVICE_TIME
    
    # add a row in appointments
    APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/^ *//g') at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
fi