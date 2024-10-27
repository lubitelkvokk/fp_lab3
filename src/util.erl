-module(util).
-export([string_to_float/1]).
-spec string_to_float(String :: string()) -> {ok, float()} | {error, term()}.

string_to_float(String) ->
    {Result, Msg} = string:to_float(String),
    case Result of
        error ->
            if
                Msg == no_float ->
                    {Int, _} = string:to_integer(String),
                    {ok, float(Int)};
                true ->
                    {error, "isn't number"}
            end;
        _ ->
            {ok, Result}
    end.
