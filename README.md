# Programming-Languages-Projects
Programming languages Projects exploring different programming paradigms.

## Instructions
### Procedural & OOP Languages (Planet Properties)  
To run the projects that are python notebook files on google colab you will need to mount your google drive or upload the data manually.  
The data was given as a text file so they need to be read in and then converted to JSON format.
### Functional Programming Languages (OCaml Binary Arithmetic Terminal)  
**Requirements:**  
```
opam
ocaml-lsp-server
```
MAC Instructions:  
1. Install opam switch with  
```
bash -c "sh <(curl -fsSL https://opam.ocaml.org/install.sh)"
```
2. Install the OCaml Language Server  
```
opam install ocaml-lsp-server
```
3. Compile the program
```
ocamlc -o binary_arithmetic binary_arithmetic.ml
```
4. Run the program
```
./binary_arithmetic
```
### Logic Programming Languages (Prolog Airport Scheduling Analysis)  
**Requirements:**  
```
swi-prolog
New-VSC-Prolog
```
1. Install swi-prolog with  
```
brew install swi-prolog
```
2. Install the VS Code Prolog extension from the VS Code Marketplace
```
New-VSC-Prolog
```
3. Open the Prolog REPL using the following command in the terminal
```
swipl
```
4. Run all the queries batched in the queries file with
```
?- consult('queries.pl').
```
5. Close the Prolog REPL by pressing or typing
```
CMT/CTRL + d
```
This will generate an output file with the results of all the questions answered in sequence.

**Warning:** You might need to add Prolog to the Path by following the following Instructions
1. Open VS Code Preferences by using 
```
CMD/CNTRL + SHIFT + P
```
1. Search for 
```
Prolog
```
1. Change the Executable Path, for MAC, if you installed it in Applications, to the following:
```
/Applications/SWI-Prolog.app/Contents/MacOS
```