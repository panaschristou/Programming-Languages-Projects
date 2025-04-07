% queries.pl
:- consult('rules.pl').

% Optional: If you want to automatically save the output to a file,
% you can uncomment the following two lines:
:- tell('output.txt').
% (and then at the end of the file, add ":- told." to close the output stream.)

% Question 1: Where does the flight from PHX go?
:- writeln('Question 1: Where does the flight from PHX go?'),
   ( flight(FlightNo, phx, Destination, DepTime, ArrTime),
     format("  Flight ~w: PHX -> ~w dep ~w arr ~w~n",
            [FlightNo, Destination, DepTime, ArrTime]),
     fail
   ; true ),
   nl.

% Question 2: Is there a flight to PHX?
:- writeln('Question 2: Is there a flight to PHX?'),
   ( flight(_, _, phx, _, _) ->
     writeln("  Yes, there is at least one flight to PHX.")
   ; writeln("  No, there are no flights to PHX.")
   ),
   nl.

% Question 3: What time does the flight from BOS land?
:- writeln('Question 3: What time does the flight from BOS land?'),
   ( flight(_, bos, _, _, ArrivalTime),
     format("  Arrival time = ~w~n", [ArrivalTime]),
     fail
   ; true ),
   nl.

% Question 4: Does the flight from ORD to SFO depart after the flight from EWR to ORD lands?
:- writeln('Question 4: Does the flight from ORD to SFO depart after the flight from EWR to ORD lands?'),
   ( flight(_, ord, sfo, DepTime1, _),
     flight(_, ewr, ord, _, ArrTime2),
     DepTime1 @> ArrTime2 ->
       writeln("  Yes, it departs after.")
   ;   writeln("  No, it does not depart after.")
   ),
   nl.

% Question 5: What time do the flights to ORD arrive?
:- writeln('Question 5: What time do the flights to ORD arrive?'),
   ( flight(_, _, ord, _, ArrivalTime),
     format("  Arrival time = ~w~n", [ArrivalTime]),
     fail
   ; true ),
   nl.

% Question 6: All the ways to get from LGA to LAX with time feasibility (list of flight numbers):
:- writeln('Question 6: All the ways to get from LGA to LAX (list of flight numbers):'),
   ( route_with_time(lga, lax, Path),
     format("  ~w~n", [Path]),
     fail
   ; true ),
   nl.

% Optional: Close the output file if using tell/2 above:
:- told.