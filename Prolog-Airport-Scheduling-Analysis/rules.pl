:- consult('flights.pl').

% ------------------------------------------
% direct_route(X, Y, FlightNo, DepTime, ArrTime):
%   Is there a direct flight from X to Y with its departure and arrival times?
% ------------------------------------------
direct_route(X, Y, FlightNo, DepTime, ArrTime) :-
    flight(FlightNo, X, Y, DepTime, ArrTime).

% ------------------------------------------
% route_with_time(X, Y, Path):
%   Finds a sequence of flights (by flight numbers) from X to Y,
%   ensuring that for each connection the next flight departs after the previous one lands.
%   It uses a helper predicate that tracks the visited airports and the previous flight’s arrival time.
% ------------------------------------------
route_with_time(X, Y, Path) :-
    route_time_helper(X, Y, none, [X], Path).

% Base case:
%   There is a direct flight from X to Y that meets the time constraint.
%   If PrevArrTime is 'none', it's the first flight; otherwise, the departure time must be later.
route_time_helper(X, Y, PrevArrTime, _Visited, [FlightNo]) :-
    direct_route(X, Y, FlightNo, DepTime, _),
    (PrevArrTime = none ; DepTime @> PrevArrTime).

% Recursive case:
%   Find a flight from X to an intermediate airport Z that departs after PrevArrTime,
%   ensure Z has not been visited, and then recursively find the route from Z to Y.
route_time_helper(X, Y, PrevArrTime, Visited, [F1 | Rest]) :-
    direct_route(X, Z, F1, DepTime, ArrTime),
    (PrevArrTime = none ; DepTime @> PrevArrTime),
    \+ member(Z, Visited),  % avoid loops by not revisiting an airport
    route_time_helper(Z, Y, ArrTime, [Z | Visited], Rest).