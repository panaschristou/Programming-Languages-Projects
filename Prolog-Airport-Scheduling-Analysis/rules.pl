:- consult('flights.pl').

% ------------------------------------------
% direct_route(X, Y, FlightNo):
%   Is there a direct flight from X to Y?
% ------------------------------------------
direct_route(X, Y, FlightNo) :-
    flight(FlightNo, X, Y, _, _).

% ------------------------------------------
% route(X, Y, Path):
%   Finds a sequence of flights from X to Y
%   (tracking visited airports to avoid loops)
% ------------------------------------------
route(X, Y, Path) :-
    route_helper(X, Y, [X], Path).

% Base case:
%   If there is a direct flight from X to Y,
%   then the path is simply [FlightNo].
route_helper(X, Y, _, [FlightNo]) :-
    direct_route(X, Y, FlightNo).

% Recursive case:
%   If there is a direct flight from X to Z (F1)
%   and Z has not yet been visited,
%   then find a route from Z to Y (recursively).
route_helper(X, Y, Visited, [F1 | Rest]) :-
    direct_route(X, Z, F1),
    \+ member(Z, Visited),          % make sure Z is not already visited
    route_helper(Z, Y, [Z | Visited], Rest).