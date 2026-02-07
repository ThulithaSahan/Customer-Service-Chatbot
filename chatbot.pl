% Knowledge Base
product(iphone_14, smartphone, 80000).
product(macbook_air, laptop, 150000).
product(ipad_pro, tablet, 120000).
product(airpods_pro, headphones, 25000).
product(apple_watch, smartwatch, 45000).
product(imac, desktop, 200000).
product(mac_mini, desktop, 60000).
product(apple_tv, streaming_device, 15000).
product(homepod, smart_speaker, 30000).
product(magic_keyboard, accessory, 12000).

% Stock information
in_stock(iphone_14).
in_stock(ipad_pro).
in_stock(airpods_pro).
in_stock(apple_watch).
in_stock(magic_keyboard).

% Mapping names to internal product atoms
name_map("iphone 14", iphone_14).
name_map("macbook air", macbook_air).
name_map("ipad pro", ipad_pro).
name_map("airpods pro", airpods_pro).
name_map("apple watch", apple_watch).
name_map("imac", imac).
name_map("mac mini", mac_mini).
name_map("apple tv", apple_tv).
name_map("homepod", homepod).
name_map("magic keyboard", magic_keyboard).

% Rules
available(Item) :- in_stock(Item).
price(Item, Price) :- product(Item, _, Price).
type(Item, Type) :- product(Item, Type, _).


start :-
    write("Hi this is Vista Phone shop's customer service"),nl,
    write("You can ask questions about product availability, price or type of a product"),nl,
    chat_loop.

chat_loop :-
    write("Ask your question: "),

    %Captures string until user press enters, and the entered line is bound to "input"
    read_line_to_string(user_input, Input),

    process_input(Input).


process_input(Input):-
    string_lower(Input, Lowercase_input),%converts line to lowercase.
    (

     Lowercase_input == "exit", Lowercase_input ="exit" -> write("Goodbye!"),!;

     contains(Lowercase_input, "price") -> handle_price_query(Lowercase_input), chat_loop;
     contains(Lowercase_input, "type") -> handle_type_query(Lowercase_input), chat_loop;
     contains(Lowercase_input, "available") -> handle_availability_query(Lowercase_input), chat_loop;


     write("Sorry, I did not understand the question"),nl ,chat_loop

    ).

contains(String, Substring):-
    sub_string(String,_,_,_,Substring).


% Map user input to internal atom
find_product(Input, Product) :-
    name_map(UserName, Product),
    contains(Input, UserName).


product_display_name(Product, DisplayName) :-
    name_map(DisplayName, Product).


handle_price_query(Input) :-
    (   find_product(Input, Product) ->
            price(Product, Price),
            product_display_name(Product, Name),
            format("The ~w costs LKR ~w~n", [Name, Price])
    ;   write("Please specify a valid product you want to know the price of."), nl
    ).



handle_type_query(Input) :-
    (   find_product(Input, Product) ->
            type(Product, Type),
            product_display_name(Product, Name),
            format("The ~w is a ~w~n", [Name, Type])
    ;   write("Please specify a valid product you want to know the type of."), nl
    ).



handle_availability_query(Input) :-
    (   find_product(Input, Product) ->
            product_display_name(Product, Name),
            (available(Product) ->
                format("The ~w is available.~n", [Name])
            ;   format("The ~w is not available.~n", [Name])
            )
    ;   write("Please specify a valid product you want to check availability for."), nl
    ).
