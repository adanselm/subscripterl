subscripterl
============

# This is deprecated. I moved to an Elixir-Phoenix based solution, available [here](https://github.com/adanselm/sbapi).

Subscripterl is an Erlang/OTP Application to manage your customers' access to your products:
* Create a database of users and products
* Generate a key pair for you to embed in your product (only the public key of course)
* Create a serial number and key file to send to your user when they buy your software

Client application will then have to:
* Decode the key file using the public key
* Check the data with what the user supplied (serial, expiration date, email, ... you can modify the server to embed whatever you need, the only limit is the bigger the data, the bigger the RSA key)

Usage
-----
Edit ``priv/sys.config`` with your database details: ``{hostname, "127.0.0.1"}, {database, "db1"}, {username, "db1"}, {password, "abc123"}``

Run the server:

    ./start.sh
Interface:

    1> subscripterl:create_user("user@test.com").
        {ok,<<"c2226e10-0a10-413d-b516-cc4ab2165a8c">>}
    2> {ok, PublicKey} = subscripterl:create_product("test_product_v1").
        {ok,<<"5e38b49d-2cde-422c-93b6-951a15082a89">>,
            "000281,00110DC3BD5CBCABF4105D7B88EB4DF2E1F85A1A67A9A9BCB51A0EEDD8A2D401816FE68EB1A6B60498E5ADF6F6DF5E64953BFAD5E9D11035FFC916665122BCE8F3DBEEBF58EAB222BFF2148F2A13CE5B49D565E373A82FAC633345B489C1F2101C4914D2777FF7FA03694B242B9E9B6EEC51CF6B0E5AB5D2170E8EAF8CE6F3928AF913E79CE915434EEB38C9C1FAFB383C148526AD8A15213FC5D62355B7C81831E69CF3E728932E8A4231D8F9DAA151B8F75B239AE1D666B8319F615E04A9E6B6D66932125C682F5A752420C29356B46B2FB77A87E9AD265425B7BC16695DC51BB0C5881988EFA4CE3807455B9BDD734C2FA540F3939B552A447"}
    3> {ok, Serial, KeyFileData} = subscripterl:generate_product_key("user@test.com", "test_product_v1").
        {ok,<<"6492ed41-7967-4805-a111-c81b5da62b84">>,
            <<10,32,54,49,183,131,49,239,181,228,253,28,162,47,113,
              236,77,135,53,2,40,139,20,81,7,245,...>>}
      
Disclaimer
----------
* Don't spend too much time fighting software crackers, it's not worth it. Just discourage the average Joe to use a disassembler.
Unfortunately, all the work has to be done in the client application. This server won't help you at all.
* This code is not production ready yet

Todo
----
* unit tests
* exceptions
* retries on database timeouts
* public key format change (depending on what is easiest to implement on client side)

License
-------
BSD (to be added to each file)
