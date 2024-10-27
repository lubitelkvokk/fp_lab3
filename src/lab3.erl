-module(lab3).
-compile([debug_info]).
-export([start/2, loop/1, main/1]).

main(Args) ->
    % io:format("Loaded modules: ~p~n", [code:all_loaded()]),

    Options = parse_args(Args),
    {InterpolationAlgorithms, Step} = get_options(Options),

    %% Начало основного цикла для обработки ввода точек
    io:format(
        "Program started with algorithms: ~p and frequency: ~p~n",
        [InterpolationAlgorithms, Step]
    ),
    lab3:start(InterpolationAlgorithms, Step).

parse_args(Args) ->
    lists:foldl(
        fun
            ("--algorithms=" ++ Rest, Acc) ->
                %% Переводим строковые значения в атомы
                Algorithms = [list_to_atom(X) || X <- string:split(Rest, ",", all)],
                [{algorithms, Algorithms} | Acc];
            ("--frequency=" ++ Rest, Acc) ->
                Step = list_to_integer(Rest),
                [{frequency, Step} | Acc];
            (_, Acc) ->
                Acc
        end,
        [],
        Args
    ).

get_options(Options) ->
    InterpolationAlgorithms = proplists:get_value(algorithms, Options, ['linear']),
    Step = proplists:get_value(frequency, Options, 1),
    {InterpolationAlgorithms, Step}.
% Функция запуска процесса
start(InterpolationAlgorithms, Step) ->
    Pid_process_point = interpolation_process:spawn_process_point([]),
    Pid_output = output:spawn_output_process(),
    Pid_manager = manager:spawn_manage_algorithm_io_process(
        Pid_process_point, Pid_output, InterpolationAlgorithms, Step
    ),
    loop(Pid_manager).
% spawn(?MODULE, loop, [Pid_manager, InterpolationAlgorithms, Step]).

% Основной цикл, который ожидает ввода от пользователя
loop(Pid_manage_process) ->
    timer:sleep(50),
    io:format("Enter number (or 'stop' for finishing):~n"),
    % Считываем строку
    Input = io:get_line(""),
    % Убираем лишние пробелы и переводы строк
    case string:trim(Input) of
        "stop" ->
            io:format("Process is finishing a work~n"),
            ok;
        TrimmedInput ->
            try
                [X, Y] = re:split(TrimmedInput, " "),
                {X_result, X_value} = util:string_to_float(X),
                {Y_result, Y_value} = util:string_to_float(Y),
                if
                    X_result == ok, Y_result == ok ->
                        Pid_manage_process ! {interpolate, {X_value, Y_value}};
                    true ->
                        ok
                end,
                loop(Pid_manage_process)
            catch
                Error ->
                    %% some catching logic
                    io:format("~p", Error),
                    loop(Pid_manage_process)
            end
    end.
