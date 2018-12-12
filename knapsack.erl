-module(knapsack).

-export([init/0, solve/5]).

% barang-barang yang bisa diambil
% list berisi {"nama", value, weight}
-define(ITEMS,
	[{"grapefruits", 4, 60}, {"mozzarella", 18, 12},
	 {"paprika", 50, 160}, {"eggs", 15, 60},
	 {"flounder", 10, 160}, {"watermelons", 13, 36},
	 {"salt", 39, 40}, {"tomato", 23, 30}, {"clams", 62, 10},
	 {"duck", 22, 70}, {"cucumbers", 263, 200},
	 {"truffles", 28, 22}, {"cherries", 68, 45},
	 {"cinnamon", 27, 60}, {"banana", 42, 70},
	 {"apple", 43, 75}, {"rice", 22, 80}, {"cloves", 7, 20},
	 {"cabbage", 4, 50}, {"guavas", 30, 10}]).

% maksimal total weight yang dapat dibawa
-define(MAX_WEIGHT, 500).

init() ->
    io:format("Persoalan Knapsack menggunakan Erlang~n"),
    {ItemList, TotalValue, TotalWeight} = solve(?ITEMS,
						?MAX_WEIGHT, [], 0, 0),
    io:format("Barang-barang yang diambil: ~n"),
    [io:format("~p~n", [Item]) || Item <- ItemList],
    io:format("Value Total: ~p~nWeight Total: ~p~n",
	      [TotalValue, TotalWeight]).

% fungsi inti knapsack

% jika tidak ada barang yang bisa diambil
solve([], _TotalWeightLeft, ItemAcc, ValueAcc,
      WeightAcc) ->
    {ItemAcc, ValueAcc, WeightAcc};

% jika barang pertama (head) tidak bisa diambil
% maka dibuang dari list
solve([{_Item, ItemWeight, _ItemValue} | T],
      TotalWeightLeft, ItemAcc, ValueAcc, WeightAcc)
    when ItemWeight > TotalWeightLeft ->
    solve(T, TotalWeightLeft, ItemAcc, ValueAcc, WeightAcc);

% handle barang yang mungkin akan diambil
solve([{ItemName, ItemWeight, ItemValue} | T],
      TotalWeightLeft, ItemAcc, ValueAcc, WeightAcc) ->

    % kondisi jika barang tidak diambil
    {_TailItemAcc, TailValueAcc, _TailWeightAcc} = TailRes =
						       solve(T, TotalWeightLeft,
							     ItemAcc, ValueAcc,
							     WeightAcc),

    % kondisi jika barang diambil
    {_HeadItemAcc, HeadValueAcc, _HeadWeightAcc} = HeadRes =
						       solve(T,
							     TotalWeightLeft -
							       ItemWeight,
							     [ItemName
							      | ItemAcc],
							     ValueAcc +
							       ItemValue,
							     WeightAcc +
							       ItemWeight),

    % ambil kasus yang akan memperbesar nilai value akhir
    case TailValueAcc > HeadValueAcc of
      true -> TailRes;
      false -> HeadRes
    end.
