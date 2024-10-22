-module(interpolation).
-compile([debug_info]).
-export([
    find_polynom_L_x/2,
    get_list_of_interpolation_points/2,
    get_list_of_linear_interpolation_points/2
]).

-include("interpolation.hrl").

-spec get_list_of_interpolation_points(points(), integer()) -> points().
-spec get_list_of_linear_interpolation_points(points(), integer()) -> points().

get_list_of_linear_interpolation_points(Points, Step) ->
    [One, Two | _] = lists:reverse(Points),
    {X1, _} = One,
    {X2, _} = Two,
    gloip([Two, One], X2, X1, Step, []).

get_list_of_interpolation_points(Points, Step) ->
    {MinX, _} = lists:nth(1, Points),
    {MaxX, _} = lists:max(Points),
    gloip(Points, MinX, MaxX, Step, []).

gloip(Points, Curr, Bound, _, Acc) when Curr >= Bound ->
    [{Curr, find_polynom_L_x(Curr, Points)} | Acc];
gloip(Points, Curr, Bound, Step, Acc) ->
    gloip(Points, Curr + Step, Bound, Step, [{Curr, find_polynom_L_x(Curr, Points)} | Acc]).

find_polynom_L_x(X, Points) ->
    find_polynom_L_x(X, Points, length(Points), 0).

find_polynom_L_x(_, _, 0, Acc) ->
    Acc;
find_polynom_L_x(X, Points, Ptr, Acc) ->
    {X_i, Y_i} = lists:nth(Ptr, Points),
    find_polynom_L_x(X, Points, Ptr - 1, Acc + Y_i * linear_l_i(X, X_i, Points, 1)).

linear_l_i(_, _, [], Acc) ->
    Acc;
linear_l_i(X, X_j, [{X_j, _} | Points], Acc) ->
    linear_l_i(X, X_j, Points, Acc);
linear_l_i(X, X_i, [{X_j, _} | Points], Acc) ->
    linear_l_i(X, X_i, Points, Acc * ((X - X_j) / (X_i - X_j))).
