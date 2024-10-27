-module(lab3).
-compile([debug_info]).
-export([start/0, loop/1]).

% Функция запуска процесса
start() ->
    Pid_process_point = interpolation_process:spawn_process_point([]),
    Pid_output = output:spawn_output_process(),
    Pid_manager = manager:spawn_manage_algorithm_io_process(Pid_process_point, Pid_output),
    spawn(?MODULE, loop, [Pid_manager]).

% Основной цикл, который ожидает ввода от пользователя
loop(Pid_manage_process) ->
    timer:sleep(50),
    io:format("Введите число (или 'stop' для завершения):~n"),
    % Считываем строку
    Input = io:get_line(""),
    % Убираем лишние пробелы и переводы строк
    case string:trim(Input) of
        "stop" ->
            io:format("Процесс завершает работу~n"),
            ok;
        TrimmedInput ->
            try
                [X, Y] = re:split(TrimmedInput, " "),
                {X_result, X_value} = util:string_to_float(X),
                {Y_result, Y_value} = util:string_to_float(Y),
                if
                    X_result == ok, Y_result == ok ->
                        Pid_manage_process ! {self(), {X_value, Y_value}};
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
