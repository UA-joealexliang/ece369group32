Create task lists here `<br />`

<<<<<<< HEAD
* [ ] make Hi_in Lo_in feed into ALU32Bit [CAMERON] <br />
* [ ] there should be 2 muxes for PC Counter [CAMERON] <br />
  -first one takes in PC+4 and PC+4+offset,  choice is determined by AND Gate {branch, Zero} <br />
  -second one takes in result of first one and  immediate/register value, choice is determined by jump control <br />
* [ ] update controller and datapath to support movn, movz [CAMERON] <br />
  -RegWrite = 0 for movn, movz; writing is determined by OR Gate {RegWrite, RegWrite2} <br />
  -Create an OR logic gate to connect WriteRegister and WriteRegister2 into RegisterFile, if either is 1 then RegisterFile will perform write <br />
* [ ] support j, jr, jal [CAMERON] <br />
  -jr takes in rs or 25-21; need another mux to choose between immediate and register value <br />
  -jal updates register 31 with PC+4; need another mux <br />
* [✔] modify DataMemory to work with all loads & stores, need to add another controller signal, and add SignExtend [JOE] <br />
  -sh, lh only modifies 16 bits <br />
  -sb, lb only modifes 8 bits <br />
  -lh, lb need to be sign-extended before placed into Write (Joe implemented this into DataMemory file) <br />
  -CONTROLLER SIGNAL ADDED: Datatype <br />
* [ ] Load InstructionMemory.txt from file instead of hardcoding into module <br />
* [ ] Input funct codes into ALU [ASHTON] <br />
  -fix controller to work with all instruction types <br />
  -replace all 'X' by commenting it out (means don't care by not changing it); not sure if 'X' works in Vivado, there were syntax errors <br />
=======
* [✔] make Hi_in Lo_in feed into ALU32Bit [CAMERON] `<br />`
* [✔] there should be 2 muxes for PC Counter [CAMERON] `<br />`
  -first one takes in PC+4 and PC+4+offset,  choice is determined by AND Gate {branch, Zero} `<br />`
  -second one takes in result of first one and  immediate/register value, choice is determined by jump control `<br />`

* [ ] update controller and datapath to support movn, movz [CAMERON] `<br />`
  -RegWrite = 0 for movn, movz; writing is determined by OR Gate {RegWrite, RegWrite2} `<br />`
  -Create an OR logic gate to connect WriteRegister and WriteRegister2 into RegisterFile, if either is 1 then RegisterFile will perform write `<br />`
* [ ] support j, jr, jal [CAMERON] `<br />`
  -jr takes in rs or 25-21; need another mux to choose between immediate and register value `<br />`
  -jal updates register 31 with PC+4; need another mux `<br />`

* [✔] modify DataMemory to work with all loads & stores, need to add another controller signal, and add SignExtend [JOE] `<br />`
  -sh, lh only modifies 16 bits `<br />`
  -sb, lb only modifes 8 bits `<br />`
  -lh, lb need to be sign-extended before placed into Write (Joe implemented this into DataMemory file) `<br />`
  -CONTROLLER SIGNAL ADDED: Datatype `<br />`

* [ ] Load InstructionMemory.txt from file instead of hardcoding into module [ASHTON] `<br />`
* [ ] Input funct codes into ALU [ASHTON] `<br />`
  -fix controller to work with all instruction types `<br />`
  -[✔] replace all 'X' by commenting it out (means don't care by not changing it); not sure if 'X' works in Vivado, there were syntax errors `<br />`
>>>>>>> ee6c6505fe1e802892bcaf49efb9545aa29ea927
