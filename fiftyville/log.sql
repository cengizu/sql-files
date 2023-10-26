-- Keep a log of any SQL queries you execute as you solve the mystery.

.schema

SELECT description
FROM crime_scene_reports
WHERE month = 7 AND day = 28
AND street = 'Humphrey Street';

-- Check bakery mention
SELECT transcript FROM interviews
WHERE month = 7 AND day = 28
AND transcript LIKE '%bakery%';

-- Check between 10:15 and 10:25, list all cars that EXIT
SELECT bakery_security_logs.activity, bakery_security_logs.license_plate, people.name FROM people
JOIN bakery_security_logs ON bakery_security_logs.license_plate = people.license_plate
WHERE bakery_security_logs.month = 7
AND bakery_security_logs.day = 28
AND bakery_security_logs.hour = 10
AND bakery_security_logs.minute >= 15
AND bakery_security_logs.minute <= 25;

-- List those who WITHDREW money from ATM on Leggett Street
SELECT people.name, atm_transactions.transaction_type FROM people
JOIN bank_accounts ON bank_accounts.person_id = people.id
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
WHERE atm_transactions.month = 7
AND atm_transactions.day = 28
AND atm_location = 'Leggett Street'
AND atm_transactions.transaction_type = 'withdraw';

-- List phone calls with a duration of less than 60 secs. List FLIGHTS leaving Fiftyville TOMORROW
SELECT caller, caller_name, receiver, receiver_name FROM phone_calls
WHERE month = 7
AND day = 28
AND duration < 60;

-- Display Names of of those caller/receivers
SELECT name, phone_calls.duration FROM people
JOIN phone_calls ON people.phone_number = phone_calls.caller
AND phone_calls.month = 7
AND phone_calls.day = 28
AND phone_calls.duration <= 60
ORDER BY phone_calls.duration;

-- List the receivers
SELECT name, phone_calls.duration FROM people
JOIN phone_calls ON people.phone_number = phone_calls.receiver
WHERE phone_calls.year = 2021
AND phone_calls.month = 7
AND phone_calls.day = 28
AND phone_calls.duration <= 60
ORDER BY phone_calls.duration;

-- Airport of Fiftyville
SELECT abbreviation, full_name, city FROM airports
WHERE city = 'Fiftyville';

-- List all departures on 29.7, find the first flight
SELECT flights.id, full_name, city, flights.hour, flights.minute FROM airports
JOIN flights ON airports.id = flights.destination_airport_id
WHERE flights.origin_airport_id =
       (SELECT id
          FROM airports
         WHERE city = 'Fiftyville')
AND flights.month = 7
AND flights.day = 29
ORDER BY flights.hour, flights.minute;

-- List of passengers with license platess, of the first flight #36 to LaGuardia
SELECT flights.destination_airport_id, name, phone_number, people.license_plate FROM people
JOIN passengers ON people.passport_number = passengers.passport_number
JOIN flights ON flights.id = passengers.flight_id
WHERE flights.id = 36
ORDER BY flights.hour ASC;

-- And finally, list the name that appears on callers, atm transactions and Bakery leaving license plates
SELECT name FROM people
JOIN passengers ON people.passport_number = passengers.passport_number
JOIN flights ON flights.id = passengers.flight_id
WHERE (flights.month = 7 AND flights.day = 29 AND flights.id = 36)
AND name IN
(   SELECT people.name FROM people
    JOIN phone_calls ON people.phone_number = phone_calls.caller
    AND phone_calls.month = 7
    AND phone_calls.day = 28
    AND phone_calls.duration <= 60)
AND name IN
(   SELECT people.name FROM people
    JOIN bank_accounts ON bank_accounts.person_id = people.id
    JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number
    WHERE atm_transactions.month = 7
    AND atm_transactions.day = 28
    AND atm_location = 'Leggett Street'
    AND atm_transactions.transaction_type = 'withdraw')
AND name IN
(   SELECT people.name FROM people
    JOIN bakery_security_logs ON bakery_security_logs.license_plate = people.license_plate
    WHERE bakery_security_logs.month = 7
    AND bakery_security_logs.day = 28
    AND bakery_security_logs.hour = 10
    AND bakery_security_logs.minute >= 15
    AND bakery_security_logs.minute <= 25);