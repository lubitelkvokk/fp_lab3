-module(interpolation_process).
-import(interpolation, [
    get_list_of_interpolation_points/2, get_list_of_linear_interpolation_points/2
]).
-export([
    spawn_process_point/1,
    process_point/1,
    store_point/2,
    interpolate_by_lagrange/2,
    interpolate_by_linear/2,
    get_points/1
]).

spawn_process_point(InitialPoints) ->
    spawn(?MODULE, process_point, [InitialPoints]).

store_point(Pid, Point) ->
    Pid ! {self(), {store, Point}},
    receive
        Msg -> Msg
    end.

%% Функция для получения текущих точек
get_points(Pid) ->
    Pid ! {self(), getPoints},
    receive
        Msg -> Msg
    end.

interpolate_by_lagrange(Pid, Step) ->
    Pid ! {self(), {lagrange_interpolate, Step}},
    receive
        Msg -> Msg
    end.

interpolate_by_linear(Pid, Step) ->
    Pid ! {self(), {linear_interpolate, Step}},
    receive
        Msg -> Msg
    end.

process_point(Points) ->
    receive
        {From, {store, Point}} ->
            %% Сохраняем новую точку в список и подтверждаем сохранение

            % Обновляем список точек
            NewPoints = Points ++ [Point],
            From ! {ok, successfull_storing},
            % Рекурсивно вызываем процесс с обновленным списком
            process_point(NewPoints);
        {From, {lagrange_interpolate, Step}} ->
            From ! {self(), {ok, get_list_of_interpolation_points(Points, Step)}},
            process_point(Points);
        {From, {linear_interpolate, Step}} ->
            From ! {self(), {ok, get_list_of_linear_interpolation_points(Points, Step)}},
            process_point(Points);
        {From, getPoints} ->
            From ! {ok, Points},
            process_point(Points);
        {From, _} ->
            From ! {unexpected},
            process_point(Points);
        _ ->
            process_point(Points)
    end.
