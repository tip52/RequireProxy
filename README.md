NOTE: THIS IS READ ONLY AS I DIDNT GET AROUND TO ADDING WRITE CAPABILITY TO THIS
-> (you can call functions tho)
-> this is due to how the table reconstruction works and shit across lua vms which is really gay

another note: this heavily relies on custom indexes to check which function is which as the table conversion between lua vms is ass and makes indexes go whack

I started writing this around 2 weeks ago, and slowly lost motivation to work on it. for this to work you need to have a level 2 script running the code for level 2, and a level 3 script to execute this (assuming you don't have the require flag set)

you can call the functions from the table and get their results.
-> does work on nested tables

this code is very bug prone and I suggest you test it in a roblox game if you want to modify it


tested mainly on solara and xeno
