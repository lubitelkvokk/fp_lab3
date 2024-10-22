-module(lab3).
-compile([debug_info]).
-export([start/0, loop/1]).

% Функция запуска процесса
start() ->
    Pid_process_point = interpolation_process:spawn_process_point([{0.0, 0.0}, {1.571, 1}]),
    Pid_output = output:spawn_output_process(),
    Pid_manager = manager:spawn_manage_algorithm_io_process(Pid_process_point, self(), Pid_output),
    spawn(?MODULE, loop, [Pid_manager]).

% Основной цикл, который ожидает ввода от пользователя
loop(Pid_manage_process) ->
    io:format("Введите число (или 'stop' для завершения): "),
    % Считываем строку
    Input = io:get_line(""),
    % Убираем лишние пробелы и переводы строк
    case string:trim(Input) of
        "stop" ->
            io:format("Процесс завершает работу~n"),
            ok;
        TrimmedInput ->
            try
                [X, Y] = re:split(TrimmedInput),
                {X_flaot, _} = string:to_float(X),
                {Y_float, _} = string:to_float(Y),
                Pid_manage_process ! {self(), {X_flaot, Y_float}},
                loop(Pid_manage_process)
            catch
                _ ->
                    %% some catching logic
                    loop(Pid_manage_process)
            end
    end.
